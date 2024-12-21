//
//  StreamFooterView.swift
//  LiveStream
//
//  Created by Aamir on 12/21/24.
//


import Foundation
import UIKit
import Lottie

protocol RoseActionDelegate {
    func roseTapped(for videoData: VideoData)
}

protocol ShareActionDelegate {
    func shareTapped(for videoData: VideoData)
}

class StreamFooterView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var bottomConstraintComment: NSLayoutConstraint!
    @IBOutlet weak var handView: UIView!
    @IBOutlet weak var lblJoined: UILabel!
    @IBOutlet weak var viewJoined: UIView!
    @IBOutlet weak var imgProfileSentRose: UIImageView!
    @IBOutlet weak var lblUserSentRose: UILabel!
    @IBOutlet weak var lblNumberOfRoses: UILabel!
    @IBOutlet weak var viewRose: UIView!
    @IBOutlet weak var viewComment: UIView!
    
    var timer: Timer?
    var comments: [CommentData] = []
    var videoData: VideoData!
    var currentIndex = 0
    var isUserInteracting = false
    var defaultConstant: CGFloat = 0

    private var animationView: LottieAnimationView?
    var roseActionDelegate: RoseActionDelegate?
    var shareActionDelegate: ShareActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("StreamFooterView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CommentTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(showingKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func awakeFromNib() {
        populateComments()
        setupAnimation()
        layoutComponents()
    }
    
    func layoutComponents() {
        viewComment.layer.cornerRadius = 18.0
        viewRose.layer.cornerRadius = 14.0
        handView.layer.cornerRadius = handView.bounds.width / 2
        imgProfileSentRose.layer.cornerRadius = imgProfileSentRose.bounds.width / 2
        
        txtComment.delegate = self
        defaultConstant = bottomConstraintComment.constant

        let atr = NSAttributedString(string: "user123", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        let joined = NSAttributedString(string: "joined", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        let mutable = NSMutableAttributedString(attributedString: atr)
        mutable.append(joined)
        lblJoined.attributedText = mutable
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.viewJoined.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.viewJoined.isHidden = true
            }
        }
    }
    
    func populateComments() {
        comments = MockDataConverter.getComments()
        tableView.reloadData()
        if comments.count > 0 {
            lblUserSentRose.text = comments[0].username
            imgProfileSentRose.kf.setImage(with: URL(string: comments[0].picURL))
        }
    }
    
    @objc func scrollToNextComment() {
        if currentIndex < comments.count - 1 {
            currentIndex += 1
            let indexPath = IndexPath(row: currentIndex, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        } else {
            timer?.invalidate()
        }
    }
    
    @IBAction func roseTapped(_ sender: Any) {
        roseActionDelegate?.roseTapped(for: videoData)
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        shareActionDelegate?.shareTapped(for: videoData)
    }
}

//MARK: Lottie Like Animation
extension StreamFooterView {
    func setupAnimation() {
        animationView = .init(dotLottieName: "LikeAnimation")
        animationView!.frame = lottieView.bounds
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.4
        animationView!.layer.opacity = 0.0
        lottieView.addSubview(animationView!)
    }
    
    func animateLike() {
        if let animationView = animationView {
            animationView.layer.opacity = 1.0
            animationView.play { completed in
                if completed {
                    animationView.layer.opacity = 0.0
                }
            }
        }
    }
    
    func startAnimatingComments() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.scrollToNextComment()
        }
    }
}

extension StreamFooterView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.comment = comments[indexPath.row]
        cell.alpha = 1.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 39
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 39
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}

//MARK: ScrollViewDelegates
extension StreamFooterView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let visibleRows = tableView.indexPathsForVisibleRows else { return }
        
        if let topMostIndexPath = visibleRows.first {
            if let topMostCell = tableView.cellForRow(at: topMostIndexPath) {
                if timer?.isValid ?? false {
                    topMostCell.alpha = 0.5
                } else {
                    topMostCell.alpha = 1.0
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserInteracting = true
        timer?.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isUserInteracting = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserInteracting = false
    }
}

//MARK: TextFieldDelegate
extension StreamFooterView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            comments.append(CommentData(id: comments.count + 1, username: "You", picURL: comments[0].picURL, comment: text))
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: comments.count - 1, section: 0), at: .bottom, animated: true)
            txtComment.text = ""
        }
        
        return true
    }
}

//MARK: Keyboard Notifications
extension StreamFooterView {
    @objc func showingKeyboard(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.5) {
                self.bottomConstraintComment.constant = keyboardRectangle.height
            }
            
        }
    }
    
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.5) {
            self.bottomConstraintComment.constant = self.defaultConstant
        }
    }
}
    

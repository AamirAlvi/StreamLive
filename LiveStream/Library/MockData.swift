//
//  MockData.swift
//  LiveStream
//
//  Created by Aamir on 12/21/24.
//

import Foundation
import AVFoundation


struct MockDataConverter {
    
    static func getVideos() -> [VideoData] {
        if let videos = VIDEOS_MOCK_DATA["videos"] as? [[String: Any]] {
            return arrayOfDictionariesToStructs(videos, type: VideoData.self) ?? []
            
        }
        return []
    }
    
    static func getComments() -> [CommentData] {
        if let comments = COMMENTS_MOCKDATA["comments"] as? [[String: Any]] {
            return arrayOfDictionariesToStructs(comments, type: CommentData.self) ?? []
        }
        return []
    }
    
    static func arrayOfDictionariesToStructs<T: Codable>(_ array: [[String: Any]], type: T.Type) -> [T]? {
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: [])
            let decodedObjects = try JSONDecoder().decode([T].self, from: data)
            return decodedObjects
        } catch {
            print("Error converting array of dictionaries to structs: \(error)")
            return nil
        }
    }
}


struct VideoData: Codable, Equatable {
    static func ==(lhs: VideoData, rhs: VideoData) -> Bool {
        return lhs.id == rhs.id
    }
    var id: Int
    var userID: Int
    var username: String
    var profilePicURL: String
    var description: String
    var topic: String
    var viewers: Int
    var likes: Int
    var video: String
    var thumbnail: String
    var isCurrent: Bool = false
    var avPlayer: AVPlayer?
    
    enum CodingKeys: CodingKey {
        case id
        case userID
        case username
        case profilePicURL
        case description
        case topic
        case viewers
        case likes
        case video
        case thumbnail
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.username = try container.decode(String.self, forKey: .username)
        self.profilePicURL = try container.decode(String.self, forKey: .profilePicURL)
        self.description = try container.decode(String.self, forKey: .description)
        self.topic = try container.decode(String.self, forKey: .topic)
        self.viewers = try container.decode(Int.self, forKey: .viewers)
        self.likes = try container.decode(Int.self, forKey: .likes)
        self.video = try container.decode(String.self, forKey: .video)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        
        let playerItem = AVPlayerItem(url: URL(string: video)!)
        let player = AVPlayer(playerItem: playerItem)
        avPlayer = player

    }
}

struct CommentData: Codable {
    var id: Int
    var username: String
    var picURL: String
    var comment: String
}

let VIDEOS_MOCK_DATA: [String: Any] = [
    "videos": [
        [
            "id": 1235,
            "userID": 83048,
            "username": "amanda",
            "profilePicURL": "https://d2uj5sc6syma2y.cloudfront.net/images/66afcae0827ddxx9wk.png",
            "description": "The Best Tacos You've Ever Had! #tacos #food #foodie #foodporn #delicious #tasty #mexicanfood #streetfood #eat #foodphotography",
            "topic": "tasting",
            "viewers": 11,
            "likes": 3,
            "video": "https://d2uj5sc6syma2y.cloudfront.net/video/66ac8ea93b90c.mp4",
            "thumbnail": "https://d2uj5sc6syma2y.cloudfront.net/thum/66ac8eabac954.png",
        ],
        [
            "id": 1450,
            "userID": 313,
            "username": "eric",
            "profilePicURL": "https://lh3.googleusercontent.com/a/ACg8ocJNXi0SbYgYfhuic-iTtILDGNdprPcHVVGh-JIeCe_b6UCB0hXMpg=s96-c",
            "topic": "restos",
            "viewers": 202,
            "likes": 22,
            "description": "French food at San Jose #french ",
            "video": "https://d2uj5sc6syma2y.cloudfront.net/video/66b9883a9e85e.mp4",
            "thumbnail": "https://d2uj5sc6syma2y.cloudfront.net/thum/66b9883eca0b1.png",
        ],
        [
            "id": 1783,
            "userID": 83286,
            "username": "sonia",
            "profilePicURL": "https://d2uj5sc6syma2y.cloudfront.net/images/6668ae9925514tu9gp.png",
            "topic": "sharing",
            "viewers": 444,
            "likes": 44,
            "description": "Tasty celebrations. #mediterranean #private_chef #celebrate",
            "video": "https://d2uj5sc6syma2y.cloudfront.net/video/66f1f67580200.mp4",
            "thumbnail": "https://d2uj5sc6syma2y.cloudfront.net/thum/66f1f67a3ab98.png",
        ],
        [
            "id": 1739,
            "userID": 83286,
            "username": "jenny",
            "profilePicURL": "https://d2uj5sc6syma2y.cloudfront.net/images/66b39065727f5lxaww.png",
            "topic": "grilling",
            "viewers": 9,
            "likes": 4,
            "description": "#kanpachi #torch #grilled #calamaki #farmersmarket ",
            "video": "https://d2uj5sc6syma2y.cloudfront.net/video/66edaf9fa7781.mp4",
            "thumbnail": "https://d2uj5sc6syma2y.cloudfront.net/thum/66edafa5cca29.png",
        ],
        [
            "id": 1515,
            "userID": 83076,
            "username": "carter",
            "profilePicURL": "https://firebasestorage.googleapis.com:443/v0/b/liver-2024.appspot.com/o/vendor%2FmjjrNA78XdYMbjkaXWk1dMD9KYn1%2FprofileImage.jpeg?alt=media&token=021afab8-312c-450c-9c93-f15228032c9f",
            "topic": "new eats",
            "viewers": 11242,
            "likes": 545,
            "description": "The Best Halal Chicken Cutlet Sandwich in NYC #halalfood #nycfoodie #foodporn #chickensandwich #streetfood #nycfood #foodie #delicious #musttry #naanbread",
            "video": "https://d2uj5sc6syma2y.cloudfront.net/video/66d7ceb6b2c12.mp4",
            "thumbnail": "https://d2uj5sc6syma2y.cloudfront.net/thum/66d7ceb8e6cfc.png",
        ]
    ]
]

let COMMENTS_MOCKDATA: [String: Any] = [
    "comments": [
        [
            "id": 1,
            "username": "jnaisbitt0",
            "picURL": "https://fastly.picsum.photos/id/474/200/200.jpg?hmac=X5gJb746aYb_1-VdQG2Cti4XcHC10gwaOfRGfs6fTNk",
            "comment": "consequat metus sapien ut nunc vestibulum ante ipsum primis in"
        ],
        [
            "id": 2,
            "username": "thuxtable1",
            "picURL": "https://fastly.picsum.photos/id/552/200/200.jpg?hmac=99yztwFcmd6Y23V7ViL1mArbh9wwdxbIjS9bhO8xyY8",
            "comment": "accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam"
        ],
        [
            "id": 3,
            "username": "abunker2",
            "picURL": "https://fastly.picsum.photos/id/564/200/200.jpg?hmac=uExb18W9rplmCwAJ9SS5NVsLaurpaCTCBuHZdhsW25I",
            "comment": "venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris"
        ],
        [
            "id": 4,
            "username": "icheatle3",
            "picURL": "https://fastly.picsum.photos/id/477/200/200.jpg?hmac=pGA68LBET23UPGB7L8xL1pA7PYT_x7JazGX__CnlliU",
            "comment": "cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus"
        ],
        [
            "id": 5,
            "username": "dgilbard4",
            "picURL": "https://fastly.picsum.photos/id/212/200/200.jpg?hmac=U4JUx4PJyTuKdZEPAk2Cw01YZM8rOypF8fTTO39POko",
            "comment": "vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac"
        ],
        [
            "id": 6,
            "username": "cgerred5",
            "picURL": "https://fastly.picsum.photos/id/200/200/200.jpg?hmac=mk1Tu6dXHQvpaA8RfxlDUZjbWG23krNkiB9kyYoEmO8",
            "comment": "primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse"
        ],
        [
            "id": 7,
            "username": "ssunley6",
            "picURL": "https://fastly.picsum.photos/id/397/200/200.jpg?hmac=3VBYe8NBAUuvEizTQB0-d8wp2jgqMblJK8vH3h8cslE",
            "comment": "libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh"
        ],
        [
            "id": 8,
            "username": "aivanenko7",
            "picURL": "https://fastly.picsum.photos/id/781/200/200.jpg?hmac=QS4V9UziNCgGW5Nv84Kaun5Xgfx0l8qXNBmtPBClPJo",
            "comment": "sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis"
        ],
        [
            "id": 9,
            "username": "rparsons8",
            "picURL": "https://fastly.picsum.photos/id/742/200/200.jpg?hmac=4nZLLJ-llxH8rGFtBoMYolYN6ArLNdOU9SGrDLzV1Xw",
            "comment": "morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui"
        ],
        [
            "id": 10,
            "username": "whowsan9",
            "picURL": "https://fastly.picsum.photos/id/607/200/200.jpg?hmac=ULikjE_L4XAS018UC9F2dCEiYIPKAFUW8oBDI2LzduY",
            "comment": "quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus"
        ],
        [
            "id": 11,
            "username": "scolbrona",
            "picURL": "https://fastly.picsum.photos/id/961/200/200.jpg?hmac=gHwrXvhjUL97oGKmAYQn508wdQ_V5sE9P64erzR-Ork",
            "comment": "nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci"
        ],
        [
            "id": 12,
            "username": "sseivwrightb",
            "picURL": "https://fastly.picsum.photos/id/62/200/200.jpg?hmac=IdjAu94sGce82DBYTMbOYzXr7kup1tYqdr0bHkRDWUs",
            "comment": "turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis"
        ],
        [
            "id": 13,
            "username": "abannisterc",
            "picURL": "https://fastly.picsum.photos/id/501/200/200.jpg?hmac=tKXe69j4tHhkAA_Qc3XinkTuubEWwkFVhA9TR4TmCG8",
            "comment": "ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam"
        ],
        [
            "id": 49,
            "username": "aguiett1c",
            "picURL": "https://fastly.picsum.photos/id/865/200/200.jpg?hmac=YU_vd-bJ6z9YfrQwr6tDOm--FtikU1rNpyxItCoIOgQ",
            "comment": "donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris"
        ],
        [
            "id": 50,
            "username": "nsemrad1d",
            "picURL": "https://fastly.picsum.photos/id/593/200/200.jpg?hmac=E26lTUTkzs_AeuWXrkT-kFTudfYDTVCjgKVE_HDzRmk",
            "comment": "ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque"
        ]
    ]
]


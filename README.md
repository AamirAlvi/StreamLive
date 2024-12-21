# Live Stream Playback and Commenting UI

## Working Code Video
Video Link: https://drive.google.com/file/d/1o8XeR9YADEsiQrXlmfr9Ngyi3paCs4-i/view?usp=share_link

## Overview
This project is a pixel-perfect implementation of a "live" stream playback and commenting UI, similar to TikTok live streaming. It features smooth animations, dynamic content display, and user interaction capabilities.

## Features
- **Full-Screen Video Playback:**
  - Uses `AVFoundation` for video playback.
  - Video loops automatically.
  - Full-screen `UICollectionViewCell` to ensure one video per swipe.
- **Interactive Comments Section:**
  - Displays mock comments in a transparent `UITableView`.
  - Comments scroll into view every 2 seconds.
  - Supports adding new comments via a text field.
  - Animations for adding and scrolling comments.
- **Dynamic Data Display:**
  - Displays username, profile picture, viewers count, and likes.
  - Uses mock JSON data for videos and comments.
- **Gesture Interactions:**
  - Swipe up/down to navigate between videos.
  - Double-tap to display a floating heart animation.
  - Single-tap to pause/resume video.
- **Smooth Animations:**
  - Cell's alpha for topmost comments.
  - Floating heart animation using Lottie/CoreAnimation.
- **Keyboard Handling:**
  - Text field pushes UI up when the keyboard appears.

## Technical Details
### Tools & Frameworks
- Language: Swift
- Frameworks: `UIKit`, `AVFoundation`, `CoreAnimation`
- UI: Storyboard with AutoLayout
- Animation: Lottie/CoreAnimation
- Data Handling: Mock JSON

### Architecture
- `UICollectionView` for displaying full-screen videos.
- `UITableView` for overlaying comments.
- `UIViewController` for handling user interactions and keyboard events.
- Separate data models for videos and comments.

### JSON Mock Data
#### Videos
The mock video data is structured in a JSON format, containing properties like `username`, `profilePicURL`, `viewers`, `likes`, and `video` URLs.
#### Comments
The mock comment data includes `username`, `picURL`, and `comment` fields to simulate a live commenting system.

### Animations
- Double-tap heart animation is implemented using the Lottie library.
- Cell's alpha is applied to the comments section for visual effect.

## Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Open the project in Xcode:
   ```bash
   cd <project-directory>
   open LiveStreamPlayback.xcodeproj
   ```
3. Install dependencies using CocoaPods (if applicable):
   ```bash
   pod install
   ```
4. Build and run the project on a simulator or physical device.

## Usage
1. Launch the app to see the full-screen video playback UI.
2. Swipe up/down to navigate between videos.
3. Tap the comment text field to add a new comment.
4. Double-tap the video to trigger the heart animation.
5. Single-tap the video to pause/resume playback.

## Future Improvements
- Integrate real API calls for dynamic data.
- Enhance UI responsiveness with advanced animations.
- Add error handling for missing or corrupted video files.

## License
This project is for demonstration purposes and is not intended for production use.


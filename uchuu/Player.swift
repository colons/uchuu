import AVKit
import MediaPlayer
import UIKit

class UchuuPlayerDelegate: NSObject, AVPlayerViewControllerDelegate {
    static let sharedInstance = UchuuPlayerDelegate()

    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        UIApplication.shared.keyWindow?.rootViewController!.present(playerViewController, animated: true, completion: {
            completionHandler(true)
        })
    }

    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool {
        return true
    }
}

func setupNowPlayingStuff(_ player: AVPlayer) {
    let commandCenter = MPRemoteCommandCenter.shared()

    commandCenter.playCommand.isEnabled = true
    commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
        player.play()
        return .success
    }

    commandCenter.pauseCommand.isEnabled = true
    commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
        player.pause()
        return .success
    }
}

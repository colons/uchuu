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

class UchuuPlaylistViewController: UIViewController {
    var playerController = AVPlayerViewController()
    var queuePlayer = AVQueuePlayer()
    @IBOutlet weak var playerContainer: UIView!
    @IBOutlet weak var playlistTable: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        playerContainer.addSubview(playerController.view)
        playerController.view.frame = playerContainer.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSLog("im gone")  // we need to remove ourselves from the heirarchy
    }
}

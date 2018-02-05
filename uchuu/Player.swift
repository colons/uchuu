import AVKit

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

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var urlField: UITextField!

    @IBAction func playSpecifiedVideo(_ sender: UIButton) {
        playVideo(url: urlField.text!)
    }

    override func viewDidAppear(_ animated: Bool) {
        urlField.text = "https://www.youtube.com/watch?v=1Cs0qyG78qY"
        super.viewDidAppear(animated)
    }

    private func playVideo(url: String) {
        YtdlService().getVideoInfo(ytdlUrl: url, completionHandler: self.playFromYtdlInfo)
    }
    
    private func playFromYtdlInfo(info: VideoInfo) {
        let asset = AVURLAsset(url: info.url, options: ["AVURLAssetHTTPHeaderFieldsKey": info.http_headers])
        let item = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: item)
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.delegate = UchuuPlayerDelegate.sharedInstance

        present(playerController, animated: true) {
            player.play()
        }
    }
}

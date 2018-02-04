import UIKit
import AVKit

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        askUserForVideo()
    }
    
    private func askUserForVideo() {
        var urlField: UITextField?
        let alert = UIAlertController(title: "Video URL", message: "Please provide the web URL of the video you want to play", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            urlField = textField
        })
        alert.addAction(UIAlertAction(title: "Play", style: .default, handler: { action in
            self.playVideo(url: urlField!.text!)
        }))
        present(alert, animated: true, completion: nil)
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
        present(playerController, animated: true) {
            player.play()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


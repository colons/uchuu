import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var playButton: UIButton!

    @IBAction func pressPlayButton(_ sender: UIButton) {
        playVideo(url: urlField.text!)
    }

    @IBAction func submitUrlField(_ sender: UITextField) {
        playVideo(url: urlField.text!)
    }

    override func viewDidAppear(_ animated: Bool) {
        if (urlField.text == nil) || (urlField.text == "") {
            urlField.text = "https://www.youtube.com/watch?v=V80Isj9JK1s"
        }
        super.viewDidAppear(animated)
    }

    public func playVideo(url: String) {
        let playerController = YtdlService().getPlayerController(ytdlUrl: url)
        self.present(playerController, animated: true)
    }
}

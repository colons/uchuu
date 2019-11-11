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

    @IBAction func showPlayer(_ sender: UIButton) {
        if (currentPlayer == nil) {
            NSLog("nothing is currently playing")  // this should be shown to the user
        } else {
            self.present(currentPlayer!, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (urlField.text == nil) || (urlField.text == "") {
            urlField.text = "https://www.youtube.com/watch?v=O2yPnnDfqpw"
        }
        super.viewDidAppear(animated)
    }

    public func playVideo(url: String) {
        let shouldPresent = (currentPlayer == nil)
        let playerController = YtdlService().getPlayerController(ytdlUrl: url)
        if (shouldPresent) {
            self.present(playerController, animated: true)
        }
    }
}

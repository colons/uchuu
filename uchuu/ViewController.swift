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

    public func playVideo(url: String) {
        YtdlService().getPlayerController(ytdlUrl: url) { playerController in
            self.present(playerController, animated: true) {
                playerController.player!.play()
            }
        }
    }
}

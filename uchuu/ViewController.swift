import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var urlField: UITextField!

    @IBAction func playSpecifiedVideo(_ sender: UIButton) {
        playVideo(url: urlField.text!)
    }

    override func viewDidAppear(_ animated: Bool) {
        if (urlField.text == nil) || (urlField.text == "") {
            urlField.text = "https://www.youtube.com/watch?v=1Cs0qyG78qY"
        }
        super.viewDidAppear(animated)
    }

    public func playVideo(url: String) {
        let playerController = YtdlService().getPlayerController(ytdlUrl: url)
        self.present(playerController, animated: true)
    }
}

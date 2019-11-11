import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var playButton: UIButton!

    @IBAction func pressPlayButton(_ sender: UIButton) {
        YtdlService().playURL(urlField.text!)
    }

    @IBAction func submitUrlField(_ sender: UITextField) {
        YtdlService().playURL(urlField.text!)
    }

    override func viewDidAppear(_ animated: Bool) {
        if (urlField.text == nil) || (urlField.text == "") {
            urlField.text = "https://www.youtube.com/watch?v=O2yPnnDfqpw"
        }
        super.viewDidAppear(animated)
    }
}

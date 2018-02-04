import Foundation
import UIKit

class ShareViewController: UIViewController {
    @objc func openURL(_ url: URL) {
        return
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var url = URLComponents(string: "uchuu://play")!
        url.queryItems = [
            URLQueryItem(name: "url", value: "https://youtu.be/6LOo6ocToHU"),
        ]
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))
        
        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: url.url!)
                return
            }
            responder = responder?.next
        }
    }
}

import Foundation
import UIKit

class ShareViewController: UIViewController {
    @objc func openURL(_ url: URL) {
        return
    }
    
    func openUchuu(_ videoUrl: URL) {
        var targetUrl = URLComponents(string: "uchuu://play")!

        targetUrl.queryItems = [
            URLQueryItem(name: "url", value: videoUrl.absoluteString),
        ]
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(self.openURL(_:))

        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: targetUrl.url!)
                break
            }
            responder = responder?.next
        }
        exit(0)
    }

    override func viewDidAppear(_ animated: Bool) {
        let item = self.extensionContext!.inputItems.first as! NSExtensionItem
        for attachment in item.attachments! {
            attachment.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { urlItem, error in
                guard let videoUrl = urlItem as! URL? else { return }
                self.openUchuu(videoUrl)
            })
            attachment.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { urlItem, error in
                guard let videoUrl = URL(string: urlItem as! String) else { return }
                self.openUchuu(videoUrl)
            })
        }
    }
}

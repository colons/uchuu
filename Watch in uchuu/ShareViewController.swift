import Foundation
import UIKit

class ShareViewController: UIViewController {
    @objc func openURL(_ url: URL) {
        return
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let item = self.extensionContext!.inputItems.first as! NSExtensionItem
        let attachment = item.attachments!.first as! NSItemProvider
        attachment.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { urlItem, error in
            let videoUrl = urlItem as! URL
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
        })
    }
}

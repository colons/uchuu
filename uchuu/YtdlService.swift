import Foundation

struct VideoInfo: Codable {
    var http_headers: [String: String]
    var url: URL
}

class YtdlService {
    func getVideoInfo(ytdlUrl:String, completionHandler: @escaping (VideoInfo) -> Void) {
        var url = URLComponents(string: "https://uchuu.colons.co/")!
        url.queryItems = [
            URLQueryItem(name: "url", value: ytdlUrl),
        ]
        let task = URLSession.shared.dataTask(with: url.url!) { data, response, error in
            if let error = error {
                print("some kind of connection error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("bad http code")
                return
            }
            let videoInfo = try! JSONDecoder().decode(VideoInfo.self, from: data!)
            completionHandler(videoInfo)
        }
        task.resume()
    }
}

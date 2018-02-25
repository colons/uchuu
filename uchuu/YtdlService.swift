import AVKit
import Foundation

struct YTDLResponse: Codable {
    var _type: String?
}

struct VideoFormat: Codable {
    var http_headers: [String: String]
    var url: URL
}

struct VideoInfo: Codable {
    var title: String
    var description: String
    var uploader: String
    var webpage_url: URL
    
    var selected_format: VideoFormat
}

struct Playlist: Codable {
    var entries: [VideoInfo]
    var title: String
    var webpage_url: URL
    var uploader: String
}

class YtdlService {
    func getPlaylist(ytdlUrl: String, completionHandler: @escaping (Playlist) -> Void) {
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
            let responseData = try! JSONDecoder().decode(YTDLResponse.self, from: data!)

            if (responseData._type != nil) && (responseData._type! == "playlist") {
                completionHandler(try! JSONDecoder().decode(Playlist.self, from: data!))
            } else {
                let videoInfo = try! JSONDecoder().decode(VideoInfo.self, from: data!)
                completionHandler(Playlist(
                    entries: [videoInfo],
                    title: videoInfo.title,
                    webpage_url: videoInfo.webpage_url,
                    uploader: videoInfo.uploader
                ))
            }
        }
        task.resume()
    }
    
    private func play(_ playlist: Playlist, in queuePlayer: AVQueuePlayer) {
        queuePlayer.removeAllItems()

        for entry in playlist.entries {
            let asset = AVURLAsset(url: entry.selected_format.url, options: ["AVURLAssetHTTPHeaderFieldsKey": entry.selected_format.http_headers])
            queuePlayer.insert(AVPlayerItem(asset: asset), after: nil)
        }

        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { print("Failed to get control of media session :<") }

        queuePlayer.play()
    }

    func getPlayerController(ytdlUrl: String) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        let player = AVQueuePlayer()

        setupNowPlayingStuff(player)

        playerController.delegate = UchuuPlayerDelegate.sharedInstance
        playerController.player = player

        getPlaylist(ytdlUrl: ytdlUrl, completionHandler: { playlist in
            self.play(playlist, in:player)
        });

        return playerController
    }
}

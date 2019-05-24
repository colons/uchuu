import AVKit
import Foundation

let ytdlQueue = DispatchQueue(label: "ytdlQueue", attributes: .concurrent)

struct YTDLResponse: Codable {
    var _type: String?
}

struct VideoFormat: Codable {
    var http_headers: [String: String]
    var url: URL
}

struct VideoInfo: Codable {
    var title: String
    var description: String?
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
        ytdlQueue.async {
            let data = PythonBridge.run(ytdlUrl)
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

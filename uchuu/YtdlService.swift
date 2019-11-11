import Foundation
import AVKit

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

    private func play(_ playlist: Playlist, _ playlistViewController: UchuuPlaylistViewController) {
        let qp = playlistViewController.playerController.player! as! AVQueuePlayer
        NSLog(playlist.title)
        
        for entry in playlist.entries {
            let asset = AVURLAsset(url: entry.selected_format.url, options: ["AVURLAssetHTTPHeaderFieldsKey": entry.selected_format.http_headers])
            qp.insert(AVPlayerItem(asset: asset), after: nil)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { print("Failed to get control of media session :<") }
        
        playlistViewController.playerController.player!.play()
    }

    func playURL(_ ytdlUrl: String) {
        let playlistViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playlist") as! UchuuPlaylistViewController
        let queuePlayer = AVQueuePlayer()
        playlistViewController.playerController.player = queuePlayer
        UIApplication.shared.keyWindow?.rootViewController!.show(playlistViewController, sender: self)
        setupNowPlayingStuff(queuePlayer)
        getPlaylist(ytdlUrl: ytdlUrl, completionHandler: { playlist in
            DispatchQueue.main.async {
                playlistViewController.title = playlist.title
            }
            self.play(playlist, playlistViewController)
        });
    }
}

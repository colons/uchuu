import Foundation
import AVKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundedPlayer: AVPlayer?
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let components = URLComponents(string: url.absoluteString)
        let playerController = YtdlService().getPlayerController(ytdlUrl: components!.queryItems![0].value!)

        application.keyWindow?.rootViewController!.present(playerController, animated: true)

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()

        do { try audioSession.setCategory(AVAudioSessionCategoryPlayback) }
        catch { print("Setting category to AVAudioSessionCategoryPlayback failed.") }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    private func getCurrentPlayerController(_ application: UIApplication) -> AVPlayerViewController? {
        let presentedView = application.keyWindow?.rootViewController?.presentedViewController
        return presentedView as? AVPlayerViewController
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let playerController = getCurrentPlayerController(application)
        if playerController != nil && playerController!.player != nil {
            backgroundedPlayer = playerController!.player
            playerController!.player = nil
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let playerController = getCurrentPlayerController(application)
        if playerController != nil && backgroundedPlayer != nil {
            playerController!.player = backgroundedPlayer
            backgroundedPlayer = nil
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


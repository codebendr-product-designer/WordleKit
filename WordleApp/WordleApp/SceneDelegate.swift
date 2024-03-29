import UIKit
import ScoreClientLive
import WordleKit
import ScoreFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: WordleKit.ScoreViewController(.init(scoreClient: .polling, isPolling: false)))
        window.makeKeyAndVisible()
        self.window = window
    }
    
}


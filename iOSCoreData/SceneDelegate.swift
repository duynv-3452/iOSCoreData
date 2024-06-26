//
//  SceneDelegate.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {

        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

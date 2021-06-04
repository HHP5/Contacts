//
//  SceneDelegate.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var coordinator: SceneCoordinator?
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		guard let window = window else { return }
		coordinator = SceneCoordinator(window: window)
		coordinator?.start()
	}
	
	func sceneDidEnterBackground(_ scene: UIScene) {
		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
	}
}

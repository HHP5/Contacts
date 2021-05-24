//
//  SceneDelegate.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var coordinator: MainCoordinator?
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		window = UIWindow(windowScene: windowScene)
		
		let navBar = UINavigationController()
		coordinator = MainCoordinator(navigationController: navBar)
		coordinator?.start()
		
		window?.overrideUserInterfaceStyle = .light

		window?.makeKeyAndVisible()
		window?.rootViewController = navBar
	}
	
	func sceneDidEnterBackground(_ scene: UIScene) {
		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
	}
}

//
//  SceneDelegate.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		window = UIWindow(windowScene: windowScene)
		
		window?.overrideUserInterfaceStyle = .light

		window?.makeKeyAndVisible()
		let viewController = ViewController()
		
		let navBar = UINavigationController(rootViewController: viewController)
		window?.rootViewController = navBar
	}
}

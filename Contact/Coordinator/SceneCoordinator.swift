//
//  SceneCoordinator.swift
//  Contact
//
//  Created by Екатерина Григорьева on 04.06.2021.
//

import UIKit

class SceneCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	var window: UIWindow
	var navigationController = UINavigationController()
	
	init(window: UIWindow) {
		self.window = window
		window.makeKeyAndVisible()
		window.overrideUserInterfaceStyle = .light
		
		window.rootViewController = navigationController
	}
	
	func start() {
		let coordinator = MainCoordinator(navigationController: navigationController)
		childCoordinators.append(coordinator)
		coordinator.start()		
	}
}

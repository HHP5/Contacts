//
//  Coordinator.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//

import UIKit

protocol Coordinator {
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController { get set }

	func start()
}
class MainCoordinator: Coordinator {
	var navigationController: UINavigationController
	var childCoordinators:[Coordinator] = []
	
	init(navigationController: UINavigationController) {
			self.navigationController = navigationController
		}
	
	func start() {
		let vc = MainListController(viewModel: MainListViewModel())
		vc.coordinator = self
		navigationController.pushViewController(vc, animated: false)
	}
	
}

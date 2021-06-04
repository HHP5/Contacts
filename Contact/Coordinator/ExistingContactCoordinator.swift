//
//  ExistingContactCoordinator.swift
//  Contact
//
//  Created by Екатерина Григорьева on 04.06.2021.
//

import UIKit

class ExistingContactCoordinator: Coordinator {
	
	var childCoordinators: [Coordinator] = []
	
	private var contact: Person?
	var navigationController: UINavigationController
	
	init(contact: Person?, navigationController: UINavigationController) {
		self.contact = contact
		self.navigationController = navigationController
	}
	
	func start() {
		showContact()
	}
	
	private func showContact() {
		let viewModel = ContactPageViewModel(contact: contact)
		viewModel.existCoordinator = self
		let viewController = ExistingContactPageController(viewModel: viewModel)
		navigationController.viewControllers.append(viewController)

	}
	
	private func navigationToEditingPage() {
		let coordinator = EditingContactCoordinator(contact: contact, navigationController: navigationController)
		childCoordinators.append(coordinator)
		coordinator.start()
	}
	
}

extension ExistingContactCoordinator: ExistContactCoordinatorDelegate {
	func edit(contact: Person?) {
		navigationToEditingPage()
	}
}

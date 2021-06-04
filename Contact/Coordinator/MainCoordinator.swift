//
//  Coordinator.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//

import UIKit

class MainCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		showContactList()
	}
	
	private func showContactList() {
		let viewModel = MainListViewModel()
		viewModel.coordinator = self
		let viewController = MainListController(viewModel: viewModel)
		navigationController.viewControllers = [viewController]
	}

	private func navigateToExistingContact(_ contact: Person?) {
		let coordinator = ExistingContactCoordinator(contact: contact, navigationController: navigationController)
		childCoordinators.append(coordinator)
		coordinator.start()

	}
	
	private func navigateToEditingContact(_ contact: Person?) {
		let coordinator = EditingContactCoordinator(contact: contact, navigationController: navigationController)
		childCoordinators.append(coordinator)
		coordinator.start()
	}
}

extension MainCoordinator: MainCoordinatorDelegate {
	func contactsListViewModel(didSelect contact: Person?, type: ContactDetailPageType) {
		switch type {
		case .existing:
			navigateToExistingContact(contact)
		case .editing:
			navigateToEditingContact(contact)
		}
	}
}

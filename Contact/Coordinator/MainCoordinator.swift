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
		viewModel.delegate = self
		let viewController = MainListController(viewModel: viewModel)
		navigationController.viewControllers = [viewController]
	}

	private func navigateToExistingContact(_ contact: Contact) {
		let coordinator = ExistingContactCoordinator(contact:  ContactModel(contact: contact), navigationController: navigationController)
		coordinator.parentCoordinator = self
		childCoordinators.append(coordinator)
		coordinator.start()

	}
	
	private func navigateToEditingContact() {
		let coordinator = EditingContactCoordinator(contact: nil, navigationController: navigationController)
		coordinator.parentCoordinator = self
		childCoordinators.append(coordinator)
		coordinator.start()
	}
}

extension MainCoordinator: MainListViewModelDelegate {
	func mainListViewModel(_ viewModel: MainListViewModel, didSelect contact: Contact) {
		navigateToExistingContact(contact)
	}
	func сontactPageViewModelDidRequestCreateContact(_ viewModel: MainListViewModel) {
		navigateToEditingContact()
	}
}

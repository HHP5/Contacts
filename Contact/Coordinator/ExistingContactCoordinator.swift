//
//  ExistingContactCoordinator.swift
//  Contact
//
//  Created by Екатерина Григорьева on 04.06.2021.
//

import UIKit

class ExistingContactCoordinator: Coordinator {
	
	var childCoordinators = [Coordinator]()
	
	private var contact: ContactModelType?
	var navigationController: UINavigationController
	weak var parentCoordinator: Coordinator?
	
	init(contact: ContactModelType?, navigationController: UINavigationController) {
		self.contact = contact
		self.navigationController = navigationController
	}
	
	func start() {
		showContact()
	}
	
	private func showContact() {
		let viewModel = ContactPageViewModel(contact: contact)
		viewModel.delegate = self
		let viewController = ExistingContactPageController(viewModel: viewModel)
		navigationController.pushViewController(viewController, animated: true)
	}
	
	private func navigationToEditingPage() {
		let coordinator = EditingContactCoordinator(contact: contact, navigationController: navigationController)
		coordinator.parentCoordinator = self
		coordinator.start()
		childCoordinators.append(coordinator)
	}
}

extension ExistingContactCoordinator: ContactPageViewModelDelegate {
	func сontactPageViewModel(_ viewModel: ContactPageViewModel) {
		navigationToEditingPage()
	}
	
	func сontactPageViewModelDidRequestGoBack(_ viewModel: ContactPageViewModel) {
		parentCoordinator?.childDidFinish(self)
	}
}

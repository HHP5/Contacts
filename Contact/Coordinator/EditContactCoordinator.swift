//
//  EditContactCoordinator.swift
//  Contact
//
//  Created by Екатерина Григорьева on 04.06.2021.
//

import UIKit

class EditingContactCoordinator: Coordinator {
	var childCoordinators: [Coordinator] = []
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
		let viewController = EditingContactViewContoller(viewModel: viewModel)
		navigationController.pushViewController(viewController, animated: true)
	}

}

extension EditingContactCoordinator: ContactPageViewModelDelegate {
	func сontactPageViewModel(_ viewModel: ContactPageViewModel) {
		// тут теперь этот метод болтается просто так
	}
	
	func сontactPageViewModelDidRequestGoBack(_ viewModel: ContactPageViewModel) {
		parentCoordinator?.childDidFinish(self)
	}
}

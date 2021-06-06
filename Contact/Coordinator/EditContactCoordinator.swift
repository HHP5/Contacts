//
//  EditContactCoordinator.swift
//  Contact
//
//  Created by Екатерина Григорьева on 04.06.2021.
//

import UIKit

class EditingContactCoordinator: Coordinator {

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
		viewModel.editCoordinator = self
		let viewController = EditingContactViewContoller(viewModel: viewModel)
		navigationController.pushViewController(viewController, animated: true)
	}
	
	func finish() {
		navigationController.popViewController(animated: true)
	}
}

extension EditingContactCoordinator: EditContactCoordinatorDelegate {
	func backToPreviousScreen() {
		finish()
	}
}

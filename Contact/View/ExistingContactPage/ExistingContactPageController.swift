//
//  ExistingContactPageController.swift
//  Contact
//
//  Created by Екатерина Григорьева on 02.06.2021.
//

import UIKit

class ExistingContactPageController: UIViewController {
	var viewModel: ContactPageViewModelType? {
		willSet(viewModel) {
			guard let viewModel = viewModel else { return }
			self.screenView.setupModel(viewModel: viewModel)
		}
	}
	
	var screenView = ExistingContactPageView()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.setupNavigationBar()
		self.screenView.deleteContactButton = self
    }
    
	override func loadView() {
		self.view = screenView
	}
    
	private func setupNavigationBar() {
		self.navigationItem.backBarButtonItem?.title = "Contact"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
																 target: self,
																 action: #selector(editPressed))
	}
	
	@objc
	private func editPressed() {
		let destinationVC = AddNewContactPageController()
		destinationVC.viewModel = viewModel
		self.navigationController?.pushViewController(destinationVC, animated: true)
	}

}

extension ExistingContactPageController: DeleteButtonDelegate {
	func pressed() {
		viewModel?.deleteContact()
		self.navigationController?.popViewController(animated: true)
	}
}

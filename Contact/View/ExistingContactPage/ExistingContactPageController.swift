//
//  ExistingContactPageController.swift
//  Contact
//
//  Created by Екатерина Григорьева on 02.06.2021.
//

import UIKit

class ExistingContactPageController: UIViewController {
	var viewModel: ContactPageViewModelType
	
	var screenView = ExistingContactPageView()
	
	init(viewModel: ContactPageViewModelType) {
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.setupNavigationBar()
		self.screenView.deleteContactButton = self
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.viewModel.reloadData()
		self.screenView.setupModel(viewModel: viewModel)

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
		viewModel.editContact()
	}
}

extension ExistingContactPageController: ExistingContactPageViewDelegate {
	func existingContactPageViewDeleteButtonPressed(_ view: ExistingContactPageView) {
		viewModel.deleteContact()
	}

}

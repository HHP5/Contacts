//
//  MainCoordinatorDelegate.swift
//  Contact
//
//  Created by Екатерина Григорьева on 04.06.2021.
//

import Foundation

protocol MainListViewModelDelegate: class {
	func mainListViewModel(_ viewModel: MainListViewModel, didSelect contact: Contact)
	func mainListViewModelCreateContact(_ viewModel: MainListViewModel)
}

//
//  MainCoordinatorDelegate.swift
//  Contact
//
//  Created by Екатерина Григорьева on 04.06.2021.
//

import Foundation

protocol MainCoordinatorDelegate: class {
	func contactsListViewModel(didSelect contact: Person?, type: ContactDetailPageType)
}

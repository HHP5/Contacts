//
//  ExistContactDelegate.swift
//  Contact
//
//  Created by Екатерина Григорьева on 04.06.2021.
//

import Foundation

protocol ContactPageViewModelDelegate: class {
	func сontactPageViewModel(_ viewModel: ContactPageViewModel)
	func сontactPageViewModelDidRequestGoBack(_ viewModel: ContactPageViewModel)
}

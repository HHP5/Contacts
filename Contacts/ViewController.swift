//
//  ViewController.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//

import UIKit

class ViewController: UIViewController, UISearchControllerDelegate {
	private let searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search"
		searchController.searchBar.backgroundColor = .clear
		searchController.searchBar.tintColor = .black
		return searchController
	}()
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 0.8146950603, green: 0.8098530769, blue: 0.8184176087, alpha: 1)
		
		searchController.delegate = self
		
		navigationItem.title = "Contacts"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusPressed))
		navigationItem.searchController = searchController
	}

	@objc private func plusPressed() {
		
	}
}

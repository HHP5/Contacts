//
//  MainListViewModelType.swift
//  Contact
//
//  Created by Екатерина Григорьева on 24.05.2021.
//

import Foundation

protocol MainListViewModelType {
	var numberOfSections: Int {get}
	var sectionIndexTitles: [String]? {get}
	func numberOfRowsInSection(in section: Int) -> Int
	func titleForHeaderInSection(in section: Int) -> String?
	func sectionForSectionIndexTitle(for index: Int) -> Int
	func cellForRow(at indexPath: IndexPath) -> String?
	func search(for text: String)
	func cancelSearch()
	func didSelectContact(at indexPath: IndexPath)
	func emptyContact() 
	func reloadData()
}

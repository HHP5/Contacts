//
//  MainListViewModel.swift
//  Contact
//
//  Created by Екатерина Григорьева on 24.05.2021.
//

import UIKit

class MainListViewModel: MainListViewModelType {
	// MARK: - Properties
	weak var delegate: MainListViewModelDelegate?
	
	var numberOfSections: Int {
		return collation.sectionTitles.count
	}
	
	var sectionIndexTitles: [String]? {
		return collation.sectionIndexTitles
	}
	
	private var contactList: [Contact] = []
	
	private var fullContactList: [Contact] = []
	
	private let collation = UILocalizedIndexedCollation.current()
	private var sections: [[Contact]] = []
	// MARK: - Init

	init() {
		self.fullContactList = FullContactList().fullContactList
		self.contactList = self.fullContactList
		self.setupSection(with: fullContactList)
	}
	// MARK: - Public Methods

	func titleForHeaderInSection(in section: Int) -> String? {
		return collation.sectionTitles[section]
	}
	
	func sectionForSectionIndexTitle(for index: Int) -> Int {
		return collation.section(forSectionIndexTitle: index)
	}
	
	func numberOfRowsInSection(in section: Int) -> Int {
		return sections[section].count
	}

	func cellForRow(at indexPath: IndexPath) -> String? {
		var result: String?
		let section = sections[indexPath.section]
		let firstName = section[indexPath.row].firstName
		let lastName = section[indexPath.row].lastName
		result = "\(String(describing: firstName ?? "")) \(String(describing: lastName ?? ""))"
		return result
	}
	
	func search(for text: String) {
		let result: [Contact] = fullContactList.filter { contact in
			let byFirstName = contact.firstName?.lowercased().contains(text) ?? false
			let byLastName = contact.lastName?.lowercased().contains(text) ?? false
			return byLastName || byFirstName
		}
		setupSection(with: result)
	}
	
	func cancelSearch() {
		setupSection(with: fullContactList)
	}
	
	func didSelectContact(at indexPath: IndexPath) {
		let section = sections[indexPath.section]
		let contact = section[indexPath.row]
		delegate?.mainListViewModel(self, didSelect: contact)
	}

	func createNewContact() {

		delegate?.сontactPageViewModelDidRequestCreateContact(self)
	}
	
	func reloadData() {
		self.fullContactList = FullContactList().fullContactList
		self.setupSection(with: fullContactList)
	}
	// MARK: - Private Methods

	private func setupSection(with contactList: [Contact]) {
		self.sections = [[Contact]](repeating: [], count: collation.sectionTitles.count)

		for contact in contactList {
			let sectionNumber = collation.section(for: contact, collationStringSelector: #selector(getter: Contact.lastName))
			sections[sectionNumber].append(contact)
		}
	}
}

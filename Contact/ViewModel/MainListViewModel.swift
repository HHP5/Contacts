//
//  MainListViewModel.swift
//  Contact
//
//  Created by Екатерина Григорьева on 24.05.2021.
//

import UIKit

class MainListViewModel: MainListViewModelType {
	// MARK: - Properties
	var numberOfSections: Int {
		return collation.sectionTitles.count
	}
	
	var sectionIndexTitles: [String]? {
		return collation.sectionIndexTitles
	}
	
	private var contactList: [Person] = []
	
	private var fullContactList: [Person] = []
	
	private var model = ContactList()
	private let collation = UILocalizedIndexedCollation.current()
	private var sections: [[Person]] = []
	// MARK: - Init

	init() {
		self.fullContactList = model.getContactList()
		self.contactList = self.fullContactList
		self.setupSection(with: fullContactList)
		
//		self.model.deleteAllData()
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
		if let firstName = section[indexPath.row].firstName, let lastName = section[indexPath.row].lastName {
			result = "\(String(describing: firstName)) \(String(describing: lastName))"
		}
		return result
	}
	
	func search(for text: String) {
		let result: [Person] = fullContactList.filter { contact in
			let byFirstName = contact.firstName?.lowercased().contains(text) ?? false
			let byLastName = contact.lastName?.lowercased().contains(text) ?? false
			return byLastName || byFirstName
		}
		setupSection(with: result)
	}
	
	func cancelSearch() {
		setupSection(with: fullContactList)
	}
	
	func didSelectRowAt(_ indexPath: IndexPath) -> ContactPageViewModelType? {
		let section = sections[indexPath.section]
		let contact = section[indexPath.row]
		return ContactPageViewModel(contact: contact)
	}
	
	func emptyContact() -> ContactPageViewModelType? {
		return ContactPageViewModel(contact: nil)
	}
	
	func reloadData() {
		self.fullContactList = model.getContactList()
		self.setupSection(with: fullContactList)
	}
	// MARK: - Private Methods

	private func setupSection(with contactList: [Person]) {
		let selector: Selector = Selector(Constans.selectorForSection)
		self.sections = [[Person]](repeating: [], count: collation.sectionTitles.count)
		
		for name in contactList {
			let sectionNumber = collation.section(for: name, collationStringSelector: selector)
			sections[sectionNumber].append(name)
		}
	}
}

//
//  MainListViewModel.swift
//  Contact
//
//  Created by Екатерина Григорьева on 24.05.2021.
//

import UIKit

protocol MainListViewModelType {
	var numberOfSections: Int {get}
	var sectionIndexTitles: [String]? {get}
	var names: [Person] {get}
	func numberOfRowsInSection(in section: Int) -> Int
	func titleForHeaderInSection(in section: Int) -> String?
	func sectionForSectionIndexTitle(for index: Int) -> Int
	func cellForRow(at indexPath: IndexPath) -> String?
}

class MainListViewModel: MainListViewModelType {
	
	var numberOfSections: Int {
		return collation.sectionTitles.count
	}
	
	var sectionIndexTitles: [String]? {
		return collation.sectionIndexTitles
	}
	
	var names: [Person] {
		model.loadNameList()
		if model.persons.isEmpty {
			model.createNameList()
		}
		return model.persons
	}
	
	private var model = NameList()
	private let collation = UILocalizedIndexedCollation.current()
	private var sections: [[Person]] = []
	
	init() {
		self.setupSection()
	}
	
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
	
	private func setupSection() {
		let selector: Selector = Selector(("lastName"))
		self.sections = [[Person]](repeating: [], count: collation.sectionTitles.count)
		
		for name in names {
			let sectionNumber = collation.section(for: name, collationStringSelector: selector)
			sections[sectionNumber].append(name)
		}
	}
}

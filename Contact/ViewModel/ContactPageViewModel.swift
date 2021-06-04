//
//  ContactPageViewModel.swift
//  Contact
//
//  Created by Екатерина Григорьева on 28.05.2021.
//

import UIKit

class ContactPageViewModel: ContactPageViewModelType {
	weak var existCoordinator: ExistContactCoordinatorDelegate?
	weak var editCoordinator: EditContactCoordinatorDelegate?
	
	private var contact: Person?
	private var model = ContactList()
	
	var firstName: String? {
		return contact?.firstName
	}
	
	var lastName: String? {
		return contact?.lastName
	}
	
	var fullName: String {
		let result = "\(String(describing: self.firstName ?? "")) \(String(describing: self.lastName ?? ""))"
		return result
	}
	
	var phoneNumber: String? {
		if let phone = contact?.phone {
			return phoneNumberFormat(with: "+X (XXX) XXX-XXXX", phone: phone)
		}
		return nil
	}
	
	var notes: String? {
		return contact?.notes
	}
	
	var ringtone: String? {
		return contact?.ringtone
	}
	
	var image: UIImage? {
		guard let data = contact?.image, let img = UIImage(data: data) else { return nil }
		return img
	}
	
	init(contact: Person?) {
		self.contact = contact
	}
	
	func deleteContact() {
		guard let person = contact else { return  }
		model.deleteObject(person)
		goBack()
	}
	
	func goBack() {
		editCoordinator?.back()
	}
	
	func updateContact(firstName: String?, lastName: String?, phone: String?, ringtone: String?, notes: String?, image: Data?) {
		
		model.updateContact(person: contact ?? nil,
							firstName: firstName ?? contact?.firstName,
							lastName: lastName ?? contact?.lastName,
							phone: phone ?? contact?.phone,
							ringtone: ringtone ?? contact?.ringtone,
							notes: notes ?? contact?.notes,
							image: image ?? contact?.image)
		
		editCoordinator?.back()
	}
	
	func reloadData() {
		guard let contact = contact else { return }
		self.contact = model.getUpdatedInformation(for: contact)
	}
	
	func editContact() {
		existCoordinator?.edit(contact: contact)
	}
	
	private func phoneNumberFormat(with mask: String, phone: String) -> String {
		let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
		var result = ""
		var index = numbers.startIndex 
		
		for char in mask where index < numbers.endIndex {
			if char == "X" {
				result.append(numbers[index])
				
				index = numbers.index(after: index)
				
			} else {
				result.append(char)
			}
		}
		return result
	}
}

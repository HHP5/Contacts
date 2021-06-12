//
//  ContactInformation.swift
//  Contact
//
//  Created by Екатерина Григорьева on 10.06.2021.
//

import UIKit

class ContactModel: ContactModelType {
	
	var contact: Contact
	
	private var model = ContactListService()

	init(contact: Contact) {
		self.contact = contact
	}
	
	func fullName() -> String {
		let result = "\(String(describing: contact.firstName ?? "")) \(String(describing: contact.lastName ?? ""))"
		return result
	}
	
	func telephoneNumber() -> String? {
		if let phone = contact.phoneNumber {
			return phoneNumberFormat(with: "+X (XXX) XXX-XXXX", phone: phone)
		}
		return nil
	}
	
	func updateContact(with editContact: Contact) {
		model.updateContact(person: editContact.person ?? contact.person,
							firstName: editContact.firstName ?? contact.firstName,
							lastName: editContact.lastName ?? contact.lastName,
							phone: editContact.phoneNumber ?? contact.phoneNumber,
							ringtone: editContact.ringtone ?? contact.ringtone,
							notes: editContact.notes ?? contact.notes,
							image: editContact.image ?? contact.image)
	}
	
	func delete(_ contact: Contact) {
		if let person = contact.person {
			model.deleteObject(person)
		}
	}
	
	func getUpdatedInformation(for updatedContact: Contact) -> Contact? {
		var result: Contact?
		if let person = contact.person {
			if let updatedInfoForContact = model.getUpdatedInformation(for: person),
			   let updatedContact = Contact(contact: updatedInfoForContact) {
				self.contact = updatedContact
				result = updatedContact
			}
		}
		return result
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

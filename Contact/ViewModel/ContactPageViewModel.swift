//
//  ContactPageViewModel.swift
//  Contact
//
//  Created by Екатерина Григорьева on 28.05.2021.
//

import UIKit

class ContactPageViewModel: ContactPageViewModelType {

	weak var delegate: ContactPageViewModelDelegate?

	var contactModel: ContactModelType?
	private var editingContact: Contact
	
	var phoneNumberLink: NSMutableAttributedString? {
		guard let phone = contactModel?.contact.phoneNumber else { return nil }
		let attributedString = NSMutableAttributedString(string: phone)
		attributedString.setAsLink(text: phone, linkURL: "tel://" + phone)
		return attributedString
	}

	init(contact: ContactModelType?) {
		self.contactModel = contact
		self.editingContact = Contact(person: contact?.contact.person,
									  firstName: nil, lastName: nil,
									  phoneNumber: nil, notes: nil,
									  ringtone: nil, image: nil)
	}
	
	func deleteContact() {
		if let contact = contactModel {
			contact.delete(contact.contact)
			delegate?.сontactPageViewModelDidRequestGoBack(self)
		}
	}
	
	func goBack() {
		delegate?.сontactPageViewModelDidRequestGoBack(self)
	}
	
	func updateContact() {
		if contactModel == nil {
			let contact = ContactModel(contact: editingContact)
			contact.updateContact(with: editingContact)
		} else {
			contactModel?.updateContact(with: editingContact)

		}
		delegate?.сontactPageViewModelDidRequestGoBack(self)
	}

	func reloadData() {
		guard let contactModel = contactModel else { return }
		
		if let updatedContact = contactModel.getUpdatedInformation(for: contactModel.contact) {
			self.contactModel?.contact = updatedContact
		}
		
	}
	
	func editContact() {
		delegate?.сontactPageViewModel(self)
	}
	
	func addNotes(_ notes: String?) {
		self.editingContact.notes = notes
	}
	func addPhoneNumber(_ phone: String?) {
		self.editingContact.phoneNumber = phone
	}
	func addFirstName(_ name: String?) {
		self.editingContact.firstName = name
	}
	func addLastName(_ name: String?) {
		self.editingContact.lastName = name
	}
	func addRingtone(_ ringtone: String?) {
		self.editingContact.ringtone = ringtone
	}
	func addImage(_ image: Data?) {
		self.editingContact.image = image
	}
}

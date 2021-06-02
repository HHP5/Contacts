//
//  ContactPageViewModel.swift
//  Contact
//
//  Created by Екатерина Григорьева on 28.05.2021.
//

import UIKit

class ContactPageViewModel: ContactPageViewModelType {
	private var contact: Person?
	private var model = ContactList()
	
	var firstName: String? {
		return contact?.firstName
	}
	
	var lastName: String? {
		return contact?.lastName
	}
	
	var phoneNumber: String? {
		return contact?.phone
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
	
	func saveNewContact(firstName: String?, lastName: String?, phone: String?, ringtone: String?, notes: String?, image: Data?) {
		model.updateContact(firstName: firstName, lastName: lastName, phone: phone, ringtone: ringtone, notes: notes, image: image)
	}
	
	func deleteContact() {
		guard let person = contact else { return  }
		model.deleteObject(person)
	}
	
	func updateContact(firstName: String?, lastName: String?, phone: String?, ringtone: String?, notes: String?, image: Data?) {
		guard let contact = contact else { return  }
		model.updateContact(person: contact,
							firstName: firstName ?? contact.firstName,
							lastName: lastName ?? contact.lastName,
							phone: phone ?? contact.phone,
							ringtone: ringtone ?? contact.ringtone,
							notes: notes ?? contact.notes,
							image: image ?? contact.image)
	}
}

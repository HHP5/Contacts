//
//  Contact.swift
//  Contact
//
//  Created by Екатерина Григорьева on 12.06.2021.
//

import Foundation

class Contact {
	
	var person: Person?
	
	var firstName: String?
	@objc var lastName: String?
	var phoneNumber: String?
	var notes: String?
	var ringtone: String?
	var image: Data?
	
	init(person: Person?, firstName: String?, lastName: String?, phoneNumber: String?, notes: String?, ringtone: String?, image: Data?) {
		self.person = person
		self.firstName = firstName
		self.lastName = lastName
		self.phoneNumber = phoneNumber
		self.notes = notes
		self.ringtone = ringtone
		self.image = image
	}
	
	init?(contact: Person) {
		self.person = contact
		
		self.firstName = contact.firstName
		self.lastName = contact.lastName
		self.phoneNumber = contact.phone
		self.notes = contact.notes
		self.ringtone = contact.ringtone
		guard let image = contact.image else { return }
		self.image = image	}
}

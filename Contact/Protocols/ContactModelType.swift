//
//  ContactManagerType.swift
//  Contact
//
//  Created by Екатерина Григорьева on 12.06.2021.
//

import Foundation

protocol ContactModelType {
	var contact: Contact {get set}
	func delete(_ contact: Contact)
	func updateContact(with editContact: Contact)
	func getUpdatedInformation(for updatedContact: Contact) -> Contact?
	func fullName() -> String
}

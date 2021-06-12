//
//  з.swift
//  Contact
//
//  Created by Екатерина Григорьева on 31.05.2021.
//

import UIKit

protocol ContactPageViewModelType {

	var contactModel: ContactModelType? {get}
	var phoneNumberLink: NSMutableAttributedString? {get}
	func deleteContact()
	func updateContact()
	func reloadData()
	func editContact()
	func goBack()
	
	func addNotes(_ notes: String?)
	func addPhoneNumber(_ phone: String?)
	func addFirstName(_ name: String?)
	func addLastName(_ name: String?)
	func addRingtone(_ ringtone: String?)
	func addImage(_ image: Data?)
}

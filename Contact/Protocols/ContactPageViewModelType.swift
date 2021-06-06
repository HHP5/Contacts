//
//  з.swift
//  Contact
//
//  Created by Екатерина Григорьева on 31.05.2021.
//

import UIKit

protocol ContactPageViewModelType {
	var firstName: String? {get}
	var lastName: String? {get}
	var fullName: String {get}
	var phoneNumber: String? {get}
	var phoneNumberLink: NSMutableAttributedString? {get}
	var notes: String? {get}
	var ringtone: String? {get}
	var image: UIImage? {get}
	func deleteContact()
	func updateContact(firstName: String?, lastName: String?, phone: String?, ringtone: String?, notes: String?, image: Data?)
	func reloadData()
	func editContact()
	func goBack()
}

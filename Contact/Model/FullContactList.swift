//
//  FullContactList.swift
//  Contact
//
//  Created by Екатерина Григорьева on 12.06.2021.
//

import Foundation

struct FullContactList {
	var fullContactList: [Contact]
	private var model = ContactListService()

	init() {
		self.fullContactList = model.getContactList()
		
		//		self.model.deleteAllData()
	}
}

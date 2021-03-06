//
//  NameList.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//

import UIKit
import CoreData

class ContactListService {
	var persons: [Person] = []
	var context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
	
	func getContactList() -> [Contact] {
		self.loadNameList()
		if persons.isEmpty {
			createNameList()
		}
		var fullContactList: [Contact] = []
		
		persons.forEach { person in
			if let contact = Contact(contact: person) {
				fullContactList.append(contact)
			}
		}
		return fullContactList
	}
	
	func getUpdatedInformation(for contact: Person) -> Person? {
		var result: Person?
		persons.forEach { person in
			if person == contact {
				result = person
			}
		}
		return result
	}
	
	func updateContact(person: Person? = nil, firstName: String? = nil, lastName: String? = nil, phone: String? = nil, ringtone: String? = nil, notes: String? = nil, image: Data? = nil) {
		
		let newPerson = Person(context: self.context)
		
		saveContact(for: person ?? newPerson,
					firstName: firstName,
					lastName: lastName,
					phone: phone,
					ringtone: ringtone,
					notes: notes,
					image: image)
	}
	
	func deleteAllData() {
		
		let reqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
		let delAllReqVar = NSBatchDeleteRequest(fetchRequest: reqVar)
		do {
			try context.execute(delAllReqVar)
		} catch {
			print(error)
		}
	}
	
	func deleteObject(_ object: NSManagedObject) {
		context.delete(object)
		save()
	}
	
	private func save() {
		do {
			try context.save()
		} catch {
			context.rollback()
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
	}
	
	private func createNameList() {
		updateContact(firstName: "Thomas", lastName: "Anderson")
		updateContact(firstName: "Milton", lastName: "Aaron")
		updateContact(firstName: "Reid", lastName: "Alex")
		updateContact(firstName: "Will", lastName: "Baarada")
		updateContact(firstName: "Bruce", lastName: "Ballard")
		updateContact(firstName: "Pauline", lastName: "Banister")
		updateContact(firstName: "Michael", lastName: "Barlow")
		updateContact(firstName: "Holden", lastName: "Colfield")
		updateContact(firstName: "Dr.", lastName: "Cox")
	}
	
	private func loadNameList(with request: NSFetchRequest<Person> = Person.fetchRequest()) {
		
		let firstNameSortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
		let lastNameSortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
		request.sortDescriptors = [lastNameSortDescriptor, firstNameSortDescriptor]
		
		do {
			persons = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
	}
	
	private func saveContact(for person: Person,
							 firstName: String? = nil, lastName: String? = nil,
							 phone: String? = nil, ringtone: String? = nil,
							 notes: String? = nil, image: Data? = nil) {

		person.firstName = firstName
		person.lastName = lastName
		person.notes = notes
		person.phone = phone
		person.ringtone = ringtone
		person.image = image

		if !persons.contains(person) {
			persons.append(person)
		}
		save()
	}
}

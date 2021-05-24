//
//  NameList.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//

import UIKit
import CoreData

struct NameList {
	var persons: [Person] = []
	var context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext

	mutating func createNameList() {

		createPerson(firstName: "Thomas", lastName: "Anderson")
		createPerson(firstName: "Milton", lastName: "Aaron")
		createPerson(firstName: "Reid", lastName: "Alex")
		createPerson(firstName: "Will", lastName: "Baarada")
		createPerson(firstName: "Bruce", lastName: "Ballard")
		createPerson(firstName: "Pauline", lastName: "Banister")
		createPerson(firstName: "Michael", lastName: "Barlow")
		createPerson(firstName: "Holden", lastName: "Colfield")
		createPerson(firstName: "Dr.", lastName: "Cox")
	}
	
	func savePerson() {
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
	}
	
	mutating func loadNameList(with request: NSFetchRequest<Person> = Person.fetchRequest()) {

//		do {
//			persons = try context.fetch(request)
//		} catch {
//			print("Error fetching data from context \(error)")
//		}
//
		let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
		request.sortDescriptors = [sortDescriptor]
		
		do {
			persons = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
	}

	mutating func createPerson(firstName: String, lastName: String ) {

		let person = Person(context: self.context)
		person.firstName = firstName
		person.lastName = lastName

		persons.append(person)
		savePerson()
	}
}

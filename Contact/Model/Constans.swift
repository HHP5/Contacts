//
//  Constans.swift
//  Contact
//
//  Created by Екатерина Григорьева on 24.05.2021.
//

import Foundation

struct Constans {
	static let selectorForSection = "lastName"
	static let identifierForCell = "cell"
	static func heightOfCell(type: PersonalInfoType) -> Int {
		switch type {
		case .detail:
			return 70
		case .fullName:
			return 50
		}
	}
	static func tableCell(type: PersonalInfoType) -> String {
		switch type {
		case .detail:
			return "detailCell"
		case .fullName:
			return "fullNameCell"
		}
	}
}

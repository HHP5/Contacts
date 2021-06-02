//
//  RingtoneViewModelType.swift
//  Contact
//
//  Created by Екатерина Григорьева on 31.05.2021.
//

import Foundation

protocol RingtoneViewModelType {
	var numberOfComponents: Int {get set}
	func row(at row: Int) -> String?
}

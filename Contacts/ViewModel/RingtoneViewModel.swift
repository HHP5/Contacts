//
//  AddNewContactPageViewModel.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//
//
import UIKit
protocol RingtoneViewModelType {
	var numberOfComponents: Int {get set}
	func row(at row: Int) -> String?
}
class RingtoneViewModel: RingtoneViewModelType {
	var numberOfComponents: Int
	
	init() {
		self.numberOfComponents = Ringtone.ringtoneArray.count
	}
	
	func row(at row: Int) -> String? {
		return Ringtone.ringtoneArray[row]
	}
}

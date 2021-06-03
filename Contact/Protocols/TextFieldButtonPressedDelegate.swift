//
//  TextFieldButtonPressedDelegate.swift
//  Contact
//
//  Created by Екатерина Григорьева on 26.05.2021.
//

import UIKit

protocol TextViewButtonPressedDelegate: class {
	func didPressButton(button: TextViewButton, toolBarFor: ToolBarViewType)
}

//
//  TextFieldButtonPressedDelegate.swift
//  Contact
//
//  Created by Екатерина Григорьева on 26.05.2021.
//

import UIKit

protocol ToolBarForKeyboardDelegate: class {
	func toolBarForKeyboard(_ toolBar: KeyboardToolBar, didPress button: TextViewButton, with type: ToolBarViewType)
	
}

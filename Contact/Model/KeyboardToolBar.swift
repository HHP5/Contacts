//
//  ToolBarForKeyboard.swift
//  Contact
//
//  Created by Екатерина Григорьева on 03.06.2021.
//

import UIKit

class KeyboardToolBar: UIToolbar {
	weak var toolBarDelegate: ToolBarForKeyboardDelegate? // если наследоваться от UIToolbar то нельзя назвать delegate
	private var type: ToolBarViewType
	
	init(type: ToolBarViewType) {
		self.type = type
		
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setToolBar() -> UIToolbar {
		let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
		toolBar.barStyle = UIBarStyle.default
		toolBar.backgroundColor = .lightGray
		toolBar.isTranslucent = false
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
										target: nil,
										action: nil)
		let doneButton = UIBarButtonItem(title: TextViewButton.done.rawValue,
										 style: .done,
										 target: self,
										 action: #selector(buttonPressed))
		let nextButton = UIBarButtonItem(title: TextViewButton.next.rawValue,
										 style: .done,
										 target: self,
										 action: #selector(buttonPressed))
		toolBar.items = [doneButton, flexSpace, nextButton]
		return toolBar
	}

	@objc func buttonPressed(_ sender: UIBarButtonItem) {
		if let title = sender.title {
			switch title { 
			case TextViewButton.done.rawValue:
				toolBarDelegate?.toolBarForKeyboard(self, didPress: .done, with: type)
			case TextViewButton.next.rawValue:
				toolBarDelegate?.toolBarForKeyboard(self, didPress: .next, with: type)
			default:
				return
			}
		}
	}
}

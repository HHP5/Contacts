//
//  TextField.swift
//  Contact
//
//  Created by Екатерина Григорьева on 26.05.2021.
//

import UIKit

class TextField: UIView {
	let textField = UITextField()
	private var keyboardType: UIKeyboardType
	private var type: TextFieldType
	weak var delegate: TextFieldButtonPressedDelegate?
	
	init(type: UIKeyboardType, textField: TextFieldType) {
		self.keyboardType = type
		self.type = textField
		super.init(frame: .zero)
		setupTextView()

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupTextView() {
		self.addSubview(textField)
		
		textField.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview().offset(-5)
		}
		
		textField.keyboardType = keyboardType
		
		textField.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .medium)

		switch type {
		case .firstName:
			textField.textContentType = .name
		case .lastName:
			textField.textContentType = .familyName
		case .phone:
			textField.textContentType = .telephoneNumber
			textField.inputAccessoryView = setToolBar()
			self.drawLine()
		}
		textField.returnKeyType = UIReturnKeyType.next
	}

	private func setToolBar() -> UIToolbar {
		let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
		toolBar.barStyle = UIBarStyle.default
		toolBar.backgroundColor = .lightGray
		toolBar.isTranslucent = false
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
										target: nil,
										action: nil)
		let doneButton = UIBarButtonItem(title: TextFieldButton.done.rawValue,
										 style: .done,
										 target: self,
										 action: #selector(buttonPressed))
		let nextButton = UIBarButtonItem(title: TextFieldButton.next.rawValue,
										 style: .done,
										 target: self,
										 action: #selector(buttonPressed))
		toolBar.items = [doneButton, flexSpace, nextButton]
		return toolBar
	}
	
	@objc private func buttonPressed(_ sender: UIBarButtonItem) {
		if let title = sender.title {
			switch title {
			case TextFieldButton.done.rawValue:
				self.delegate?.didPressButton(button: .done)
				self.textField.resignFirstResponder()
			case TextFieldButton.next.rawValue:
				self.delegate?.didPressButton(button: .next)
				self.textField.resignFirstResponder()
			default:
				return
			}
		}
	}
	
}

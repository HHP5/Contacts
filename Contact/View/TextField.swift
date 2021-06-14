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
		}
		textField.returnKeyType = UIReturnKeyType.next
	}

}

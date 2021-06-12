//
//  TextTableViewCell.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//

import UIKit
import SnapKit

class TextView: UIView {
	weak var textViewToolBar: KeyboardToolBar?
	
	let textView = UITextView()
	
	private var type: TextViewType
	private var accessoryView = KeyboardToolBar(type: .phone)

	init(type: TextViewType) {
		self.type = type
		super.init(frame: .zero)
		
		self.setupTextView()
		
		switch type {
		case .note:
			textView.textContentType = .username
		case .phone:
			textView.textContentType = .telephoneNumber
			textView.keyboardType = .phonePad
			textView.textContentType = .telephoneNumber
			textView.inputAccessoryView = accessoryView.setToolBar()
			self.drawLine()
		}
		
		self.textViewToolBar = accessoryView
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupTextView() {
		self.addSubview(textView)
		
		textView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview().offset(-5)
		}
		textView.isEditable = true
		textView.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .medium)
		self.drawLine()
	}
}

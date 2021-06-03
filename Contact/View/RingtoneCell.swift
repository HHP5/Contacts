//
//  RingtoneCell.swift
//  Contact
//
//  Created by Екатерина Григорьева on 26.05.2021.
//

import UIKit
import SnapKit

class RingtoneCell: UIView {
	weak var ringtone: UITextField?
	weak var picker: UIPickerView?
	weak var textViewToolBar: ToolBarForKeyboard?

	private var accessoryView = ToolBarForKeyboard(type: .ringtone)

	private let name = UILabel()
	private let ringtoneTextField = UITextField()
	
	lazy private var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [name, ringtoneTextField])
		stack.axis = .vertical
		stack.distribution = .fillProportionally
		return stack
	}()
	
	private let image: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.image = UIImage(systemName: "chevron.forward")
		imageView.tintColor = .gray
		return imageView
	}()
	private let ringtonePickerView: UIPickerView = {
		let picker = UIPickerView(frame: .zero)
		return picker
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
		setupLabelsAttribute()
		
		self.drawLine()
		
		self.ringtone = ringtoneTextField
		self.picker = ringtonePickerView
		self.textViewToolBar = accessoryView
		
		ringtoneTextField.inputView = ringtonePickerView
		ringtoneTextField.inputAccessoryView = accessoryView.setToolBar()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func openPicker() {
		ringtoneTextField.becomeFirstResponder()
	}
	
	func setName(_ title: String?) {
		ringtoneTextField.text = title
	}
	
	func makeUserUnenabled() {
		self.isUserInteractionEnabled = false
		image.isHidden = true
	}
	
	private func setupView() {
		
		self.addSubview(stack)
		stack.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(3)
			make.leading.equalToSuperview()
		}
		
		self.addSubview(image)
		
		image.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(22)
			make.trailing.equalToSuperview().inset(10)
		}
	}
	
	private func setupLabelsAttribute() {
		name.text = "Ringtone"
		ringtoneTextField.text = Ringtone.ringtoneArray.first
		
		name.font = UIFont.systemFont(ofSize: 15)
		ringtoneTextField.font = UIFont.systemFont(ofSize: 20)
	}
}

//
//  DetailContactView.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//

import UIKit
import SnapKit
import TPKeyboardAvoiding

class EditContactView: UIView {
	
	var textFields: (firstName: UITextField, lastName: UITextField) {
		return (firstName: firstNameTextField.textField, lastName: lastNameTextField.textField)
	}
	
	weak var phoneNumber: UITextView?
	weak var notes: UITextView?
	weak var ringtone: RingtoneCell?
	weak var ringtonePicker: UIPickerView?
	weak var contactImage: EditContactViewDelegate?

	// MARK: - IBOutlets (всегда приватные)
	private let scroll: TPKeyboardAvoidingScrollView = {
		let scroll = TPKeyboardAvoidingScrollView()
		scroll.alwaysBounceVertical = true
		scroll.alwaysBounceHorizontal = false
		scroll.showsVerticalScrollIndicator = false
		return scroll
	}()
	
	private let firstNameTextField = TextField(type: .default, textField: .firstName)
	private let lastNameTextField = TextField(type: .default, textField: .lastName)
	private let phoneNumberTextView = TextView(type: .phone)
	private let ringtoneCell = RingtoneCell()
	private let notesTextView = TextView(type: .note)
	
	private let profileImage = ProfileImageView()
	// MARK: - Init
	
	init() {
		super.init(frame: .zero)
		self.backgroundColor = .white
		
		self.setupStack()
		self.setupDelegates()
		self.addGestureRecognizerToProfileImage()
		self.addGestureRecognizerToRingtoneCell()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Actions 
	
	@objc
	private func profileImageTapped(sender: UITapGestureRecognizer) {
		contactImage?.editContactViewImageViewPressed(self)
	}
	
	@objc
	private func triggerPickerView(sender: UITapGestureRecognizer) {
		self.endEditing(true)
		ringtoneCell.openPicker()
	}

	// MARK: - Public Methods
	
	func setImage(image: UIImage?) {
		profileImage.image = image == nil ? UIImage(named: "icon") : image
	}
	
	func setRingtone(_ ringtone: String?) {
		ringtoneCell.ringtone?.text = ringtone
	}
	
	func setupModel(viewModel: ContactPageViewModelType) {
		guard let contact = viewModel.contactModel?.contact else { return }

		firstNameTextField.textField.text = contact.firstName
		lastNameTextField.textField.text = contact.lastName
		phoneNumberTextView.textView.text = contact.phoneNumber
		notesTextView.textView.text = contact.notes
		if let ringtone = contact.ringtone {
			ringtoneCell.setName(ringtone)
		}
		if let image = contact.image {
			setImage(image: UIImage(data: image))
		}
		
	}

	// MARK: - Private Methods
	private func setupDelegates() {
		self.phoneNumber = phoneNumberTextView.textView
		self.notes = notesTextView.textView
		self.ringtone = ringtoneCell
		self.ringtonePicker = ringtoneCell.picker
		
		self.phoneNumberTextView.textViewToolBar?.toolBarDelegate = self
		self.ringtoneCell.textViewToolBar?.toolBarDelegate = self
		
		profileImage.isUserInteractionEnabled = true
	}
	
	private func setupStack() {
	
		self.addSubview(scroll)
		
		scroll.snp.makeConstraints { $0.edges.equalToSuperview() }
		
		let nameStackForNewContact = Stack(arrangedSubviews: [firstNameTextField, lastNameTextField],
										   axis: .vertical, spacing: 20, height: nil)
		let topStackForNewContact = Stack(arrangedSubviews: [profileImage, nameStackForNewContact],
										  axis: .horizontal, spacing: 20, height: nil)
		nameStackForNewContact.arrangedSubviews.forEach {$0.drawLine()}
		
		scroll.addSubview(topStackForNewContact)

		topStackForNewContact.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.width.equalTo(scroll).inset(20)
			make.leading.equalToSuperview().offset(20)
		}
		
		let phoneLabel = UILabel(); phoneLabel.text = " "
		let phoneStack = Stack(arrangedSubviews: [phoneLabel, phoneNumberTextView],
							   axis: .vertical, spacing: 10, height: nil)
		let notesLabel = UILabel(); notesLabel.text = "Notes"
		let notesStack = Stack(arrangedSubviews: [notesLabel, notesTextView],
							   axis: .vertical, spacing: 10, height: nil)
		
		let stack = Stack(arrangedSubviews: [phoneStack, ringtoneCell, notesStack],
						  axis: .vertical, spacing: 20.0,
						  height: .detail)

		scroll.addSubview(stack)

		stack.snp.makeConstraints { make in
			make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
			make.leading.equalToSuperview().offset(20)
			make.width.equalTo(scroll).inset(20)
		}
		
		scroll.tpKeyboardAvoiding_findFirstResponderBeneathView(notesTextView)

	}
	
	private func addGestureRecognizerToProfileImage() {
		let tapProfileImage = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
		profileImage.addGestureRecognizer(tapProfileImage)
	}

	private func addGestureRecognizerToRingtoneCell() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(triggerPickerView))
		ringtoneCell.addGestureRecognizer(tapGesture)
	}
	
}

extension EditContactView: ToolBarForKeyboardDelegate {
	func toolBarForKeyboard(_ toolBar: KeyboardToolBar, didPress button: TextViewButton, with type: ToolBarViewType) {
		switch button {
		case .done:
			self.endEditing(true)
		case .next:
			switch type {
			case .phone:
				ringtoneCell.openPicker()
			case .ringtone:
				notes?.becomeFirstResponder()
			}
		}
	}
}
	

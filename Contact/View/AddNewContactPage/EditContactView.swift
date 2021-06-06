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
		return (firstName: firstName.textField, lastName: lastName.textField)
	}
	
	weak var phoneNumber: UITextView?
	weak var notes: UITextView?
	weak var ringtone: RingtoneCell?
	weak var ringtonePicker: UIPickerView?
	weak var contactImage: ContactImageDelegate?

	// MARK: - IBOutlets (всегда приватные)
	private let scroll: TPKeyboardAvoidingScrollView = {
		let scroll = TPKeyboardAvoidingScrollView()
		scroll.alwaysBounceVertical = true
		scroll.alwaysBounceHorizontal = false
		scroll.showsVerticalScrollIndicator = false
		return scroll
	}()
	
	private let firstName = TextField(type: .default, textField: .firstName)
	private let lastName = TextField(type: .default, textField: .lastName)
	private let phoneNumberTextView = TextView(type: .phone)
	private let ringtoneCell = RingtoneCell()
	private let notesTextView = TextView(type: .note)
	
	private let profileImage = ProfileImage()
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
		self.contactImage?.press()
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
		
		firstName.textField.text = viewModel.firstName
		lastName.textField.text = viewModel.lastName
		phoneNumberTextView.textView.text = viewModel.phoneNumber
		notesTextView.textView.text = viewModel.notes
		if let ringtone = viewModel.ringtone {
			ringtoneCell.setName(ringtone)
		}
		setImage(image: viewModel.image)
	}

	// MARK: - Private Methods
	private func setupDelegates() {
		self.phoneNumber = phoneNumberTextView.textView
		self.notes = notesTextView.textView
		self.ringtone = ringtoneCell
		self.ringtonePicker = ringtoneCell.picker
		
		self.phoneNumberTextView.textViewToolBar?.toolBar = self
		self.ringtoneCell.textViewToolBar?.toolBar = self
		
		profileImage.isUserInteractionEnabled = true
	}
	
	private func setupStack() {
	
		self.addSubview(scroll)
		
		scroll.snp.makeConstraints { $0.edges.equalToSuperview() }
		
		let nameStackForNewContact = Stack(arrangedSubviews: [firstName, lastName], axis: .vertical, spacing: 20, height: nil)
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
		let phoneStack = Stack(arrangedSubviews: [phoneLabel, phoneNumberTextView], axis: .vertical, spacing: 10, height: nil)
		let notesLabel = UILabel(); notesLabel.text = "Notes"
		let notesStack = Stack(arrangedSubviews: [notesLabel, notesTextView], axis: .vertical, spacing: 10, height: nil)
		
		let stack = Stack(arrangedSubviews: [phoneStack, ringtoneCell, notesStack],
						  axis: .vertical, spacing: 20.0,
						  height: Constant.heightOfCell(type: .detail))

		scroll.addSubview(stack)

		stack.snp.makeConstraints { make in
			make.top.equalTo(lastName.snp.bottom).offset(20)
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

extension EditContactView: TextViewButtonPressedDelegate {
	func didPressButton(button: TextViewButton, toolBarFor: ToolBarViewType) {
		switch button {
		case .done:
			self.endEditing(true)
		case .next:
			switch toolBarFor {
			case .phone:
				ringtoneCell.openPicker()
			case .ringtone:
				notes?.becomeFirstResponder()
			}
		}
	}
}
	

//
//  DetailContactView.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//

import UIKit
import SnapKit

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
	
	private let firstName = TextField(type: .default, textField: .firstName)
	private let lastName = TextField(type: .default, textField: .lastName)
	
	private let profileImage: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.sizeToFit()
		imageView.clipsToBounds = true
		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.gray.cgColor
		imageView.isUserInteractionEnabled = true
		imageView.snp.makeConstraints {$0.width.height.equalTo(Constant.heightOfCell(type: .fullName) * 2)}
		imageView.layer.cornerRadius = CGFloat((Constant.heightOfCell(type: .fullName) ))
		return imageView
	}()
	
	private lazy var nameStackForNewContact: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [firstName, lastName])
		stack.arrangedSubviews.forEach { $0.drawLine() }
		stack.spacing = 20
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	private lazy var topStackForNewContact: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [profileImage, nameStackForNewContact])
		stack.spacing = 20
		stack.axis = .horizontal
		stack.distribution = .fill
		return stack
	}()
	
	private let phoneNumberTextView = TextView(type: .phone)
	private let phoneLabel: UILabel = {
		let label = UILabel()
		label.text = " "
		return label
	}()
	private lazy var phoneStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [phoneLabel, phoneNumberTextView])
		stack.spacing = 10
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	private let ringtoneCell = RingtoneCell()

	private let notesLabel: UILabel = {
		let label = UILabel()
		label.text = "Notes"
		return label
	}()
	
	private let notesTextView = TextView(type: .note)
	
	private lazy var notesStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [notesLabel, notesTextView])
		stack.spacing = 10
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	private lazy var detailStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [phoneStack, ringtoneCell, notesStack])
		stack.arrangedSubviews.forEach { $0.snp.makeConstraints {$0.height.equalTo(Constant.heightOfCell(type: .detail))} }
		stack.spacing = 10
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	// MARK: - Init
	
	init() {
		super.init(frame: .zero)
		self.backgroundColor = .white
		
		self.setupForNewContact()
		self.setupDetailStack()
		self.setupDelegates()
		self.addGestureRecognizerToProfileImage()
		self.addGestureRecognizerToRingtoneCell()
		
		self.keyboardSetting()
				
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
	
	@objc
	private func keyboardWillHide(notification: NSNotification) {
		self.frame.origin.y = 0
	}

	// MARK: - Public Methods
	
	func setImage(image: UIImage?) {
		profileImage.image = image
	}
	
	func setRingtone(_ ringtone: String?) {
		ringtoneCell.ringtone?.text = ringtone
	}
	
	func notesPressed() {
		self.frame.origin.y -= notesTextView.frame.maxY
	}
	func notesNotPressed() {
		self.frame.origin.y = 0
	}
	
	func setupModel(viewModel: ContactPageViewModelType) {
		
		firstName.textField.text = viewModel.firstName
		lastName.textField.text = viewModel.lastName
		phoneNumberTextView.textView.text = viewModel.phoneNumber
		notesTextView.textView.text = viewModel.notes
		if let ringtone = viewModel.ringtone {
			ringtoneCell.setName(ringtone)
		}
		self.profileImage.image = viewModel.image == nil ? UIImage(systemName: "icon") : viewModel.image
	
	}

	// MARK: - Private Methods
	
	private func setupForNewContact() {
		self.addSubview(topStackForNewContact)
		
		topStackForNewContact.snp.makeConstraints { make in
			make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
			make.trailing.equalToSuperview().inset(20)
			make.leading.equalToSuperview().offset(20)
		}
	}
	
	private func setupDetailStack() {
		self.addSubview(detailStack)
		
		detailStack.snp.makeConstraints { make in
			make.top.equalTo(topStackForNewContact.snp.bottom).offset(20)
			make.trailing.equalToSuperview()
			make.leading.equalToSuperview().offset(20)
		}
	}

	private func setupDelegates() {
		self.phoneNumber = phoneNumberTextView.textView
		self.notes = notesTextView.textView
		self.ringtone = ringtoneCell
		self.ringtonePicker = ringtoneCell.picker
		
		self.phoneNumberTextView.textViewToolBar?.toolBar = self
		self.ringtoneCell.textViewToolBar?.toolBar = self
	}
	
	private func addGestureRecognizerToProfileImage() {
		let tapProfileImage = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
		profileImage.addGestureRecognizer(tapProfileImage)
	}

	private func addGestureRecognizerToRingtoneCell() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(triggerPickerView))
		ringtoneCell.addGestureRecognizer(tapGesture)
	}
	
	private func keyboardSetting() {

		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardWillHide(notification:)),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
		tapGesture.cancelsTouchesInView = false
		self.addGestureRecognizer(tapGesture)
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
	

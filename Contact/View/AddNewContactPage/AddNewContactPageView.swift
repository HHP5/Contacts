//
//  DetailContactView.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//

import UIKit
import SnapKit

class AddNewContactPageView: UIView {
	var textFields: (firstName: UITextField, lastName: UITextField, phoneNumber: UITextField) {
		return (firstName: firstName.textField, lastName: lastName.textField, phoneNumber: phoneNumberTextField.textField)
	}
	
	weak var phoneNumber: TextField?
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
		imageView.snp.makeConstraints {$0.width.height.equalTo(Constans.heightOfCell(type: .fullName) * 2)}
		imageView.layer.cornerRadius = CGFloat((Constans.heightOfCell(type: .fullName) ))
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
	
	private let phoneNumberTextField = TextField(type: .phonePad, textField: .phone)
	private let phoneNumberLabel: UILabel = {
		let label = UILabel()
		label.text = "Phone"
		return label
	}()
	private lazy var phoneNumberStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [phoneNumberLabel, phoneNumberTextField])
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
	private let notesTextView = TextView()
	
	private lazy var notesStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [notesLabel, notesTextView])
		stack.spacing = 10
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	private lazy var detailStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [phoneNumberStack, ringtoneCell, notesStack])
		stack.arrangedSubviews.forEach { $0.snp.makeConstraints {$0.height.equalTo(Constans.heightOfCell(type: .detail))} }
		stack.spacing = 10
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	private let ringtonePickerView: UIPickerView = {
		let picker = UIPickerView(frame: .zero)
		return picker
	}()
	
	// MARK: - Init
	
	init() {
		super.init(frame: .zero)
		self.backgroundColor = .white
		
		self.setupForNewContact()
		self.setupDetailStack()
		self.setupPicker()
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
	private func ringtoneTapped(sender: UITapGestureRecognizer) {
		self.endEditing(true)
		ringtonePickerView.isHidden = false
	}
	
	@objc
	private func keyboardWillHide(notification: NSNotification) {
		self.frame.origin.y = 0
	}

	// MARK: - Public Methods
	
	func setImage(image: UIImage) {
		profileImage.image = image
	}
	
	func hideRingtone() {
		self.ringtonePickerView.isHidden = true
	}
	
	func notesPressed() {
		self.frame.origin.y -= notesTextView.frame.maxY * 2
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
		phoneNumberLabel.isHidden = true
	}
	
	private func setupPicker() {
		self.addSubview(ringtonePickerView)
		
		ringtonePickerView.snp.makeConstraints { make in
			make.top.equalTo(detailStack.snp.bottom).offset(10)
			make.bottom.left.right.equalToSuperview()
		}
		
		ringtonePickerView.isHidden = true
	}

	private func setupDelegates() {
		self.phoneNumber = phoneNumberTextField
		self.notes = notesTextView.textView
		self.ringtone = ringtoneCell
		self.ringtonePicker = ringtonePickerView
	}
	
	private func addGestureRecognizerToProfileImage() {
		let tapProfileImage = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
		profileImage.addGestureRecognizer(tapProfileImage)
	}
	
	private func addGestureRecognizerToRingtoneCell() {
		let tapRingtoneCell = UITapGestureRecognizer(target: self, action: #selector(ringtoneTapped))
		ringtoneCell.addGestureRecognizer(tapRingtoneCell)
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

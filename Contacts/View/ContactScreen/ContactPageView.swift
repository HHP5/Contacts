//
//  DetailContactView.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//

import UIKit
import SnapKit

class ContactPageView: UIView {
	var textFields: (firstName: UITextField, lastName: UITextField, phoneNumber: UITextField) {
		return (firstName: firstName.textField, lastName: lastName.textField, phoneNumber: phoneNumber.textField)
	}
	
	weak var phoneNumberDelegate: TextField?
	weak var notesDelegate: UITextView?
	weak var ringtoneDelegate: RingtoneCell?
	weak var ringtonePickerDelegate: UIPickerView?
	weak var profileImageDelegate: ProfileImageDelegate?
	weak var deleteButtonDelegate: DeleteButtonDelegate?
	// MARK: - IBOutlets (всегда приватные)
	
	private let typeOfPage: TypeOfDetailPage
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
	
	private let phoneNumber = TextField(type: .phonePad, textField: .phone)
	private let phoneNumberLabel: UILabel = {
		let label = UILabel()
		label.text = "Phone"
		return label
	}()
	private lazy var phoneNumberStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [phoneNumberLabel, phoneNumber])
		stack.spacing = 10
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	private let ringtone = RingtoneCell()
	
	private let notesLabel: UILabel = {
		let label = UILabel()
		label.text = "Notes"
		return label
	}()
	private let notes = TextView()
	
	private lazy var notesStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [notesLabel, notes])
		stack.spacing = 10
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	private lazy var detailStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [phoneNumberStack, ringtone, notesStack])
		stack.arrangedSubviews.forEach { $0.snp.makeConstraints {$0.height.equalTo(Constans.heightOfCell(type: .detail))} }
		stack.spacing = 10
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	private let ringtonePicker: UIPickerView = {
		let picker = UIPickerView(frame: .zero)
		return picker
	}()
	
	private let deleteButton:UIButton = {
		let button = UIButton(frame: .zero)
		button.setTitle("Delete", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .red
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.black.cgColor
		button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
		button.layer.cornerRadius = 5
		button.clipsToBounds = true
		return button
	}()
	
	// MARK: - Init
	
	init(type: TypeOfDetailPage) {
		self.typeOfPage = type
		super.init(frame: .zero)
		self.backgroundColor = .white
		
		switch type {
		case .new:
			self.setupForNewContact()
		case .existing:
			self.setupForExistingContact()
			self.setupDeleteButton()
		}
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
	
	// MARK: - Actions (@ojbc + @IBActions)
	
	@objc
	private func profileImageTapped(sender: UITapGestureRecognizer) {
		self.profileImageDelegate?.imagePressed()
	}
	
	@objc
	private func ringtoneTapped(sender: UITapGestureRecognizer) {
		self.endEditing(true)
		deleteButton.isHidden = true
		ringtonePicker.isHidden = false
	}
	
	@objc
	private func deleteButtonPressed() {
		self.deleteButtonDelegate?.pressed()
	}
	
	@objc
	private func keyboardWillHide(notification: NSNotification) {
		self.frame.origin.y = 0
	}
	
	@objc
	private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
		self.endEditing(true)
	}
	
	// MARK: - Public Methods
	
	func setImage(image: UIImage) {
		profileImage.image = image
	}
	
	func hideRingtone() {
		self.ringtonePicker.isHidden = true
	}
	
	func notesPressed() {
		self.frame.origin.y -= notes.frame.maxY * 2
	}
	
	func deleteButtonShowing(condition: Bool) {
		deleteButton.isHidden = condition
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
	
	private func setupForExistingContact() {
		
		let newView = UIView()
		newView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		self.addSubview(newView)
		
		newView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
		}
		
		newView.addSubview(profileImage)
		
		profileImage.snp.makeConstraints { make in
			make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
			make.centerX.equalToSuperview()
		}
		
		let stack: UIStackView = {
			let stack = UIStackView(arrangedSubviews: [firstName, lastName])
			stack.axis = .horizontal
			stack.distribution = .fillEqually
			stack.spacing = 10
			firstName.textField.textAlignment = .right
			lastName.textField.textAlignment = .left
			[firstName, lastName].forEach { $0.textField.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .medium) }
			return stack
		}()
		
		newView.addSubview(stack)
		
		stack.snp.makeConstraints { make in
			make.top.equalTo(profileImage.snp.bottom).offset(20)
			make.height.equalTo(Constans.heightOfCell(type: .fullName))
			make.leading.trailing.equalToSuperview().inset(20)
		}
		newView.snp.makeConstraints { $0.bottom.equalTo(stack.snp.bottom) }
	}
	
	private func setupDetailStack() {
		self.addSubview(detailStack)
		
		detailStack.snp.makeConstraints { make in
			switch typeOfPage {
			case .existing:
				make.top.equalTo(firstName.snp.bottom).offset(20)
			case .new:
				phoneNumberLabel.isHidden = true
				make.top.equalTo(topStackForNewContact.snp.bottom).offset(20)
			}
			make.trailing.equalToSuperview()
			make.leading.equalToSuperview().offset(20)
		}
	}
	
	private func setupPicker() {
		self.addSubview(ringtonePicker)
		
		ringtonePicker.snp.makeConstraints { make in
			make.top.equalTo(detailStack.snp.bottom).offset(10)
			make.bottom.left.right.equalToSuperview()
		}
		
		ringtonePicker.isHidden = true
	}
	
	private func setupDeleteButton() {
		self.addSubview(deleteButton)
		
		deleteButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().inset(50)
			make.width.equalTo(100)
			make.height.equalTo(50)
		}
		
	}
	
	private func setupDelegates() {
		self.phoneNumberDelegate = phoneNumber
		self.notesDelegate = notes.textView
		self.ringtoneDelegate = ringtone
		self.ringtonePickerDelegate = ringtonePicker
	}
	
	private func addGestureRecognizerToProfileImage() {
		let tapProfileImage = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
		profileImage.addGestureRecognizer(tapProfileImage)
	}
	
	private func addGestureRecognizerToRingtoneCell() {
		let tapRingtoneCell = UITapGestureRecognizer(target: self, action: #selector(ringtoneTapped))
		ringtone.addGestureRecognizer(tapRingtoneCell)
	}
	
	private func keyboardSetting() {

		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardWillHide(notification:)),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
		tapGesture.cancelsTouchesInView = false
		self.addGestureRecognizer(tapGesture)
	}
	
}

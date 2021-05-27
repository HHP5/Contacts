//
//  DetailContactView.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//

import UIKit
import SnapKit
protocol ProfileImageDelegate: class {
	func imagePressed()
}
class ContactPageView: UIView {
	
	var textFields: [UITextField] {
		return [firstName.textField, lastName.textField, phoneNumber.textField]
	}
	weak var phoneNumberDelegate: TextField?
	weak var notesDelegate: UITextView?
	weak var ringtoneDelegate: RingtoneCell?
	weak var ringtonePickerDelegate: UIPickerView?
	weak var profileImageDelegate: ProfileImageDelegate?
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
		}
		self.setupDetailStack()
		self.setupPicker()
		self.setupDelegates()
		self.addGestureRecognizerToProfileImage()
		self.addGestureRecognizerToRingtoneCell()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc
	private func profileImageTapped(sender: UITapGestureRecognizer) {
		self.profileImageDelegate?.imagePressed()
	}
	
	@objc
	private func ringtoneTapped(sender: UITapGestureRecognizer) {
		ringtonePicker.isHidden = false
	}

	// MARK: - Private Methods
	
	func setImage(image: UIImage) {
		profileImage.image = image
	}
	
	private func setupForNewContact() {
		self.addSubview(topStackForNewContact)

		topStackForNewContact.snp.makeConstraints { make in
			make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
			make.trailing.equalToSuperview().inset(20)
			make.leading.equalToSuperview().offset(20)
		}
	}
	
	private func setupForExistingContact() {

		self.addSubview(profileImage)
		self.addSubview(firstName)
		self.addSubview(lastName)
		
		profileImage.snp.makeConstraints { make in
			make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
			make.centerX.equalToSuperview()
		}

		firstName.snp.makeConstraints { make in
			make.top.equalTo(profileImage.snp.bottom).offset(20)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalTo(self.snp.centerX)
			make.height.equalTo(Constans.heightOfCell(type: .fullName))

		}
		
		lastName.snp.makeConstraints { make in
			make.top.equalTo(profileImage.snp.bottom).offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.leading.equalTo(self.snp.centerX)
			make.height.equalTo(Constans.heightOfCell(type: .fullName))
		}
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

}

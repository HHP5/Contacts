//
//  ExistingContactPageView.swift
//  Contact
//
//  Created by Екатерина Григорьева on 02.06.2021.
//

import UIKit
import SnapKit

class ExistingContactPageView: UIView {
	
	weak var deleteContactButton: ExistingContactPageViewDelegate?

	private let nameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
		label.numberOfLines = 1 // поменяла на UILabel только из-за этого свойства
		label.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .medium)
		return label
	}()
	
	private let profileImageView = ProfileImageView()

	private let phoneNumberTextView = TextView(type: .phone)
	private let phoneNumberLabel = UILabel()
	private lazy var phoneNumberStack = Stack(arrangedSubviews: [phoneNumberLabel, phoneNumberTextView],
											  axis: .vertical, spacing: 10, height: nil)
	
	private let ringtoneCell = RingtoneCell()
	
	private let notesLabel = UILabel()
	private let notesTextView = TextView(type: .note)
	
	private lazy var notesStack = Stack(arrangedSubviews: [notesLabel, notesTextView],
										axis: .vertical, spacing: 10, height: nil)
	private lazy var detailStack = Stack(arrangedSubviews: [phoneNumberStack, ringtoneCell, notesStack],
										 axis: .vertical, spacing: 10,
										 height: .detail)

	private let deleteButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.setTitle("Delete", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .red
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.black.cgColor
		button.layer.cornerRadius = 5
		button.clipsToBounds = true
		return button
	}()
	
	// MARK: - Init
	
	init() {
		super.init(frame: .zero)
		
		self.backgroundColor = .white
		self.setupView()
		self.setupDeleteButton()
		self.setupDetailStack()
		self.deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
		self.setupUserInteractionEnabledForElement()
		
		self.phoneNumberLabel.text = "Phone"
		self.notesLabel.text = "Notes"
		
		self.tapGestureRecognizerOnPhoneNumber()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Actions
	
	@objc
	private func deleteButtonPressed() {
		deleteContactButton?.existingContactPageViewDeleteButtonPressed(self)
	}
	
	@objc
	private func call() {
		if let phoneNumber = phoneNumberTextView.textView.text {
			if !phoneNumber.isEmpty {
				let formatedNumber = phoneNumber.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
				let phoneUrl = "tel://\(formatedNumber)"
				if let url = URL(string: phoneUrl) {
					UIApplication.shared.open(url)
				}
			}
		}
	}
	
	// MARK: - Public Method
	
	func setupModel(viewModel: ContactPageViewModelType) {
		guard let contact = viewModel.contactModel?.contact else { return }
		
		nameLabel.text = viewModel.contactModel?.fullName()
		phoneNumberTextView.textView.attributedText = viewModel.phoneNumberLink
		
		notesTextView.textView.text = contact.notes
		if let ringtone = contact.ringtone {
			self.ringtoneCell.setName(ringtone)
		}
		guard let image = contact.image else {
			self.profileImageView.image = UIImage(named: "icon")
			return
		}
		self.profileImageView.image = UIImage(data: image)
	}
	
	// MARK: - Private Methods
	
	private func setupUserInteractionEnabledForElement() {
		nameLabel.isUserInteractionEnabled = false
		phoneNumberTextView.textView.isUserInteractionEnabled = false
		notesTextView.textView.isUserInteractionEnabled = false
		ringtoneCell.makeUserUnenabled()
		profileImageView.isUserInteractionEnabled = false
	}
	
	private func setupView() {
		
		let newView = UIView()
		newView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9803921569, blue: 1, alpha: 1)
		self.addSubview(newView)
		
		newView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
		}
		
		newView.addSubview(profileImageView)
		
		profileImageView.snp.makeConstraints { make in
			make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
			make.centerX.equalToSuperview()
		}
		
		newView.addSubview(nameLabel)
		
		nameLabel.snp.makeConstraints { make in
			make.top.equalTo(profileImageView.snp.bottom).offset(20)
			make.height.equalTo(profileImageView.height)
			make.leading.trailing.equalToSuperview().inset(20)
		}
		newView.snp.makeConstraints { $0.bottom.equalTo(nameLabel.snp.bottom) }
	}
	
	private func setupDetailStack() {
		
		self.addSubview(detailStack)
		
		detailStack.snp.makeConstraints { make in
			make.top.equalTo(nameLabel.snp.bottom).offset(20)
			make.trailing.equalToSuperview()
			make.leading.equalToSuperview().offset(20)
		}
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
	
	private func tapGestureRecognizerOnPhoneNumber() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(call))
		phoneNumberTextView.addGestureRecognizer(tapGesture)
	}
}

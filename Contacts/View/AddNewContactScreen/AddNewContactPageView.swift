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
class AddNewContactPageView: UIView {
	
	var textFields: [UITextField] {
		return [firstName.textField, lastName.textField, phoneNumber.textField]
	}
	weak var phoneNumberDelegate: TextField?
	weak var notesDelegate: UITextView?
	weak var ringtoneDelegate: RingtoneCell?
	weak var ringtonePickerDelegate: UIPickerView?
	weak var profileImageDelegate: ProfileImageDelegate?
	// MARK: - IBOutlets (всегда приватные)
	
	private let firstName = TextField(type: .default, textField: .firstName)
	private let lastName = TextField(type: .default, textField: .lastName)

	private let profileImage: UIImageView = {
		let imageView = UIImageView(frame: .zero)
//		imageView.image = UIImage(systemName: "plus")
		imageView.sizeToFit()
		imageView.clipsToBounds = true
		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.gray.cgColor
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	
	private lazy var nameStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [firstName, lastName])
		firstName.snp.makeConstraints {$0.height.equalTo(Constans.heightOfCell(type: .fullName))}
		stack.spacing = 10
		
		stack.axis = .vertical
		stack.distribution = .fill
		return stack
	}()
	
	private lazy var topStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [profileImage, nameStack])
		firstName.snp.makeConstraints {$0.height.equalTo(Constans.heightOfCell(type: .fullName))}
		stack.spacing = 20
		stack.axis = .horizontal
		stack.distribution = .fill
		
		return stack
	}()
	
	private let phoneNumber = TextField(type: .phonePad, textField: .phone)
	private let ringtone = RingtoneCell()
	private let notes = TextView()
	
	private lazy var detailStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [phoneNumber, ringtone, notes])
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

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .white
		self.setupStack()
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
	
	private func setupStack() {
		self.addSubview(topStack)

		topStack.snp.makeConstraints { make in
			make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
			make.height.equalTo(Constans.heightOfCell(type: .fullName) * 2 + 10)
			make.trailing.equalToSuperview().inset(20)
			make.leading.equalToSuperview().offset(20)
		}
		
		profileImage.snp.makeConstraints {$0.height.width.equalTo(nameStack.snp.height)}
		profileImage.layer.cornerRadius = CGFloat((Constans.heightOfCell(type: .fullName) + 5))
	}
	
	private func setupDetailStack() {
		self.addSubview(detailStack)

		detailStack.snp.makeConstraints { make in
			make.top.equalTo(topStack.snp.bottom).offset(20)
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

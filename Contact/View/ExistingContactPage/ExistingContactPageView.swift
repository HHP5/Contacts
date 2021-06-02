//
//  ExistingContactPageView.swift
//  Contact
//
//  Created by Екатерина Григорьева on 02.06.2021.
//

import UIKit

class ExistingContactPageView: UIView {
	
	weak var deleteContactButton: DeleteButtonDelegate?
	
	private let name = TextField(type: .default, textField: .firstName)
	
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
	
	private let phoneNumberTextField = TextField(type: .phonePad, textField: .phone)
	private let phoneNumberLabel: UILabel = {
		let label = UILabel()
		label.text = "Phone"
		return label
	}()
	private lazy var phoneNumberStack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [phoneNumberLabel, phoneNumberTextField])
		phoneNumberTextField.textField.isUserInteractionEnabled = false
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
		notesTextView.textView.isUserInteractionEnabled = false
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
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Actions
	
	@objc
	private func deleteButtonPressed() {
		self.deleteContactButton?.pressed()
	}
	
	func setupModel(viewModel: ContactPageViewModelType) {
		
		name.textField.text = viewModel.fullName
		phoneNumberTextField.textField.text = viewModel.phoneNumber
		notesTextView.textView.text = viewModel.notes
		if let ringtone = viewModel.ringtone {
			self.ringtoneCell.setName(ringtone)
		}
		if let image = viewModel.image {
			self.profileImage.image = image
		}
	}
	// MARK: - Private Methods
	private func setupView() {
		
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
		
		newView.addSubview(name)
		
		name.snp.makeConstraints { make in
			make.top.equalTo(profileImage.snp.bottom).offset(20)
			make.height.equalTo(Constans.heightOfCell(type: .fullName))
			make.leading.trailing.equalToSuperview().inset(20)
		}
		name.textField.textAlignment = .center
		name.textField.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .medium)
		name.textField.isUserInteractionEnabled = false
		newView.snp.makeConstraints { $0.bottom.equalTo(name.snp.bottom) }
	}
	
	private func setupDetailStack() {
		self.addSubview(detailStack)
		
		detailStack.snp.makeConstraints { make in
			make.top.equalTo(name.snp.bottom).offset(20)
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
}

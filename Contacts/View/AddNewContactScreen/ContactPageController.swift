//
//  DetailContactInfoController.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//

import UIKit
import SnapKit

class ContactPageController: UIViewController, UINavigationControllerDelegate {
	// MARK: - Properties
	
	var ringtoneModel: RingtoneViewModel
	
	private var imagePicker: UIImagePickerController?
	private let screenView: ContactPageView
	// MARK: - Init
	
	init(type: TypeOfDetailPage) {
		self.ringtoneModel = RingtoneViewModel()
		self.screenView = ContactPageView(type: type)
		super.init(nibName: nil, bundle: nil)
		
		switch type {
		case .new:
			setupNavigationBarForNewContact()
		case .existing:
			setupNavigationBarForExistingContact()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		setupView()
		setupDelegates()
		setupImagePicker()
	}
	// MARK: - Actions (@ojbc + @IBActions)
	
	@objc private func donePressed() {
		// сохранение нового контакта
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc private func editPressed() {
		// сохранение нового контакта
		self.navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Private Methods
	
	private func setupView() {
		view.addSubview(screenView)
		screenView.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
	
	private func setupNavigationBarForNewContact() {
		navigationController?.navigationItem.leftBarButtonItem?.title = "Cancel"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
	}
	
	private func setupNavigationBarForExistingContact() {
		navigationController?.navigationBar.topItem?.backButtonTitle = "Contacts"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed))
	}
	
	private func setupDelegates() {
		screenView.textFields.forEach { $0.delegate = self }
		
		screenView.notesDelegate?.delegate = self
		screenView.phoneNumberDelegate?.delegate = self
		
		screenView.ringtonePickerDelegate?.delegate = self
		screenView.ringtonePickerDelegate?.dataSource = self
		
		screenView.profileImageDelegate = self
	}
	
	private func setupImagePicker() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.imagePicker = UIImagePickerController()
			self.imagePicker?.delegate = self
			self.imagePicker?.sourceType = .photoLibrary
		}
	}
	
}
// MARK: - UITextViewDelegate

extension ContactPageController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		print(textView.text)
		//		newContact.toPersonalInfo?.notes = textView.text
	}
}
// MARK: - UITextFieldDelegate

extension ContactPageController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let selectedTextFieldIndex = screenView.textFields.firstIndex(of: textField),
		   selectedTextFieldIndex < screenView.textFields.count - 1 {
			screenView.textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		var firstName: String?
		var lastName: String?
		var phoneNumber: String?
		if let type = textField.textContentType {
			switch type {
			case .familyName:
				lastName = textField.text
			//				newContact.lastName = textField.text
			case .name:
				firstName = textField.text
			//				newContact.firstName = textField.text
			case .telephoneNumber:
				//				newContact.toPersonalInfo?.phone = textField.text
				phoneNumber = textField.text
			default:
				return
			}
		}
	}
}
// MARK: - TextFieldButtonPressedDelegate

extension ContactPageController: TextFieldButtonPressedDelegate {
	func didPressButton(button: TextFieldButton) {
		print(#function)
		switch button {
		case .done:
			// добавление номера
			print("done")
		case .next:
			screenView.ringtonePickerDelegate?.isHidden = false
		}
	}
}
// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension ContactPageController: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return ringtoneModel.numberOfComponents
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return ringtoneModel.row(at: row)
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		screenView.ringtoneDelegate?.setName(ringtoneModel.row(at: row))
		screenView.ringtonePickerDelegate?.isHidden = true
	}
}

// MARK: - ProfileImageDelegate

extension ContactPageController: ProfileImageDelegate, UIImagePickerControllerDelegate {
	
	func imagePressed() {
		let alert = UIAlertController(title: "Выберите фото", message: nil, preferredStyle: .actionSheet)
		let fromGallery = UIAlertAction(title: "Из галереи", style: .default, handler: { [weak self] _ in
			guard let self = self, let picker = self.imagePicker  else { return }
			self.present(picker, animated: true, completion: nil)
		})
		let makePhoto = UIAlertAction(title: "Сделать фото", style: .default, handler: nil)
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		alert.addAction(fromGallery)
		alert.addAction(makePhoto)
		alert.addAction(cancel)
		self.present(alert, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let userPickedImage = info[.originalImage] as? UIImage {
			screenView.setImage(image: userPickedImage)
		}
		picker.dismiss(animated: true, completion: nil)
	}
	
}

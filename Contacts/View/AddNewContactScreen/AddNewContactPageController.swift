//
//  DetailContactInfoController.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//

import UIKit
import SnapKit

class AddNewContactPageController: UIViewController, UINavigationControllerDelegate {
	var ringtoneModel: RingtoneViewModel
	let screenView = AddNewContactPageView()
	private var imagePicker: UIImagePickerController?
	init() {
		self.ringtoneModel = RingtoneViewModel()
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
        setupNavigationBar()
		setupView()
		setupDelegates()
		setupImagePicker()
    }
	
	@objc private func donePressed() {
		//сохранение нового контакта
		self.navigationController?.popViewController(animated: true)
	}
	
	private func setupView() {
		view.addSubview(screenView)
		screenView.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
	
	private func setupNavigationBar() {
		navigationController?.navigationBar.topItem?.backButtonTitle = "Cancel"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))

	}
	
	private func setupDelegates() {
		screenView.textFields.forEach { $0.delegate = self }

		screenView.notesDelegate?.delegate = self
		screenView.phoneNumberDelegate?.delegate = self
		
		screenView.ringtonePickerDelegate?.delegate = self
		screenView.ringtonePickerDelegate?.dataSource = self
		
//		screenView.ringtone.viewModel = self
		
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

extension AddNewContactPageController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		print(textView.text)
//		newContact.toPersonalInfo?.notes = textView.text
	}
}
// MARK: - UITextFieldDelegate

extension AddNewContactPageController: UITextFieldDelegate {
	
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

extension AddNewContactPageController: TextFieldButtonPressedDelegate {
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

extension AddNewContactPageController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension AddNewContactPageController: ProfileImageDelegate, UIImagePickerControllerDelegate {
	
	func imagePressed() {
		let alert = UIAlertController(title: "Выберите фото", message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Из галереи", style: .default, handler: { [weak self] _ in
			guard let self = self else { return }
			self.present(self.imagePicker!, animated: true, completion: nil)
		}))
		alert.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: nil))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let userPickedImage = info[.originalImage] as? UIImage {
			screenView.setImage(image: userPickedImage)
		}
		imagePicker!.dismiss(animated: true, completion: nil)
	}

}

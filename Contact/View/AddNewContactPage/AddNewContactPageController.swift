//
//  DetailContactInfoController.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//

import UIKit
import SnapKit

class AddNewContactPageController: UIViewController, UINavigationControllerDelegate {
	// MARK: - Properties
	var viewModel: ContactPageViewModelType? {
		willSet(viewModel) {
			guard let viewModel = viewModel else { return }
			self.screenView.setupModel(viewModel: viewModel)
		}
	}
	
	private var ringtoneModel: RingtoneViewModel
	
	private var imagePicker: UIImagePickerController?
	private let screenView: AddNewContactPageView
	
	private var firstName: String?
	private var lastName: String?
	private var phoneNumber: String?
	private var ringtone: String?
	private var notes: String?
	private var image: Data?
	
	private var isDonePressed: Bool = false
	
	// MARK: - Init
	
	init() {
		self.ringtoneModel = RingtoneViewModel()
		self.screenView = AddNewContactPageView()
		super.init(nibName: nil, bundle: nil)
		
		self.setupNavigationBarForNewContact()
		
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
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.isDonePressed = false
	}
	// MARK: - Actions (@ojbc + @IBActions)
	
	@objc
	private func donePressed() {
		screenView.endEditing(true)
		if !isDonePressed {
			viewModel?.updateContact(firstName: self.firstName,
									 lastName: self.lastName,
									 phone: self.phoneNumber,
									 ringtone: self.ringtone,
									 notes: self.notes,
									 image: self.image)
			self.isDonePressed = true
		}
	}
	
	@objc private func goBack() {
		self.navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Private Methods
	
	private func setupView() {
		view.addSubview(screenView)
		screenView.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
	
	private func setupNavigationBarForNewContact() {
		self.navigationItem.hidesBackButton = true
		let backItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(goBack))
		navigationItem.leftBarButtonItem = backItem
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
	}
	
	private func setupDelegates() {
		[screenView.textFields.0, screenView.textFields.1].forEach { $0.delegate = self }
		
		screenView.notes?.delegate = self
		screenView.phoneNumber?.delegate = self
		
		screenView.ringtonePicker?.delegate = self
		screenView.ringtonePicker?.dataSource = self
		
		screenView.contactImage = self
				
	}
	
}
// MARK: - UITextViewDelegate

extension AddNewContactPageController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		if let type = textView.textContentType {
			switch type {
			case .username:
				self.notes = textView.text
			case .telephoneNumber:
				self.phoneNumber = textView.text
			default:
				return
			}
		}
		
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if let type = textView.textContentType {
			switch type {
			case .username:
				screenView.notesPressed()
			default:
				screenView.notesNotPressed()
			}
		}
	}
	
}
// MARK: - UITextFieldDelegate

extension AddNewContactPageController: UITextFieldDelegate {
	// для перехода на след textField
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let textFields = [screenView.textFields.0, screenView.textFields.1]
		if let selectedTextFieldIndex = textFields.firstIndex(of: textField),
		   selectedTextFieldIndex < textFields.count - 1 {
			textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
			screenView.phoneNumber?.becomeFirstResponder()
		}
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		if let type = textField.textContentType {
			switch type {
			case .familyName:
				self.lastName = textField.text
			case .name:
				self.firstName = textField.text
			default:
				return
			}
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
		screenView.setRingtone(ringtoneModel.row(at: row))
		self.ringtone = ringtoneModel.row(at: row)
	}
}

// MARK: - ProfileImageDelegate

extension AddNewContactPageController: ContactImageDelegate, UIImagePickerControllerDelegate {
	
	func press() {
		let alert = UIAlertController(title: "Photo", message: nil, preferredStyle: .actionSheet)
		let fromGallery = UIAlertAction(title: "Choose photo", style: .default, handler: { [weak self] _ in
			self?.setupImagePicker(for: .photoLibrary)
		})
		let makePhoto = UIAlertAction(title: "Take photo", style: .default, handler: { [weak self] _ in
			self?.setupImagePicker(for: .camera)
		})
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		alert.addAction(fromGallery)
		alert.addAction(makePhoto)
		alert.addAction(cancel)
		self.present(alert, animated: true, completion: nil)
	}
	
	func setupImagePicker(for type: UIImagePickerController.SourceType) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.imagePicker = UIImagePickerController()
			if let picker = self.imagePicker {
				picker.delegate = self
				picker.sourceType = type
				self.present(picker, animated: true, completion: nil)
			}
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let userPickedImage = info[.originalImage] as? UIImage {
			self.image = userPickedImage.jpegData(compressionQuality: 0.5)
			screenView.setImage(image: userPickedImage)
		}
		picker.dismiss(animated: true, completion: nil)
	}
}

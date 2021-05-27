//
//  RingtoneCell.swift
//  Contact
//
//  Created by Екатерина Григорьева on 26.05.2021.
//

import UIKit
import SnapKit

class RingtoneCell: UIView {
	
	private let name = UILabel()
	private let ringtone = UILabel()
	
	lazy private var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [ringtone, name])
		stack.axis = .vertical
		stack.distribution = .fillProportionally
		return stack
	}()
	
	private let image: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.image = UIImage(systemName: "chevron.forward")
		imageView.tintColor = .gray
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupView()
		setupLabelsAttribute()
		
		self.drawLine()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setName(_ title: String?) {
		name.text = title
	}
	
	private func setupView() {
		
		self.addSubview(stack)
		stack.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(3)
			make.leading.equalToSuperview()
		}
		
		self.addSubview(image)
		
		image.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(22)
			make.trailing.equalToSuperview().inset(10)
		}
	}
	
	private func setupLabelsAttribute() {
		ringtone.text = "Ringtone"
		name.text = Ringtone.ringtoneArray.first
		
		ringtone.font = UIFont.systemFont(ofSize: 15)
		name.font = UIFont.systemFont(ofSize: 20)
	}
}

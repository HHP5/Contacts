//
//  ProfileImage.swift
//  Contact
//
//  Created by Екатерина Григорьева on 05.06.2021.
//

import UIKit

class ProfileImageView: UIImageView {

	let height: CGFloat = 50
	
	init() {
		super.init(frame: .zero)
		
		self.sizeToFit()
		self.clipsToBounds = true
		self.layer.borderWidth = 1
		self.layer.borderColor = UIColor.gray.cgColor
		self.snp.makeConstraints {$0.width.height.equalTo( height * 2)}
		self.layer.cornerRadius = height
		self.image = UIImage(named: "icon")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

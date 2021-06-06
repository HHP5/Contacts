//
//  ProfileImage.swift
//  Contact
//
//  Created by Екатерина Григорьева on 05.06.2021.
//

import UIKit

class ProfileImage: UIImageView {

	init() {
		super.init(frame: .zero)
		
		self.sizeToFit()
		self.clipsToBounds = true
		self.layer.borderWidth = 1
		self.layer.borderColor = UIColor.gray.cgColor
		self.snp.makeConstraints {$0.width.height.equalTo(Constant.heightOfCell(type: .fullName) * 2)}
		self.layer.cornerRadius = CGFloat((Constant.heightOfCell(type: .fullName) ))
		self.image = UIImage(named: "icon")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

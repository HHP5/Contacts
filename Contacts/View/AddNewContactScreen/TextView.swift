//
//  TextTableViewCell.swift
//  Contact
//
//  Created by Екатерина Григорьева on 25.05.2021.
//

import UIKit
import SnapKit

class TextView: UIView {
	
	let textView = UITextView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupTextView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupTextView() {
		self.addSubview(textView)
		
		textView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview().offset(-5)
		}

		textView.isEditable = true
		textView.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .medium)
		self.drawLine()
	}
}

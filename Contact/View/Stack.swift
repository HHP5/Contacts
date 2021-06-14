//
//  Stack.swift
//  Contact
//
//  Created by Екатерина Григорьева on 05.06.2021.
//

import UIKit
import SnapKit

class Stack: UIView {
	
	var arrangedSubviews: [UIView]
	var spacing: CGFloat
	var height: Int?
	var axis: NSLayoutConstraint.Axis
	private var stack = UIStackView()
	
	init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, height: PersonalInfoType?) {
		self.arrangedSubviews = arrangedSubviews
		self.spacing = spacing
		self.axis = axis
		
		switch height {
		case .detail:
			self.height = 70
		case .fullName:
			self.height = 50
		default:
			break
		}
		
		super.init(frame: .zero)
		
		self.setupStack()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupStack() {
		stack = UIStackView(arrangedSubviews: arrangedSubviews)
		self.addSubview(stack)
		
		stack.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		stack.spacing = spacing
		stack.axis = axis
		stack.distribution = .fill
		
		if let height = height {
			stack.arrangedSubviews.forEach { view in
				view.snp.makeConstraints { make in
					make.height.equalTo(height)
				}
			}
		}
	}
}

//
//  DrawLineUnderView.swift
//  Contact
//
//  Created by Екатерина Григорьева on 26.05.2021.
//

import UIKit

extension UIView {
	func drawLine() {
		let border = UIView()
		border.backgroundColor = #colorLiteral(red: 0.2256762683, green: 0.2243411243, blue: 0.2267067134, alpha: 1)
	
		self.addSubview(border)
		border.snp.makeConstraints { make in
			make.bottom.leading.trailing.equalToSuperview()
			make.height.equalTo(1)
		}
	}
	
}

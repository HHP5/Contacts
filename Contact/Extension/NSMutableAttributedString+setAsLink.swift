//
//  q.swift
//  Contact
//
//  Created by Екатерина Григорьева on 05.06.2021.
//

import UIKit

extension NSMutableAttributedString {
	public func setAsLink(text: String, linkURL: String) {
		let foundRange = self.mutableString.range(of: text)
		let attributes: [NSAttributedString.Key: Any] = [
			.link: linkURL,
			.font: UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .medium)
		]
		self.addAttributes(attributes, range: foundRange)
		
	}
}

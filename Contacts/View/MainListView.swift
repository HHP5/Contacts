//
//  MainListView.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//

import UIKit
import SnapKit

class MainListView: UIView {
	let identifier = "cell"
	// MARK: - IBOutlets (всегда приватные)
	let table: UITableView = {
		let table = UITableView()
		return table
	}()
	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		table.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
		setupTable()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private Methods

	private func setupTable() {
		self.addSubview(table)
		
		table.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
	}
}

//
//  MainListView.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//

import UIKit
import SnapKit

class MainListView: UIView {
	// MARK: - IBOutlets (всегда приватные)
	let table: UITableView = {
		let table = UITableView()
		table.register(UITableViewCell.self, forCellReuseIdentifier: Constans.identifierForCell)
		return table
	}()
	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
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

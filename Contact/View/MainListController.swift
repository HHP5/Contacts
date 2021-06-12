//
//  ViewController.swift
//  Contacts
//
//  Created by Екатерина Григорьева on 23.05.2021.
//
import UIKit
import SnapKit

class MainListController: UIViewController, UISearchControllerDelegate {
	// MARK: - Properties

	private var viewModel: MainListViewModelType
	private let table: UITableView = {
		let table = UITableView()
		table.register(UITableViewCell.self, forCellReuseIdentifier: Constant.identifierForCell)
		return table
	}()
	
	private let searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search"
		searchController.searchBar.backgroundColor = .clear
		searchController.searchBar.tintColor = .black
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchBar.barStyle = .default
		searchController.definesPresentationContext = true
		return searchController
	}()
		
	// MARK: - Init
	
	init(viewModel: MainListViewModelType) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.82)
		
		searchController.searchBar.delegate = self
		searchController.searchResultsUpdater = self
	
		table.delegate = self
		table.dataSource = self
		
		setupNavigationBar()
		setupTable()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.reloadData()
		table.reloadData()
		
	}
		
	// MARK: - Actions (@ojbc + @IBActions)
	@objc
	private func plusPressed() {
		viewModel.createNewContact()
	}
	// MARK: - Private Methods
	
	private func setupNavigationBar() {
		navigationController?.navigationBar.topItem?.title = "Contacts"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
															style: .plain,
															target: self,
															action: #selector(plusPressed))
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = true
	}
	
	private func setupTable() {
		view.addSubview(table)
		
		table.snp.makeConstraints { make in
			make.bottom.trailing.leading.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
		}
	}
}

// MARK: - UITableViewDataSource, UITableViewDelegate 

extension MainListController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.numberOfSections
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return viewModel.titleForHeaderInSection(in: section)
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return viewModel.sectionIndexTitles
	}
	
	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return viewModel.sectionForSectionIndexTitle(for: index)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRowsInSection(in: section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constant.identifierForCell, for: indexPath)
		cell.textLabel?.text = viewModel.cellForRow(at: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.didSelectContact(at: indexPath)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}

// MARK: - UISearchResultsUpdating

extension MainListController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		if let text = searchController.searchBar.text {
			if !text.isEmpty {
				viewModel.search(for: text.lowercased())
			} else {
				viewModel.cancelSearch()
			}
		}
		table.reloadData()
	}
}

// MARK: - UISearchBarDelegate

extension MainListController: UISearchBarDelegate {
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		viewModel.cancelSearch()
	}
}

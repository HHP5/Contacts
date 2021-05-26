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
	weak var coordinator: MainCoordinator?

	var viewModel: MainListViewModelType
	let screenView = MainListView()
	
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
	
	// MARK: - IBOutlets (всегда приватные)
	
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
		view.backgroundColor = #colorLiteral(red: 0.8146950603, green: 0.8098530769, blue: 0.8184176087, alpha: 1)
		
		searchController.searchBar.delegate = self
		searchController.searchResultsUpdater = self
		
		screenView.table.delegate = self
		screenView.table.dataSource = self
		
		setupNavigationBar()
		setupView()
		
		//		print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
	}
	// MARK: - Public Methods
	
	// MARK: - Actions (@ojbc + @IBActions)
	@objc private func plusPressed() {
		navigationController?.pushViewController(AddNewContactPageController(), animated: true)
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
	}
	
	private func setupView() {
		view.addSubview(screenView)
		
		screenView.snp.makeConstraints { make in
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
		let cell = tableView.dequeueReusableCell(withIdentifier: Constans.identifierForCell, for: indexPath)
		cell.textLabel?.text = viewModel.cellForRow(at: indexPath)
		return cell
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
		screenView.table.reloadData()
	}
}

// MARK: - UISearchBarDelegate

extension MainListController: UISearchBarDelegate {
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		viewModel.cancelSearch()
	}
}

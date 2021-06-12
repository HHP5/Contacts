//
//  Coordinator.swift
//  Contact
//
//  Created by Екатерина Григорьева on 04.06.2021.
//

import UIKit

protocol Coordinator : class {
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController {get set}
	func start()
}

extension Coordinator {
	func childDidFinish(_ child: Coordinator?) {
		for (index, coordinator) in childCoordinators.enumerated() {
			if coordinator === child {
				childCoordinators.remove(at: index)
				navigationController.popViewController(animated: true)
				break
			}
		}
	}
}

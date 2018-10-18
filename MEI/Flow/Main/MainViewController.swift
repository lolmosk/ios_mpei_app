//
//  MainViewController.swift
//  MEI
//
//  Created by Alex Lavrinenko on 23.06.2018.
//

import UIKit

struct MainSectionViewModel {
	var rows: [MainRowViewModel] = []
	let title: String
	
	let height: CGFloat
	
	init(title: String, row: [MainRowViewModel], height: CGFloat = 60) {
		self.title = title
		self.rows = row
		self.height = height
	}
}

class MainViewController: UIViewController {
	
	@IBOutlet weak var mainTableView: UITableView!
	
	var tableDataSource: MainTableDataSource = MainTableDataSource()
	
	let queueService = QueueService()
	
	var sections: [MainSectionViewModel] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView(mainTableView, dataSource: tableDataSource)
		AppDelegate.getUserInfo()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		requestData()
	}
	
	func requestData() {
		let group = DispatchGroup()
		group.enter()
		queueService.getQueueLoad(result: { [weak self] (row) in
			let section = MainSectionViewModel(title: "Состояние очереди",
																				 row: [row])
			self?.sections.append(section)
			group.leave()
		}) { (err) in
			group.leave()
		}
		
		group.enter()
		queueService.getQueueNumbers(result: { [weak self] (numbers) in
			let row = QueueNumberResponse(from: "Аудитория", value: "Номера")
			let section = MainSectionViewModel(title: "Кабинеты",
																				 row: [row] + numbers,
																				 height: 40)
			self?.sections.append(section)
			group.leave()
		}) { (err) in
			group.leave()
		}
		
		group.notify(queue: DispatchQueue.main) { [weak self] in
			if let sections = self?.sections {
				self?.tableDataSource.sections = sections
				self?.mainTableView.reloadData()
			}
		}
	}
	
	func setupTableView(_ tableView: UITableView, dataSource: MainTableDataSource) {
		tableView.delegate = dataSource
		tableView.dataSource = dataSource
		
		tableView.allowsSelection = false
		tableView.register(UINib(nibName: "QueueSectionHeader", bundle: nil),
														forHeaderFooterViewReuseIdentifier: "QueueSectionHeader")
		
		tableView.backgroundView = nil
	}
}


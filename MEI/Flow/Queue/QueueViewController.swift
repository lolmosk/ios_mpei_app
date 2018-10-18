//
//  QueueViewController.swift
//  MEI
//
//  Created by Alex Lavrinenko on 17.06.2018.
//

import UIKit

class QueueViewController: UIViewController {
	
	@IBOutlet weak var queueTableView: UITableView!
	
	var serviceQueue: QueueServiceInput = QueueService()
	
	var viewModelArray = [DayViewModel]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView(queueTableView)
		title = "Очередь"
		
		serviceQueue.set(output: self)
		serviceQueue.getPlaces(for: 1,
													 education: 1,
													 intervals: 0)
	}
	
	func setupTableView(_ tableView: UITableView) {
		queueTableView.delegate = self
		queueTableView.dataSource = self
		queueTableView.backgroundView = nil
		queueTableView.allowsSelection = false
		queueTableView.register(UINib(nibName: "QueueSectionHeader", bundle: nil),
														forHeaderFooterViewReuseIdentifier: "QueueSectionHeader")
	}
}

struct DayViewModel {
	var inervalArray: [IntervalViewModel] = []
	var day: String
	
	init(day: String) {
		self.day = day
	}
}

struct IntervalViewModel {
	var IdTimeInterval: String
	var begin: String
	var end: String
}

extension QueueViewController: QueueServiceOutput {
	func didGetPlaces(_ queueResponse: QueueResponse) {
		var dayViewModelArray = [DayViewModel]()
		var daySet = Set<String>()
		for value in queueResponse.intervals.values {
			daySet.insert(value.day)
		}
		for day in daySet {
			dayViewModelArray.append(DayViewModel(day: day))
		}
		for value in queueResponse.intervals.values {
			for index in 0..<dayViewModelArray.count {
				if (dayViewModelArray[index].day == value.day) {
					let itervalViewModel = IntervalViewModel(IdTimeInterval: value.IdTimeInterval,
														begin: value.begin,
														end: value.end)
					dayViewModelArray[index].inervalArray.append(itervalViewModel)
					break
				}
			}
		}
		viewModelArray = dayViewModelArray
		queueTableView.reloadData()
	}
	
	func didRecieveError(_ error: Error) {
		let alertVc = UIAlertController.error(with: "Не удалось загрузить очередь. Попробуйте позже")
		present(alertVc, animated: true, completion: nil)
	}
}

extension QueueViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModelArray.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModelArray[section].inervalArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "QueueTableViewCell",
																									 for: indexPath) as? QueueTableViewCell else {
																										fatalError()
		}
		let viewModel = viewModelArray[indexPath.section].inervalArray[indexPath.row]
		cell.intervalLabel?.text = "C \(viewModel.begin) до \(viewModel.end)"
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "QueueSectionHeader") as? QueueSectionHeader else {
			return nil
		}
		view.titleLabel.text = viewModelArray[section].day
		return view
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
}

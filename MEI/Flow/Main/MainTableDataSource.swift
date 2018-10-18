//
//  MainTableDataSource.swift
//  MEI
//
//  Created by Alex Lavrinenko on 23.06.2018.
//

import UIKit

protocol MainRowViewModel {
	
}

class MainTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	var sections: [MainSectionViewModel] = []
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = sections[indexPath.section].rows[indexPath.row]
		if let queueLoadRow = row as? QueueLoadResponse {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "QueueLoadCell") else {
				fatalError()
			}
			let iconSize = UIScreen.main.bounds.width / 10 - 1
			for i in 0...queueLoadRow.load {
				let imageView = UIImageView(frame: CGRect(x: iconSize * CGFloat(i),
																									y:0 ,
																									width: iconSize,
																									height: sections[indexPath.section].height - 25))
				imageView.image = #imageLiteral(resourceName: "ic_queue")
				imageView.contentMode = .scaleAspectFit
				imageView.tintColor = hexStringToUIColor(hex: queueLoadRow.color)
				cell.contentView.addSubview(imageView)
			}
			let label = UILabel(frame: CGRect(x: 8, y: sections[indexPath.section].height - 25,
																				width: 150, height: 25))
			label.text = queueLoadRow.descrip
			label.textColor = UIColor.gray
			cell.contentView.addSubview(label)
			return cell
		}
		if let queueNumberRow = row as? QueueNumberResponse {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainQueueNumberTableRow") as? MainQueueNumberTableRow else {
				fatalError()
			}
			cell.auditLabel.text = queueNumberRow.from
			cell.numberLabel.text = queueNumberRow.value
			return cell
		}
		return UITableViewCell()
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "QueueSectionHeader") as? QueueSectionHeader else {
			return nil
		}
		view.titleLabel.text = sections[section].title
		return view
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].rows.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return sections[indexPath.section].height
	}
}

func hexStringToUIColor (hex:String) -> UIColor {
	var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
	
	if (cString.hasPrefix("#")) {
		cString.remove(at: cString.startIndex)
	}
	
	if ((cString.count) != 6) {
		return UIColor.gray
	}
	
	var rgbValue:UInt32 = 0
	Scanner(string: cString).scanHexInt32(&rgbValue)
	
	return UIColor(
		red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
		green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
		blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
		alpha: CGFloat(1.0)
	)
}

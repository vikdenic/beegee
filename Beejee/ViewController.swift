//
//  ViewController.swift
//  Beejee
//
//  Created by Vik Denic on 3/16/17.
//  Copyright © 2017 Vik Denic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let kCellId = "deviceCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Bluetooth.sharedInstance.foundSimblee = { simblee in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Bluetooth.sharedInstance.startScan()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Bluetooth.sharedInstance.simblees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId)
        cell?.textLabel?.text = Bluetooth.sharedInstance.simblees[indexPath.row].serialNumber
        return cell!
    }
}


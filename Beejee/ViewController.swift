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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Bluetooth.sharedInstance.foundSimblee = { simblee in
            self.tableView.reloadData()
        }
        
        Bluetooth.sharedInstance.lostSimblee = { simblee in
            self.tableView.reloadData()
        }
        
        Bluetooth.sharedInstance.scanStateChanged = { state in
            self.tableView.reloadData()
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Bluetooth.sharedInstance.simblees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell")
        
        let simblee = Bluetooth.sharedInstance.simblees[indexPath.row]
        cell?.textLabel?.text = simblee.peripheral?.identifier.uuidString
        return cell!
    }
}


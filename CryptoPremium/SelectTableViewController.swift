//
//  SelectTableViewController.swift
//  CryptoPremium
//
//  Created by KimSeulWoo on 2018. 1. 10..
//  Copyright © 2018년 Maxwell Stein. All rights reserved.
//

import UIKit

class SelectTableViewController: UITableViewController {
    let allCurrenies: [CurrencyType] = Const.allCurrencies
    var userCurrencies: [CurrencyType] = []
    let reuseIdentifier = String(describing: SelectTableViewCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "코인 선택"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.back))
        
        if let savedCurrencies = UserDefaults.standard.object(forKey: "userCurrencies") as? [String] {
            userCurrencies = savedCurrencies.map{ CurrencyType(rawValue: $0)! }
        } else {
            userCurrencies = []
        }
        
        self.tableView.allowsMultipleSelection = true
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        let rawValueList = userCurrencies.map{ $0.rawValue }
        UserDefaults.standard.set(rawValueList, forKey: "userCurrencies")
        
        let shareDefaults = UserDefaults(suiteName: "group.CryptoPremium")
        shareDefaults?.set(rawValueList, forKey: "userCurrencies")
        
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCurrenies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let cell = tableViewCell as? SelectTableViewCell {
            let currencyType = allCurrenies[indexPath.row]
            cell.currencyImageView.image = currencyType.image
            cell.currencyName.text = currencyType.name
            cell.selectionStyle = .none
            
            if userCurrencies.contains(currencyType) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                cell.accessoryType = .checkmark
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
                cell.accessoryType = .none
            }
        }
        
        return tableViewCell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if !userCurrencies.contains(allCurrenies[row]) {
            userCurrencies.append(allCurrenies[row])
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        userCurrencies.remove(at: userCurrencies.index(of: allCurrenies[row])!)
    }

}

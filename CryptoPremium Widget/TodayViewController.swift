//
//  TodayViewController.swift
//  CryptoPremium Widget
//
//  Created by KimSeulWoo on 2018. 1. 10..
//  Copyright © 2018년 Maxwell Stein. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var widgetTableView: UITableView!
    var userCurrencies:[CurrencyType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetTableView.dataSource = self
        widgetTableView.delegate = self
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTableView) , userInfo: nil, repeats: true)
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        
    }
    
    @objc func reloadTableView() {
        let shareDefaults = UserDefaults(suiteName: "group.CryptoPremium")
        if let savedCurrencies = shareDefaults?.object(forKey: "userCurrencies") as? [String] {
            userCurrencies = savedCurrencies.map{ CurrencyType(rawValue: $0)! }
        } else {
            userCurrencies = []
        }
        
        self.widgetTableView.reloadData()
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0, height: 280)
        } else {
            preferredContentSize = maxSize
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCurrencies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)
        
        if let cell = tableViewCell as? CurrencyTableViewCell {
            let currency = userCurrencies[indexPath.row]
            cell.formatCell(withCurrencyType: currency)
        }
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* So far empty, but we could implement this function so that we open the App and jump to the detail, when clicked */
    }
    
}

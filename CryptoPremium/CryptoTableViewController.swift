import UIKit
import Alamofire
import SwiftyJSON

final class CryptoTableViewController: UITableViewController {

    let currencies: [CurrencyType] = [.btc, .eth, .ltc, .xrp, .xmr, .neo, .ada, .snt, .qtum]
    let reuseIdentifier = String(describing: CryptoTableViewCell.self)
    var exchangeRate: Float = 1000
    
    override func viewDidLoad() {
        self.navigationItem.title = "업비트-Bittrex 프리미엄"
        getExchangeRate()
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.getExchangeRate) , userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.reloadTableView) , userInfo: nil, repeats: true)
    }
    
    @objc func getExchangeRate() {
        let exchangeRateURL = "https://api.fixer.io/latest?base=USD&symbols=KRW"
        Alamofire.request(exchangeRateURL).responseJSON{ response in
            if((response.result.value) != nil) {
                let responseJson = JSON(response.result.value!)
                self.exchangeRate = responseJson["rates"]["KRW"].rawValue as! Float
            }
        }
    }
    
    @objc func reloadTableView() {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let cryptoTableViewCell = tableViewCell as? CryptoTableViewCell {
            let currencyType = currencies[indexPath.row]
            cryptoTableViewCell.formatCell(withCurrencyType: currencyType, exchangeRate: exchangeRate)
        }
        
        return tableViewCell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "기준환율(KRW->USD): " + String(self.exchangeRate)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return "업데이트 시간: " + dateString
    }
}


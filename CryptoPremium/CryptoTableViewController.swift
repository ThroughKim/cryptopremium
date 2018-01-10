import UIKit
import Alamofire
import SwiftyJSON

class CryptoTableViewController: UITableViewController {
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.zPosition = 1
        
        return view
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "표시할 코인이 없습니다. \r\n\r\n우측상단의 편집버튼을 클릭하여\r\n 시세정보를 보고자 하는 코인을 추가해주십시요."
        label.textAlignment = .center
        label.numberOfLines = 5
        
        return label
    }()
    
    var userCurrencies: [CurrencyType] = []
    
    let reuseIdentifier = String(describing: CryptoTableViewCell.self)
    var exchangeRate: Float = 1000
    
    override func viewDidLoad() {
        self.navigationItem.title = "김프차트"

        getExchangeRate()
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.getExchangeRate) , userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTableView) , userInfo: nil, repeats: true)
        
        self.view.addSubview(emptyView)
        self.emptyView.addSubview(emptyLabel)
        
        emptyView.snp.makeConstraints{ make in
            make.width.height.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints{ make in
            make.centerX.width.equalToSuperview()
            make.topMargin.equalTo(20)
        }
        emptyView.isHidden = true
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
        if let savedCurrencies = UserDefaults.standard.object(forKey: "userCurrencies") as? [String] {
            userCurrencies = savedCurrencies.map{ CurrencyType(rawValue: $0)! }
        } else {
            userCurrencies = []
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = userCurrencies.count
        if itemCount == 0 {
            self.emptyView.isHidden = false
        } else {
            self.emptyView.isHidden = true
        }
        return itemCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let cryptoTableViewCell = tableViewCell as? CryptoTableViewCell {
            let currencyType = userCurrencies[indexPath.row]
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = userCurrencies[indexPath.row].rawValue
        let upbitURL = "https://upbit.com/exchange?code=CRIX.UPBIT.KRW-\(selected)"
        
        UIApplication.shared.open(URL(string: upbitURL)!, options: [:], completionHandler: nil)
    }
}

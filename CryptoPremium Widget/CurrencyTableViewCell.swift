import UIKit
import SnapKit

class CurrencyTableViewCell: UITableViewCell {
    var currencyName: UILabel!
    var currencyPrice: UILabel!
    var currencyChange: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .white
        
        currencyName = UILabel()
        currencyPrice = UILabel()
        currencyChange = UILabel()
        
        self.addSubview(currencyName)
        self.addSubview(currencyPrice)
        self.addSubview(currencyChange)
        
        currencyChange.font = UIFont.systemFont(ofSize: 14)
        
        currencyName.snp.makeConstraints{ make in
            make.leftMargin.equalTo(15)
            make.centerY.equalToSuperview()
        }
        currencyPrice.snp.makeConstraints{ make in
            make.bottom.equalTo(currencyName)
            make.left.equalTo(contentView.snp.centerX).offset(15)
        }
        currencyChange.snp.makeConstraints{ make in
            make.left.equalTo(currencyPrice.snp.right).offset(5)
            make.bottom.equalTo(currencyPrice)
        }
    }
    
    func formatCell(withCurrencyType currencyType: CurrencyType) {
        currencyName.text = currencyType.name
        
        currencyType.requestValue { (values) in
            DispatchQueue.main.async {
                guard let values = values else {
                    return
                }
                guard let priceUpbit = values["krwPrice"] else {
                    self.currencyPrice.text = "-"
                    return
                }
                guard let openingPrice = values["krwOpeningPrice"] else {
                    return
                }
                
                self.setPercentChange(current: priceUpbit, opening: openingPrice)
                self.currencyPrice.text = priceUpbit.formattedCurrencyString
            }
        }
    }
    
    func setPercentChange(current: NSNumber, opening: NSNumber){
        let currentFloat = current as! Float
        let openingFloat = opening as! Float
        
        let change = (currentFloat - openingFloat) / openingFloat * 100
        let percentChange = String(format: "%.2f", change)
        self.currencyChange.text = "(\(percentChange)%)"
        
        if change > 0 {
            self.currencyPrice.textColor = .red
            self.currencyChange.textColor = .red
        } else if change == 0 {
            self.currencyPrice.textColor = .black
            self.currencyChange.textColor = .black
        } else if change < 0 {
            self.currencyPrice.textColor = .blue
            self.currencyChange.textColor = .blue
        }
    }

}

extension NSNumber {
    var formattedCurrencyString: String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.numberStyle = .currency
        
        guard let formattedCurrencyAmount = formatter.string(from: self) else {
            return nil
        }
        return formattedCurrencyAmount
    }
    
}

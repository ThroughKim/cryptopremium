import UIKit
import SnapKit

class CryptoTableViewCell: UITableViewCell {

    var currencyImageView: UIImageView!
    var currencyName: UILabel!
    var currencyPriceUpbit: UILabel!
    var currencyChange: UILabel!
    var currencyPremium: UILabel!
    
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
        
        currencyImageView = UIImageView()
        currencyName = UILabel()
        currencyPriceUpbit = UILabel()
        currencyChange = UILabel()
        currencyPremium = UILabel()
        
        currencyName.font = UIFont.systemFont(ofSize: 14)
        currencyPriceUpbit.font = UIFont.systemFont(ofSize: 17)
        currencyPriceUpbit.text = "₩0.0"
        currencyChange.font = UIFont.systemFont(ofSize: 15, weight: .light)
        currencyChange.text = "0.0"
        currencyPremium.font = UIFont.systemFont(ofSize: 17)
        currencyPremium.text = "- %"
        
        self.addSubview(currencyImageView)
        self.addSubview(currencyName)
        self.addSubview(currencyPriceUpbit)
        self.addSubview(currencyChange)
        self.addSubview(currencyPremium)
        
        currencyImageView.snp.makeConstraints{ make in
            make.height.width.equalTo(43)
            make.topMargin.equalTo(15)
            make.bottomMargin.equalTo(-15)
            make.leftMargin.equalTo(10)
        }
        currencyName.snp.makeConstraints{ make in
            make.left.equalTo(currencyImageView.snp.right).offset(15)
            make.top.equalTo(currencyImageView)
        }
        currencyPriceUpbit.snp.makeConstraints{ make in
            make.left.equalTo(currencyName)
            make.bottom.equalTo(currencyImageView)
        }
        currencyChange.snp.makeConstraints{ make in
            make.left.equalTo(currencyPriceUpbit.snp.right).offset(5)
            make.bottom.equalTo(currencyPriceUpbit)
        }
        currencyPremium.snp.makeConstraints{ make in
            make.rightMargin.equalTo(-10)
            make.bottom.equalTo(currencyChange)
        }
    }
    
    func formatCell(withCurrencyType currencyType: CurrencyType, exchangeRate: Float) {
        currencyName.text = currencyType.name
        currencyImageView.image = currencyType.image
        
        currencyType.requestValue { (values) in
            DispatchQueue.main.async {
                guard let values = values else {
                    return
                }
                guard let priceUpbit = values["krwPrice"] else {
                    self.currencyPriceUpbit.text = "-"
                    return
                }
                guard let pricebittrex = values["usdPrice"] else {
                    self.currencyChange.text = "- %"
                    return
                }
                guard let openingPrice = values["krwOpeningPrice"] else {
                    return
                }
                
                let convertedbittrexPrice = (pricebittrex as! Float * exchangeRate) as NSNumber
                
                self.setPercentChange(current: priceUpbit, opening: openingPrice)
                self.currencyPriceUpbit.text = priceUpbit.formattedCurrencyString
                self.setPremiumLabel(upbit: priceUpbit, bittrex: convertedbittrexPrice)
            }
        }
    }
    
    func setPercentChange(current: NSNumber, opening: NSNumber){
        let currentFloat = current as! Float
        let openingFloat = opening as! Float
        
        let change = (currentFloat - openingFloat) / openingFloat * 100
        let percentChange = String(format: "%.2f", change)
        self.currencyChange.text = "( \(percentChange) % )"
        
        if change > 0 {
            self.currencyPriceUpbit.textColor = .red
            self.currencyChange.textColor = .red
        } else if change == 0 {
            self.currencyPriceUpbit.textColor = .black
            self.currencyChange.textColor = .black
        } else if change < 0 {
            self.currencyPriceUpbit.textColor = .blue
            self.currencyChange.textColor = .blue
        }
    }
    
    func changeUsdToKrw(usd: NSNumber, exchangeRate: Float) -> NSNumber {
        let usdFloat:Float = usd as! Float
        let convertedUsd: NSNumber = (usdFloat * exchangeRate) as NSNumber
        
        return convertedUsd
    }
    
    func setPremiumLabel(upbit: NSNumber, bittrex: NSNumber) {
        let upbit:Float = upbit as! Float
        let bittrex:Float = bittrex as! Float
        if bittrex == 0 {
            self.currencyPremium.text = "- %"
        } else {
            let premium = (upbit - bittrex) / bittrex * 100
            self.currencyPremium.text = String(format: "%.1f", premium) + " %"
        }
    }

}

private extension NSNumber {
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

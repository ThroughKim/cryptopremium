import UIKit
import Alamofire
import SwiftyJSON

enum CurrencyType: String {
    case btc = "BTC",
    eth = "ETH",
    ltc = "LTC",
    xrp = "XRP",
    xmr = "XMR",
    neo = "NEO",
    ada = "ADA",
    snt = "SNT",
    qtum = "QTUM"
    
    var btcPriceURL: URL? {
        let apiString = "https://min-api.cryptocompare.com/data/price?e=Bittrex&fsym=BTC&tsyms=USD"
        return URL(string: apiString)
    }
    var usdURL: URL? {
        let apiString = "https://min-api.cryptocompare.com/data/price?e=Bittrex&fsym=" + rawValue + "&tsyms=USD"
        return URL(string: apiString)
    }
    var btcURL: URL? {
        let apiString = "https://min-api.cryptocompare.com/data/price?e=Bittrex&fsym=" + rawValue + "&tsyms=BTC"
        return URL(string: apiString)
    }
    var krwURL: URL? {
        let apiString = "https://crix-api-endpoint.upbit.com/v1/crix/candles/days?code=CRIX.UPBIT.KRW-" + rawValue
        return URL(string: apiString)
    }
    
    var name: String {
        switch self {
        case .btc:
            return "비트코인"
        case .eth:
            return "이더리움"
        case .ltc:
            return "라이트코인"
        case .xrp:
            return "리플"
        case .xmr:
            return "모네로"
        case .neo:
            return "네오"
        case .ada:
            return "에이다"
        case .snt:
            return "슨트"
        case .qtum:
            return "퀀텀"
        }
    }
    
    var image: UIImage {
        switch self {
        case .btc:
            return #imageLiteral(resourceName: "Bitcoin")
        case .eth:
            return #imageLiteral(resourceName: "Ethereum")
        case .ltc:
            return #imageLiteral(resourceName: "Litecoin")
        case .xrp:
            return #imageLiteral(resourceName: "Ripple")
        case .xmr:
            return #imageLiteral(resourceName: "Monero")
        case .neo:
            return #imageLiteral(resourceName: "NEO")
        case .ada:
            return #imageLiteral(resourceName: "Ada")
        case .snt:
            return #imageLiteral(resourceName: "SNT")
        case .qtum:
            return #imageLiteral(resourceName: "Qtum")
        }
    }
    
    func requestValue(completion: @escaping (_ value: [String: NSNumber]?) -> Void) {
        guard let krwURL = krwURL else { return }
        guard let usdURL = usdURL else { return }
        guard let btcURL = btcURL else { return }
        guard let btcPriceURL = btcPriceURL else { return }
        
        Alamofire.request(krwURL).responseJSON{ response in
            if((response.result.value) != nil) {
                let krwPrice = JSON(response.result.value!)[0]["tradePrice"].rawValue as! NSNumber
                let krwOpeningPrice = JSON(response.result.value!)[0]["openingPrice"].rawValue as! NSNumber
                
                Alamofire.request(usdURL).responseJSON { response in
                    if((response.result.value) != nil) {
                        if JSON(response.result.value!)["USD"].rawValue is NSNull{
                            Alamofire.request(btcPriceURL).responseJSON{ response in
                                if((response.result.value) != nil) {
                                    let btcUsdPrice = JSON(response.result.value!)["USD"].rawValue as! Float
                                    Alamofire.request(btcURL).responseJSON{ response in
                                        let btcPrice = JSON(response.result.value!)["BTC"].rawValue as! Float
                                        let usdPrice = (btcUsdPrice * btcPrice) as NSNumber
                                        
                                        let resultValues:[String: NSNumber] = [
                                            "krwPrice": krwPrice,
                                            "krwOpeningPrice": krwOpeningPrice,
                                            "usdPrice": usdPrice
                                        ]
                                        completion(resultValues)
                                    }
                                }
                            }
                        } else {
                            let usdPrice = JSON(response.result.value!)["USD"].rawValue as! NSNumber
                            
                            let resultValues:[String: NSNumber] = [
                                "krwPrice": krwPrice,
                                "krwOpeningPrice": krwOpeningPrice,
                                "usdPrice": usdPrice
                            ]
                            completion(resultValues)
                        }
                    }
                }
            }
        }
    }
    
}


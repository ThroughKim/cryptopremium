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
    qtum = "QTUM",
    storj = "STORJ",
    xlm = "XLM",
    ark = "ARK",
    bcc = "BCC",
    powr = "POWR",
    etc = "ETC",
    xem = "XEM",
    strat = "STRAT",
    rep = "REP",
    pivx = "PIVX",
    omg = "OMG",
    emc2 = "EMC2",
    kmd = "KMD",
    btg = "BTG",
    sbd = "SBD",
    steem = "STEEM",
    tix = "TIX",
    lsk = "LSK",
    waves = "WAVES",
    mer = "MER",
    grs = "GRS",
    vtc = "VTC",
    zec = "ZEC",
    dash = "DASH",
    ardr = "ARDR"
    
    
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
        case .storj:
            return "스토리지"
        case .xlm:
            return "스텔라루멘"
        case .ark:
            return "아크"
        case .bcc:
            return "비트코인캐시"
        case .powr:
            return "파워렛져"
        case .etc:
            return "이더리움클래식"
        case .xem:
            return "뉴이코"
        case .strat:
            return "스트라티스"
        case .rep:
            return "어거"
        case .pivx:
            return "피벡스"
        case .omg:
            return "오미세고"
        case .emc2:
            return "아인슈타이늄"
        case .kmd:
            return "코모도"
        case .btg:
            return "비트코인골드"
        case .sbd:
            return "스팀달러"
        case .steem:
            return "스팀"
        case .tix:
            return "블록틱스"
        case .lsk:
            return "리스크"
        case .waves:
            return "웨이브"
        case .mer:
            return "머큐리"
        case .grs:
            return "그로스톨코인"
        case .vtc:
            return "버트코인"
        case .zec:
            return "지캐시"
        case .dash:
            return "대시"
        case .ardr:
            return "아더"
        }
    }
    
    var image: UIImage {
        switch self {
        case .btc:
            return #imageLiteral(resourceName: "BTC")
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
        case .storj:
            return #imageLiteral(resourceName: "STORJ")
        case .xlm:
            return #imageLiteral(resourceName: "XLM")
        case .ark:
            return #imageLiteral(resourceName: "ARK")
        case .bcc:
            return #imageLiteral(resourceName: "BCC")
        case .powr:
            return #imageLiteral(resourceName: "POWR")
        case .etc:
            return #imageLiteral(resourceName: "ETC")
        case .xem:
            return #imageLiteral(resourceName: "XEM")
        case .strat:
            return #imageLiteral(resourceName: "STRAT")
        case .rep:
            return #imageLiteral(resourceName: "REP")
        case .pivx:
            return #imageLiteral(resourceName: "PIVX")
        case .omg:
            return #imageLiteral(resourceName: "OMG")
        case .emc2:
            return #imageLiteral(resourceName: "EMC2")
        case .kmd:
            return #imageLiteral(resourceName: "KMD")
        case .btg:
            return #imageLiteral(resourceName: "BTG")
        case .sbd:
            return #imageLiteral(resourceName: "SBD")
        case .steem:
            return #imageLiteral(resourceName: "STEEM")
        case .tix:
            return #imageLiteral(resourceName: "TIX")
        case .lsk:
            return #imageLiteral(resourceName: "LSK")
        case .waves:
            return #imageLiteral(resourceName: "WAVES")
        case .mer:
            return #imageLiteral(resourceName: "MER")
        case .grs:
            return #imageLiteral(resourceName: "GRS")
        case .vtc:
            return #imageLiteral(resourceName: "VTC")
        case .zec:
            return #imageLiteral(resourceName: "ZEC")
        case .dash:
            return #imageLiteral(resourceName: "DASH")
        case .ardr:
            return #imageLiteral(resourceName: "ARDR")
        }
    }
    
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
                                        var usdPrice = 0 as NSNumber
                                        if let btcPrice = JSON(response.result.value!)["BTC"].rawValue as? Float {
                                            usdPrice = (btcUsdPrice * btcPrice) as NSNumber
                                        }
                                        
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


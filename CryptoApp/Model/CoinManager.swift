
import Foundation

protocol CoinManagerDelegate {
        func didUpdateCoinPrice(price: String, currency: String)
        func didFailWithError(error: Error)
    }

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/SHIB"
    let apiKey = "my apiKey"
    
//TODO: Add -> let coinArray = ["SHIB", "MC", "BTC", "1INCH", "SFP", "LIT".....] and make a chice feature
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
 
//MARK: - URLSession goes here
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    
                    if let bitcoinPrice = self.parseJSON(safeData) {
                    let priceString = String(format: "%.7f", bitcoinPrice)
                        self.delegate?.didUpdateCoinPrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
//MARK: - Parsing JSON goes here
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
        } catch {
            print(error)
            return nil
        }
    }
}

//
//  WebService.swift
//  App Convert Coin
//
//  Created by Fernando Vergis on 02/08/21.
//

import Foundation

class WebService {
    
    let urlBase:String = "https://economia.awesomeapi.com.br"
    
    public func getCoins(pathParam:String, onCompletion: @escaping (ExchangeCoins?, String?) -> Void) {
        
        let api:String = self.urlBase+"/json/last/"+pathParam
        
        guard let url = URL(string: api) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let data = data {
                if let apiResponse = try? JSONDecoder().decode(ExchangeCoins.self, from: data) {
                    onCompletion(apiResponse, nil)
                } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    onCompletion(nil, error.message)
                } else {
                    onCompletion(nil, "Parse Error")
                }
                
            } else if let error = error {
                print(error.localizedDescription)
                onCompletion(nil, nil)
            }
            
        }.resume()
    }
}

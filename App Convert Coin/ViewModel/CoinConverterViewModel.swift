//
//  CoinConverterViewModel.swift
//  App Convert Coin
//
//  Created by Fernando Vergis on 02/08/21.
//

import Foundation

class CoinConverterViewModel {
    
    private var exchangeUserDefault:ExchangeUserDefault = ExchangeUserDefault()
    
    public var coinHistory:Coin?
    
    var numberRows: Int {
        return self.getHistoryExchange().count
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    public func getCoins(params:String, onCompletion: @escaping (ExchangeCoins?, String?) -> Void) {
        WebService().getCoins(pathParam:params) { (data, error) in
            if let coins = data {
                onCompletion(coins, nil)
            } else {
                onCompletion(nil, error)
            }
        }
    }
    
    public func calculateCoins(valueInfo:String, valueCoin:String) -> NSNumber {
        let value:Float = Float(valueInfo)!
        let coin:Float = Float(valueCoin)!
        
        let calc:Float = coin * value
        
        return NSNumber(value: calc)
    }
    
    public func getListCoins() -> [String] {
        return EnumCoins.allCases.map {$0.rawValue}
    }
    
    public func saveHistoryExchange(coin:Coin, onCompletion: @escaping (String) -> Void) {
        var listCoins:[Coin] = self.getHistoryExchange()
        if listCoins.count > 0 {
            let listAux = listCoins.filter {$0.code == coin.code && $0.codein == coin.codein}
            if listAux.count > 0 {
                onCompletion("Você já salvou um histórico para essa pesquisa")
            } else {
                listCoins.append(coin)
                self.exchangeUserDefault.save(listCoins: listCoins)
                onCompletion("Histórico salvo com sucesso")
            }
        } else {
            listCoins.append(coin)
            self.exchangeUserDefault.save(listCoins: listCoins)
            onCompletion("Histórico salvo com sucesso")
        }
    }
    
    public func getHistoryExchange() -> [Coin] {
        return self.exchangeUserDefault.getListCoins()
    }
}

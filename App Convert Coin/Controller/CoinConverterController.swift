//
//  CoinConverterController.swift
//  App Convert Coin
//
//  Created by Fernando Vergis on 02/08/21.
//

import UIKit
import iOSDropDown

class CoinConverterController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var dropDownTo: DropDown!
    @IBOutlet weak var dropDownFrom: DropDown!
    @IBOutlet weak var lblValueConvert: UILabel!
    @IBOutlet weak var txtValueInfo: UITextField!
    @IBOutlet weak var btnHistory: UIButton!
    
    //MARK: Private Vars
    private var coinUsed:Coin?
    
    //MARK: ViewModel
    private var viewModel: CoinConverterViewModel!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CoinConverterViewModel()
        
        self.btnHistory.isHidden = self.viewModel.getHistoryExchange().count <= 0
        
        self.configDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let coin = self.viewModel.coinHistory {
            self.dropDownTo.text = coin.code!
            self.dropDownFrom.text = coin.codein!
            self.txtValueInfo.text = "10"
        }
    }
    
    //MARK: @IBActions
    @IBAction func actGetCoin(_ sender: UIButton) {
        let error:String = self.validateFields()
        if error != String.empty() {
            self.view.showMessageView(view: self, message: error)
        } else {
            if let coin = self.viewModel.coinHistory {
                let valueStr:NSNumber = self.viewModel.calculateCoins(valueInfo: self.txtValueInfo.text!, valueCoin: coin.buyValue)
                self.lblValueConvert.text = String().formatCurrency(value: valueStr, enumCoin: self.dropDownFrom.text!)
            } else {
                let param1 = self.dropDownTo.text!
                let param2 = self.dropDownFrom.text!
                
                let param:String = "\(param1)-\(param2)"
                self.getCoins(param: param)
            }
        }
    }
    
    @IBAction func saveHistory(_ sender: UIButton) {
        let error:String = self.validateFields()
        if error != String.empty() {
            self.view.showMessageView(view: self, message: error)
        } else {
            if let coin = self.coinUsed {
                self.viewModel.saveHistoryExchange(coin: coin) { message in
                    self.view.showMessageView(view: self, message: message)
                }
            } else {
                self.view.showMessageView(view: self, message: "Você precisa primeiro fazer a conversão, para salvar")
            }
        }
        
        self.btnHistory.isHidden = self.viewModel.getHistoryExchange().count <= 0
    }
    
    @IBAction func showHistory(_ sender: UIButton) {
        self.performSegue(withIdentifier: "history", sender: nil)
    }
    
    //MARK: Private Funcs
    private func validateFields() -> String {
        var error:String = String.empty()
        
        if self.txtValueInfo.text == String.empty() {
            error = "Informe um valor a ser convertido"
        } else if self.dropDownTo.text == String.empty() || self.dropDownFrom.text == String.empty() {
            error = "Selecione as moedas a serem convertidas"
        } else if self.dropDownTo.text == self.dropDownFrom.text {
            error = "Selecione moedas diferentes"
        }
        
        return error
    }
    
    private func getCoins(param:String) {
        self.viewModel.getCoins(params: param){ (data, error) in
            if let coins = data {
                DispatchQueue.main.async {
                    self.coinUsed = coins.first!.value
                    let valueStr:NSNumber = self.viewModel.calculateCoins(valueInfo: self.txtValueInfo.text!, valueCoin: self.coinUsed!.buyValue)
                    self.lblValueConvert.text = String().formatCurrency(value: valueStr, enumCoin: self.dropDownFrom.text!)
                }
            } else {
                
            }
        }
    }
    
    private func configDropDown() {
        self.dropDownTo.optionArray = self.viewModel.getListCoins()
        self.dropDownTo.arrowSize = 9
        self.dropDownTo.selectedRowColor = .gray
        
        self.dropDownFrom.optionArray = self.viewModel.getListCoins()
        self.dropDownFrom.arrowSize = 9
        self.dropDownFrom.selectedRowColor = .gray
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? CoinConvertTableController {
            controller.viewModel = self.viewModel
        }
    }
}

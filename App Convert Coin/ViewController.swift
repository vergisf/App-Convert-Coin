//
//  ViewController.swift
//  App Convert Coin
//
//  Created by Fernando Vergis on 02/08/21.
//

import UIKit
import iOSDropDown

class ViewController: UIViewController {
    
    @IBOutlet weak var dropDownTo: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dropDownTo.optionArray = self.createList()
        self.dropDownTo.selectedRowColor = .gray
        self.dropDownTo.textColor = .black
        self.dropDownTo.arrowSize = 10
        self.dropDownTo.checkMarkEnabled = false
        
        self.dropDownTo.didSelect { text, index, id in
            self.dropDownTo.text = text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func createList() -> [String] {
        return ["Banana","Maça","Uva","Pêra","Maracuja","Limão","Abacate","Abacaxi","Morango"]
    }
    
    @IBAction func showDropDown(_ sender: Any) {
    
    }
}

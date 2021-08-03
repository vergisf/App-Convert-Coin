//
//  HistoryCell.swift
//  App Convert Coin
//
//  Created by Fernando Vergis on 03/08/21.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func setTitle(title:String) {
        self.lblTitle.text = title
    }
}

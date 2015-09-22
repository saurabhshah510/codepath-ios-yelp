//
//  DealsCell.swift
//  Yelp
//
//  Created by Saurabh Shah on 9/21/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DealsCellDelegate{
    optional func dealsCell(dealsCell: DealsCell, didChangeValue value: Bool)
}

class DealsCell: UITableViewCell {

    @IBOutlet weak var onSwitch: UISwitch!
    weak var delegate: DealsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onSwitchValueChange(sender: AnyObject) {
        delegate?.dealsCell?(self, didChangeValue: onSwitch.on)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

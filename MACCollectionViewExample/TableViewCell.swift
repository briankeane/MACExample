//
//  TableViewCell.swift
//  MACCollectionViewExample
//
//  Created by Brian D Keane on 7/22/16.
//  Copyright © 2016 Brian D Keane. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

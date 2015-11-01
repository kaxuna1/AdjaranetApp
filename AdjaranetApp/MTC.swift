//
//  MTC.swift
//  AdjaranetApp
//
//  Created by vakhtang gelashvili on 9/3/15.
//  Copyright © 2015 vakhtang gelashvili. All rights reserved.
//

import UIKit
import Async

class MTC: UITableViewCell {
    

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

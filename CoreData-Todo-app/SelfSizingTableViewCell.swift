//
//  SelfSizingTableViewCell.swift
//  TestApp
//
//  Created by Kamil Caglar on 11/10/2022.
//

import UIKit

class SelfSizingTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

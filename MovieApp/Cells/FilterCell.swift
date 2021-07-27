//
//  FilterCell.swift
//  MovieApp
//
//  Created by George Digmelashvili on 5/15/21.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected{ self.typeLabel.textColor = .blue}
        else{ self.typeLabel.textColor = .systemOrange}
        
    }
    
}

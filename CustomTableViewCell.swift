//
//  CustomTableViewCell.swift
//  WeightRecorder
//
//  Created by Tzu_Chen on 26/10/16.
//  Copyright © 2016 Tzu-Chen. All rights reserved.
//

import UIKit



class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet var cellImageView: UIImageView!
    
    @IBOutlet var cellFatRate: UILabel!
    @IBOutlet var cellWeight: UILabel!
    @IBOutlet var cellDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.font = UIFont(name: "Kohinoor_Bangla", size: 18.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

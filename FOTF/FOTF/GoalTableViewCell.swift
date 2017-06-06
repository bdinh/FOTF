//
//  GoalTableViewCell.swift
//  FOTF
//
//  Created by Abhishek Chauhan on 6/6/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var typeGoal: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var start_date: UILabel!
    @IBOutlet weak var end_date: UILabel!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ExerciseTableViewCell.swift
//  FOTF
//
//  Created by Bao Dinh on 6/5/17.
//  Copyright © 2017 info-449. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var exerciseImage: UIImageView!
    
    @IBOutlet weak var exerciseName: UILabel!

    @IBOutlet weak var exerciseAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

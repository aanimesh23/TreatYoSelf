//
//  PersonalJournalTableViewCell.swift
//  TreatYoSelf
//
//  Created by Animesh Agrawal on 3/8/20.
//  Copyright © 2020 Animesh Agrawal. All rights reserved.
//

import UIKit

class PersonalJournalTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    
    @IBOutlet weak var foodItemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

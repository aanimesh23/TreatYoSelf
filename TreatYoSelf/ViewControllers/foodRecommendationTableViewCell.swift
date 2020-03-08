//
//  foodRecommendationTableViewCell.swift
//  TreatYoSelf
//
//  Created by Animesh Agrawal on 3/8/20.
//  Copyright © 2020 Animesh Agrawal. All rights reserved.
//

import UIKit

class foodRecommendationTableViewCell: UITableViewCell {

    @IBOutlet weak var calorieCount: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var foodDetails: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  StadiumTableViewCell.swift
//  The 92
//
//  Created by Daniel Earl on 06/09/2020.
//  Copyright © 2020 Daniel Earl. All rights reserved.
//

import UIKit

class StadiumTableViewCell: UITableViewCell {

    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var stadiumName: UILabel!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamVisitCountImg: UIImageView!
    @IBOutlet weak var teamVisitCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

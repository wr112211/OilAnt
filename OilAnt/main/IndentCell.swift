//
//  IndentCell.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit

class IndentCell: UITableViewCell {

    @IBOutlet weak var dictrct: UILabel!
    @IBOutlet weak var stateLable: UILabel!
    @IBOutlet weak var goodname: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

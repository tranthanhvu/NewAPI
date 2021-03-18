//
//  ButtonTVC.swift
//  News
//
//  Created by ttvu on 3/18/21.
//

import UIKit

class ButtonTVC: UITableViewCell, ReusableView {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(text: String, color: UIColor = UIColor.systemBlue) {
        label.text = text
        label.textColor = color
    }
}

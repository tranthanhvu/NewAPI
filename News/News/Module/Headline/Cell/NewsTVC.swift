//
//  NewsTVC.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import UIKit
import SDWebImage

class NewsTVC: UITableViewCell, ReusableView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(article: Article) {
        title.text = article.title
        
        let secondText = [article.author, article.publishedAt.toString].filter({ !$0.isEmpty }).joined(separator: "\n")
        
        secondaryLabel.text = secondText
        
        let imageURL = URL(string: article.urlToImage)
        thumbnail.sd_setImage(with: imageURL)
    }
}

//
//  FavoriteTableViewCell.swift
//  MarvelCharactersApp
//
//  Created by Emircan saglam on 14.04.2023.
//

import UIKit
import Kingfisher

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteSession: UILabel!
    @IBOutlet weak var favoriteName: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(path: String, thumbnail: String) {
        
                   let thumbnailUrl = URL(string: path + "." + thumbnail)
                    favoriteImage.kf.setImage(with: thumbnailUrl)
            
    }
    
    
}

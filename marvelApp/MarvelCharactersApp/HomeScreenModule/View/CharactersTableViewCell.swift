//
//  CharactersTableViewCell.swift
//  MarvelCharactersApp
//
//  Created by Emircan Sağlam on 13.04.2023.
//

import UIKit
import Kingfisher
class CharactersTableViewCell: UITableViewCell {
    @IBOutlet weak var charactersImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
        
    }
    func configure(with character: newResult) {
            nameLabel.text = character.name
            if let thumbnailUrlString = character.thumbnail?.path,
               let thumbnailExtension = character.thumbnail?.thumbnailExtension,
               let thumbnailUrl = URL(string: thumbnailUrlString + "." + thumbnailExtension.rawValue) {
                charactersImage.kf.setImage(with: thumbnailUrl)
                
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

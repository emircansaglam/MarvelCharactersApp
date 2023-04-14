//
//  HomeScreenTableViewCell.swift
//  MarvelCharactersApp
//
//  Created by Emircan saglam on 13.04.2023.
//

import UIKit

class HomeScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var charactersImage: UIImageView!
    
    var characterId: Int?
    
    var isFavorite: Bool = false {
            didSet {
                let imageName = isFavorite ? "star-system-2" : "star-system-1"
                let image = UIImage(named: imageName)
                favoriteButton.setBackgroundImage(image, for: .normal)
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        favoriteButton.setTitle("", for: .normal)
        charactersImage.layer.cornerRadius = self.frame.height / 4.0
        charactersImage.layer.masksToBounds = true
        charactersImage.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            charactersImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            charactersImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            charactersImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            charactersImage.widthAnchor.constraint(equalToConstant: 100)
        ])

    }
    func setFavoriteButtonAction(action: Selector, target: Any) {
        favoriteButton.addTarget(target, action: action, for: .touchUpInside)
    }


    func configure(with character: newResult) {
        characterId = character.id
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

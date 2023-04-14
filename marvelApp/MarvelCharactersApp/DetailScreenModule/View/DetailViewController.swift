//
//  DetailViewController.swift
//  MarvelCharactersApp
//
//  Created by Emircan saglam on 14.04.2023.
//

import UIKit
import Kingfisher
class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var firstHeight: NSLayoutConstraint!
    @IBOutlet weak var secondHeight: NSLayoutConstraint!
    @IBOutlet weak var firstTableView: UITableView!
    @IBOutlet weak var secondTableView: UITableView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    var characters: newResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillLayoutSubviews() {
            super.updateViewConstraints()
            DispatchQueue.main.async {
              
            }
        }
    private func setupUI() {
        self.firstTableView.tableFooterView = UIView()
        self.secondTableView.tableFooterView = UIView()
        configure(with: characters!)
        firstTableView.delegate = self
        firstTableView.dataSource = self
        secondTableView.delegate = self
        secondTableView.dataSource = self
    }
    
    func configure(with character: newResult) {
        characterName.text = "name: \(character.name!)"
                if let thumbnailUrlString = character.thumbnail?.path,
                   let thumbnailExtension = character.thumbnail?.thumbnailExtension,
                   let thumbnailUrl = URL(string: thumbnailUrlString + "." + thumbnailExtension.rawValue) {
                    characterImage.kf.setImage(with: thumbnailUrl)
                    
            }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.firstTableView {
            return (self.characters?.series?.items?.count)!
        }else {
            return (self.characters?.stories?.items?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.firstTableView {
            let cell = self.firstTableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as! FirstTableViewCell
            cell.seriesNameLabel.text = characters?.series?.items![indexPath.row].name
            return cell
        } else {
            let cell = self.secondTableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as! SecondTableViewCell
            cell.storiesNameLabel.text = characters?.stories?.items![indexPath.row].name
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    

}

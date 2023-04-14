//
//  FavoriteViewController.swift
//  MarvelCharactersApp
//
//  Created by Emircan saglam on 14.04.2023.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate {
    
    var favoriteCharacters: [newResult] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
            if let savedData = UserDefaults.standard.data(forKey: "favorites") {
                do {
                    let decoder = JSONDecoder()
                    let characters = try decoder.decode([newResult].self, from: savedData)
                    favoriteCharacters = characters
                    print("geldi")
                } catch {
                    print("Error decoding saved character data: \(error)")
                }
            }
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoriteCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    // MARK: - UI
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Favorites"
    }
    
    // MARK: - UITableViewDataSource
    
}

extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        
        let character = favoriteCharacters[indexPath.row]
        
        cell.favoriteName.text = character.name
        
        cell.favoriteSession.text = "\((character.series?.available)!)"
        
        return cell
    }
}

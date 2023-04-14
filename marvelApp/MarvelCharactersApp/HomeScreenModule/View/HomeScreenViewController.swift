//
//  ViewController.swift
//  MarvelCharactersApp
//
//  Created by Emircan Sağlam on 13.04.2023.
//

import UIKit
import Kingfisher
import CoreData
class HomeScreenViewController: UIViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = HomeScreenViewModel()
    var isLoading = false
    var favoriteStatus = [Int: Bool]()
    var character: newResult?
    var characters: [newResult]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "HomeScreenTableViewCell", bundle: nil), forCellReuseIdentifier: "cellHomeScrenn")
        setupTableView()
        loadData()
        searchBar.delegate = self
        self.tabBarController?.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToDetail" {
                //as ile casting
                let destination = segue.destination as! DetailViewController
                destination.characters = character
            }
        
    }
   
    
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
            guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else {
                return
            }
            
            // toggle the isSelected property
            sender.isSelected.toggle()
            
            // update the favorite status dictionary
            favoriteStatus[indexPath.row] = sender.isSelected
            
            // update UserDefaults
            let defaults = UserDefaults.standard
            let key = "favorite_\(indexPath.row)"
            defaults.set(sender.isSelected, forKey: key)
            
            // set the title to an empty string to hide the text
            sender.setTitle("", for: .normal)
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let thumbnailExtension = NSString(string: "\(characters![indexPath.row].thumbnail?.thumbnailExtension!)")

        
        let newFavorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context)
        newFavorite.setValue(characters![indexPath.row].name!, forKey: "name")
        newFavorite.setValue(characters![indexPath.row].series?.available!, forKey: "series")
        newFavorite.setValue(characters![indexPath.row].thumbnail?.path!, forKey: "path")
        newFavorite.setValue(thumbnailExtension, forKey: "thumbnail")
        
        do {
            try context.save()
            print("success")
        } catch {
            print("coreDataError")
        }
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let favoriteViewController = viewController as? FavoriteViewController {
            
        }
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
         
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.center = footerView.center
        footerView.addSubview(activityIndicatorView)
        tableView.tableFooterView = footerView
    }
    
    private func loadData() {
        viewModel.fetchCharacters()
        viewModel.didUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            viewModel.loadMoreCharacters()
        }
    }
    
}

extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filtered = viewModel.filteredCharacters(for: searchBar.text ?? "") else {
            return 0
        }
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHomeScrenn", for: indexPath) as! HomeScreenTableViewCell
        guard let filtered = viewModel.filteredCharacters(for: searchBar.text ?? ""),
              indexPath.row < filtered.count else {
            return cell
        }
        self.characters = viewModel.characters
        let character = filtered[indexPath.row]
        cell.configure(with: character)
        if let favorite = favoriteStatus[indexPath.row] {
                cell.favoriteButton.isSelected = favorite
            } else {
                // if the favorite status is not in the dictionary, set the default value from UserDefaults
                let defaults = UserDefaults.standard
                let key = "favorite_\(indexPath.row)"
                cell.favoriteButton.isSelected = defaults.bool(forKey: key)
            }
        
        cell.favoriteButton.tag = indexPath.row // tag olarak indexPath.row kullanarak her bir hücrenin sıra numarasını butona atıyoruz
        cell.setFavoriteButtonAction(action: #selector(favoriteButtonTapped), target: self)
        cell.seriesLabel.text = "Series: \((character.series?.available)!)"
        cell.nameLabel.text = character.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let filtered = viewModel.filteredCharacters(for: searchBar.text ?? ""),
              indexPath.row == filtered.count - 1 && !isLoading else {
            return
        }
        isLoading = true
        viewModel.loadMoreCharacters()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        character = viewModel.characters![indexPath.row]
        performSegue(withIdentifier: "goToDetail", sender: nil)
        
        
        guard let filtered = viewModel.filteredCharacters(for: searchBar.text ?? ""),
              indexPath.row < filtered.count else {
            return
        }
        
    }
}

extension HomeScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteredCharacters(for: searchText)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
    
    




//
//  ViewController.swift
//  MarvelCharactersApp
//
//  Created by Emircan Sağlam on 13.04.2023.
//

import UIKit
import Kingfisher

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = HomeScreenViewModel()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "HomeScreenTableViewCell", bundle: nil), forCellReuseIdentifier: "cellHomeScrenn")
        setupTableView()
        loadData()
        searchBar.delegate = self
    }
    
    @objc func handleFavoriteButtonTap(_ sender: UIButton) {
        let character = viewModel.characters![sender.tag]
        let defaults = UserDefaults.standard
        var favorites = defaults.array(forKey: "favorites") as? [Int] ?? [] // favorileri tutmak için bir dizi oluşturuyoruz veya mevcut bir diziyi alıyoruz
        
        if !favorites.contains(character.id!) { // character id'si favorilerde yoksa ekliyoruz
            favorites.append(character.id!)
            defaults.set(favorites, forKey: "favorites")
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
        let character = filtered[indexPath.row]
        cell.configure(with: character)
        
        cell.favoriteButton.tag = indexPath.row // tag olarak indexPath.row kullanarak her bir hücrenin sıra numarasını butona atıyoruz
        cell.favoriteButton.addTarget(self, action: #selector(handleFavoriteButtonTap(_:)), for: .touchUpInside)
        
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
        guard let filtered = viewModel.filteredCharacters(for: searchBar.text ?? ""),
              indexPath.row < filtered.count else {
            return
        }
        let character = filtered[indexPath.row]
        // character'a tıklandığında yapılacak işlemler
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
    
    




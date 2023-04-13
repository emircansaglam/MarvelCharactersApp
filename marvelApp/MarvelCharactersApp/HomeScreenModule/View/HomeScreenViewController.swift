//
//  ViewController.swift
//  MarvelCharactersApp
//
//  Created by Emircan Sağlam on 13.04.2023.
//

import UIKit
import Kingfisher

class HomeScreenViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    let viewModel = HomeScreenViewModel()
    
    var isLoading = false
    
    override func viewDidLoad() {
         super.viewDidLoad()
         setupTableView()
         loadData()
        
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
         guard let strongSelf = self else { return }
            if let characters = strongSelf.viewModel.characters {
                     DispatchQueue.main.async {
                         strongSelf.tableView.reloadData()
                     }
                 }
             }
         }
 }

 extension HomeScreenViewController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel.characters?.count ?? 0
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CharactersTableViewCell
         let character = viewModel.characters![indexPath.row]
         
         cell.nameLabel.text = character.name
         cell.configure(with: character)
         return cell
     }
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         if indexPath.row == viewModel.characters!.count - 1 && !isLoading {
             isLoading = true
             viewModel.loadMoreCharacters()
             
         }
     }
 }

 extension HomeScreenViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let character = viewModel.characters![indexPath.row]
         // character'a tıklandığında yapılacak işlemler
     }
 }
   
    
    
    




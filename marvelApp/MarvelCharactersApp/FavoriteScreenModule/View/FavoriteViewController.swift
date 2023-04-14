//
//  FavoriteViewController.swift
//  MarvelCharactersApp
//
//  Created by Emircan saglam on 14.04.2023.
//

import UIKit
import CoreData
import Kingfisher

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var nameArray : [String] = []
    var pathArray : [String] = []
    var thumbnail : [String] = []
    var series: [Int] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoriteCell")
        tableView.dataSource = self
        tableView.delegate = self
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.center = footerView.center
        footerView.addSubview(activityIndicatorView)
        tableView.tableFooterView = footerView
    }
    
    func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String {
                    self.nameArray.append(name)
                }
                if let path = result.value(forKey: "path") as? String {
                    self.pathArray.append(path)
                }
                if let thumbnail = result.value(forKey: "thumbnail") as? String {
                    self.thumbnail.append(thumbnail)
                }
                if let series = result.value(forKey: "series") as? Int {
                    self.series.append(series)
                }
                self.tableView.reloadData()
            }
            
        } catch {
            
        }
        
    }
    // MARK: - UI
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Favorites"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        
        cell.favoriteName.text = nameArray[indexPath.row]
        var image = URL(string: "\(pathArray[indexPath.row]).jpg")
        print("\(pathArray[indexPath.row]).jpg")
        cell.favoriteImage.kf.setImage(with: image)
        cell.favoriteSession.text = "\(series[indexPath.row])"

        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
}



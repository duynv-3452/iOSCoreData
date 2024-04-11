//
//  FavoriteVC.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import UIKit
import CoreData

final class FavoriteVC: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource = [FavoriteFollower]() {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        prepareDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewFavoriteFollower(_:)), name: Notification.Name("NewFavoriteFollowerAdded"), object: nil)
    }
    
    private func configView() {
        title = "Favorites"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
    }
    
    @objc private func handleNewFavoriteFollower(_ notification: Notification) {
        prepareDataSource()
    }
    
    private func prepareDataSource() {
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
         
         let fetchRequest: NSFetchRequest<FavoriteFollower> = FavoriteFollower.fetchRequest()
         
         do {
             dataSource = try context.fetch(fetchRequest)
         } catch {
             print("Error fetching favorite followers: \(error)")
         }
     }
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        cell.configCell(follower: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.deleteFavoriteFollower(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FollowersVC()
        vc.username = dataSource[indexPath.row].login
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavoriteVC {
    func deleteFavoriteFollower(at indexPath: IndexPath) {
        let favoriteFollowerToDelete = dataSource[indexPath.row]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(favoriteFollowerToDelete)
        
        do {
            try context.save()
        } catch {
            print("Error saving context after deleting favorite follower: \(error)")
        }
        
        dataSource.remove(at: indexPath.row)
        tableView.reloadData()
    }
}

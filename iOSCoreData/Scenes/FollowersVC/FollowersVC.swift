//
//  FollowersVC.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import UIKit
import CoreData

final class FollowersVC: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource = [Follower]() {
        didSet {
            collectionView.reloadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var username: String?
    var loadMore = false
    var hasMoreFollowers = true
    var page: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        getFollowers(username: username ?? "", page: page)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addFavorited))
    }
    
    private func configView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (Constants.WIDTH_SCREEN - 60) / 3, height: 140)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FollowerCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "FollowerCollectionViewCell")
    }
    
    @objc
    private func addFavorited() {
        APICaller.shared.getUserInfo(username: username ??  "") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.addUserForFavorites(user: user)
            case .failure(let error):
                DispatchQueue.main.async {
                    let vc = AlertVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.titleText = "Error"
                    vc.subTitleText = error.rawValue
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    private func addUserForFavorites(user: User) {
        let fetchRequest: NSFetchRequest<FavoriteFollower> = FavoriteFollower.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", user.login ?? "")
        
        do {
            let existingFollowers = try context.fetch(fetchRequest)
            
            if let existingFollower = existingFollowers.first {
                DispatchQueue.main.async {
                    let vc = AlertVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.titleText = "Error"
                    vc.subTitleText = "\(existingFollower.login ?? "") is already in favorites"
                    self.present(vc, animated: true)
                }
            } else {
                let newFollower = FavoriteFollower(context: context)
                newFollower.login = user.login
                newFollower.avatarUrl = user.avatarUrl
                
                try context.save()
                
                DispatchQueue.main.async {
                    let vc = AlertVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.titleText = "Successful"
                    vc.subTitleText = "You have successfully favorited \(user.login ?? "")"
                    self.present(vc, animated: true)
                    NotificationCenter.default.post(name: Notification.Name("NewFavoriteFollowerAdded"), object: nil)
                }
            }
        } catch {
            print("Error fetching existing follower: \(error)")
        }
    }
    
    private func getFollowers(username: String, page: Int) {
        loadMore = true
        APICaller.shared.getFollower(username: username, page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let followers):
                DispatchQueue.main.async {
                    self.updateUI(followers: followers)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let vc = AlertVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    vc.titleText = "Error"
                    vc.subTitleText = error.rawValue
                    self.present(vc, animated: true)
                }
            }
            self.loadMore = false
        }
    }
    
    private func updateUI(followers : [Follower]) {
        if followers.count < 100 {
            self.hasMoreFollowers = false
        }
        self.dataSource.append(contentsOf: followers)
        if self.dataSource.isEmpty {
            
        }
    }
}

extension FollowersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowerCollectionViewCell", for: indexPath) as? FollowerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configCell(follower: dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UserInfoVC()
        vc.delegate = self
        vc.username = dataSource[indexPath.row].login
        present(vc, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY >= contentHeight - height {
            guard hasMoreFollowers, !loadMore else {
                return
            }
            page += 1
            getFollowers(username: username ?? "", page: page)
        }
    }
}

extension FollowersVC: UserInfoVCDelegate {
    func didRequestFollowers(username: String) {
        self.username = username
        self.page = 1
        self.title = username
        self.dataSource.removeAll()
        self.getFollowers(username: username, page: page)
    }
}

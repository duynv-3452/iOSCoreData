//
//  UserInfoVC.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(username: String)
}
final class UserInfoVC: UIViewController {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var bioLabel: UILabel!
    @IBOutlet private weak var githubStackView: UIStackView!
    @IBOutlet private weak var followersStackView: UIStackView!
    @IBOutlet private weak var getProfileButton: UIButton!
    @IBOutlet private weak var getFollowersButton: UIButton!
    @IBOutlet private weak var publicReposLabel: UILabel!
    @IBOutlet private weak var publicGistsLabel: UILabel!
    @IBOutlet private weak var totalFollowersLabel: UILabel!
    @IBOutlet private weak var totalFollowingLabel: UILabel!
    
    weak var delegate: UserInfoVCDelegate!
    var username: String?
    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        getUserInfo()
    }
    
    private func configView() {
        avatarImageView.layer.cornerRadius = 12
        getProfileButton.layer.cornerRadius = 12
        getFollowersButton.layer.cornerRadius = 12
        githubStackView.layer.cornerRadius = 16
        followersStackView.layer.cornerRadius = 16
    }
    
    private func getUserInfo() {
        APICaller.shared.getUserInfo(username: username ?? "") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.updateUI(user: user)
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
        }
    }
    
    private func updateUI(user: User) {
        self.user = user
        downloadImage(url: user.avatarUrl ?? "")
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "No location"
        bioLabel.text = user.bio ?? ""
        bioLabel.numberOfLines = 3
        publicReposLabel.text = "\(user.publicRepos ?? 0)"
        publicGistsLabel.text = "\(user.publicGists ?? 0)"
        totalFollowersLabel.text = "\(user.followers ?? 0)"
        totalFollowingLabel.text = "\(user.following ?? 0)"
    }
    
    func downloadImage(url: String) {
        APICaller.shared.downloadImage(urlString: url) { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
    
    @IBAction func tappedGithubProfile(_ sender: Any) {
        guard let url = URL(string: user?.htmlUrl ?? "") else {
            return
        }
        presentSafariVC(with: url)
    }
    
    
    @IBAction func tappedGetFollowers(_ sender: Any) {
        guard user?.followers != 0 else {
   
            return
        }
        delegate.didRequestFollowers(username: user?.login ?? "")
        self.dismiss(animated: true)
    }
}

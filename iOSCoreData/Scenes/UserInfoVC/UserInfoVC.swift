//
//  UserInfoVC.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import UIKit

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
    
    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        getUserInfo()
    }
    
    private func configView() {
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
        downloadImage(url: user.avatarUrl ?? "")
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationLabel.text = user.location ?? "No location"
        bioLabel.text = user.bio ?? ""
        bioLabel.numberOfLines = 3
    }
    
    func downloadImage(url: String) {
        APICaller.shared.downloadImage(urlString: url) { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
}

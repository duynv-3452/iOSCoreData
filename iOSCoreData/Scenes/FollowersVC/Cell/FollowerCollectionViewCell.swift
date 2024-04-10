//
//  FollowerCollectionViewCell.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import UIKit

final class FollowerCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        avatarImageView.layer.cornerRadius = 12
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    func configCell(follower: Follower) {
        downloadImage(url: follower.avatarUrl ?? "")
        usernameLabel.text = follower.login
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

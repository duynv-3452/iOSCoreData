//
//  FavoriteCell.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/10/24.
//

import UIKit

final class FavoriteCell: UITableViewCell {

    @IBOutlet private weak var avaterImage: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        avaterImage.layer.cornerRadius = 12
        avaterImage.layer.borderWidth = 1
        avaterImage.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    func configCell(follower: FavoriteFollower) {
        downloadImage(url: follower.avatarUrl ?? "")
        usernameLabel.text = follower.login
    }
    
    func downloadImage(url: String) {
        APICaller.shared.downloadImage(urlString: url) { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async {
                self.avaterImage.image = image
            }
        }
    }
}

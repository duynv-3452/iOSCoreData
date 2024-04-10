//
//  FavoriteCell.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/10/24.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var avaterImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        
    }
    
    func configCell(follower: Follower) {
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

//
//  AlertVC.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/10/24.
//

import UIKit

class AlertVC: UIViewController {

    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self else { return }
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = .black.withAlphaComponent(0.6)
            }
        }
        subTitleLabel.text = "Please enter a user name. We need to know who to look for \n😡😏🥹"
        errorView.layer.cornerRadius = 24
        errorView.addShadow()
        okButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func tappedOkButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

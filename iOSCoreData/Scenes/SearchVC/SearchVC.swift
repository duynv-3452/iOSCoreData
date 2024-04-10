//
//  SearchVC.swift
//  iOSCoreData
//
//  Created by nguyen.van.duyb on 4/9/24.
//

import UIKit

final class SearchVC: UIViewController {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var getFollowersButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
    }
    
    private func configView() {
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.borderWidth = 2
        usernameTextField.layer.borderColor = UIColor.systemGray4.cgColor  
        getFollowersButton.layer.cornerRadius = 10
        usernameTextField.delegate = self
    }
    
    private func pushToFollowersVC() {
        guard let username = usernameTextField.text, !username.isEmpty else {
            let vc = AlertVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.titleText = "Enter a username"
            vc.subTitleText = "Please enter a user name. We need to know who to look for \n😡😏🥹"
            present(vc, animated: true)
            return
        }
        usernameTextField.resignFirstResponder()
        let vc = FollowersVC()
        vc.username = usernameTextField.text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tappedGetFollowers(_ sender: Any) {
        pushToFollowersVC()
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushToFollowersVC()
        return true
    }
}

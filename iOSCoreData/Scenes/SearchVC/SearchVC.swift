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
    
    private func configView() {
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.borderWidth = 2
        usernameTextField.layer.borderColor = UIColor.systemGray4.cgColor  
        usernameTextField.delegate = self
    }
    
    @IBAction func tappedGetFollowers(_ sender: Any) {
        
        
    }
}

extension SearchVC: UITextFieldDelegate {
    
}

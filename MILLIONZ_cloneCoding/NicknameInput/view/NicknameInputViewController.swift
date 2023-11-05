//
//  NicknameInputViewController.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/05.
//

import UIKit

class NicknameInputViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func viewTapGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
    

}

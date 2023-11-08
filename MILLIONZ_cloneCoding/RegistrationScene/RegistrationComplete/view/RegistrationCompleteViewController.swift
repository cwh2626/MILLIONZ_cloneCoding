//
//  RegistrationCompleteViewController.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/07.
//

import UIKit

class RegistrationCompleteViewController: UIViewController {
    var registrationData: RegistrationResponse!
    
    @IBOutlet weak var logoutButtonContainer: ActionBottomButton!
    
    @IBOutlet weak var userProfileContanierView: UserProfileCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButtonContainer.actionButton.addTarget(self, action: #selector(self.logoutButtonTapped), for: .touchUpInside)
        
        userProfileContanierView.prepare(data: registrationData)
        
    }
    
    private func bindViewModel() {
        
    }
    @objc func logoutButtonTapped(_ sender: UIButton) {
        // 스토리보드에서 네비게이션 컨트롤러 인스턴스화
        guard let navigationController = storyboard?.instantiateViewController(withIdentifier: "RegistrationNavigationController") as? UINavigationController,

              let window = view.window, let sceneDelegate = window.windowScene?.delegate as? SceneDelegate else {
            return
        }
        
        sceneDelegate.window?.rootViewController = navigationController
        sceneDelegate.window?.makeKeyAndVisible()
        
    }

}

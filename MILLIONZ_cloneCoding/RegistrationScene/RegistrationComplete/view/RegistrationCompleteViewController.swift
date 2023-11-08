//
//  RegistrationCompleteViewController.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/07.
//

import UIKit

class RegistrationCompleteViewController: UIViewController {
    // MARK: - Properties
    var registrationData: RegistrationResponse?
    
    // MARK: - UI Components
    @IBOutlet weak var logoutButtonContainer: ActionBottomButton!
    @IBOutlet weak var userProfileContanierView: UserProfileCard!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButtonContainer.actionButton.addTarget(self, action: #selector(self.logoutButtonTapped), for: .touchUpInside)
        guard let viewData = registrationData else { return }
        userProfileContanierView.prepare(data: viewData)
    }
    
    // MARK: - Action Methods
    @objc func logoutButtonTapped(_ sender: UIButton) {
        guard let navigationController = storyboard?.instantiateViewController(withIdentifier: StoryBoardIdentifier.registrationNavigationId) as? UINavigationController,
              let window = view.window, let sceneDelegate = window.windowScene?.delegate as? SceneDelegate else {
            return
        }
        
        sceneDelegate.window?.rootViewController = navigationController
        sceneDelegate.window?.makeKeyAndVisible()
    }

}

//
//  NicknameInputViewController.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/05.
//

import UIKit
import RxSwift
import RxCocoa

class NicknameInputViewController: UIViewController {
    // MARK: - Properties
    var viewModel: SharedRegistrationViewModel!
    private var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    @IBOutlet weak var nicknameInputBar: TextInputBar!
    @IBOutlet weak var nextButtonContainer: ActionBottomButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButtonContainer.actionButton.addTarget(self,
                                                   action: #selector(self.nextButtonTapped),
                                                   for: .touchUpInside)
        bindViewModel()
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        nicknameInputBar.inputTextField.rx.text.orEmpty
            .bind { [weak viewModel] nickname in
                viewModel?.updateNickname(nickname)
            }
            .disposed(by: disposeBag)
        
        viewModel.isNextButtonEnabled
            .drive(nextButtonContainer.actionButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action Methods
    @IBAction func viewTapGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        performSegue(withIdentifier: SegueIdentifier.toCharacterSelection, sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifier.toCharacterSelection:
            if let destinationVC = segue.destination as? CharacterSelectionViewController {
                destinationVC.viewModel = self.viewModel
            }
        default:
            break
        }
    }
}

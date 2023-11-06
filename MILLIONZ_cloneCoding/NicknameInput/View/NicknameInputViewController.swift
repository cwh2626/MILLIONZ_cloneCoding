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

    
    @IBOutlet weak var nicknameInputBar: TextInputBar!
    @IBOutlet weak var nextButtonContainer: ActionBottomButton!
    var viewModel: SharedRegistrationViewModel!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButtonContainer.actionButton.addTarget(self, action: #selector(self.nextButtonTapped), for: .touchUpInside)

    }
    
    private func bindViewModel() {
        // 텍스트 필드 입력값을 ViewModel에 바인드
        nicknameInputBar.inputTextField.rx.text.orEmpty
            .bind(to: viewModel.nicknameSubject)
            .disposed(by: disposeBag)
        
        // ViewModel의 버튼 활성화 상태를 버튼에 바인드
        viewModel.isNextButtonEnabled
            .drive(nextButtonContainer.actionButton.rx.isEnabled) // UI 요소에는 drive를 사용
            .disposed(by: disposeBag)
    }
    
    @IBAction func viewTapGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.toCharacterSelection, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.toCharacterSelection {
            if let destinationVC = segue.destination as? CharacterSelectionViewController {
                // 필요한 데이터를 destinationVC에 전달
//                destinationVC.someProperty = "Some Value"
            }
        }
    }


}

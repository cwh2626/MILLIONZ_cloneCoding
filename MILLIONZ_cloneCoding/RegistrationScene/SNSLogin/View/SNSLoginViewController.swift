//
//  SNSLoginViewController.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/03.
//

import UIKit
import SnapKit
import RxSwift

class SNSLoginViewController: UIViewController {
    // MARK: - Properties
    var viewModel: SharedRegistrationViewModel!
    private let disposeBag = DisposeBag()
    private var buttonSNSTypePairs: [(UIButton, SnsType)] = []
    
    // MARK: - UI Components
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var naverButton: UIButton!
    @IBOutlet weak var kakaoButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SharedRegistrationViewModel(characterService: RegistrationService())
        
        buttonSNSTypePairs = [
            (appleButton, .apple),
            (googleButton, .google),
            (naverButton, .naver),
            (kakaoButton, .kakao)
        ]
        
        if let rawValue = UserDefaults.standard.object(forKey: UserDefaultsKeys.registeredSNSType) as? Int,
           let registeredSNSType = SnsType(rawValue: rawValue) {
            if let button = buttonSNSTypePairs.first(where: { $0.1 == registeredSNSType })?.0 {
                setupPreviousSNSTypeAlertView(targetButton: button)
            }
        }
        
        bindViewModel()
    }
    
    // MARK: - ViewModel Binding
    private func bindViewModel() {
        buttonSNSTypePairs.forEach { button, snsType in
            button.rx.tap
                .bind { [weak viewModel] in
                    viewModel?.selectSnsType(snsType)
                }
                .disposed(by: disposeBag)
        }
        
        viewModel.selectedSNSTypeObservable
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] snsType in
                self?.performSegue(withIdentifier: SegueIdentifier.toNicknameInput, sender: self)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifier.toNicknameInput:
            if let destinationVC = segue.destination as? NicknameInputViewController {
                destinationVC.viewModel = self.viewModel
            }
        default:
            break
        }
    }
    
    // MARK: - Utility Methods
    private func setupPreviousSNSTypeAlertView(targetButton: UIButton) {
        let nib = UINib(nibName: PreviousSNSTypeAlertView.id, bundle: nil)
        guard let alertView = nib.instantiate(withOwner: self, options: nil).first as? PreviousSNSTypeAlertView else {
            return
        }        
        self.view.addSubview(alertView)
        alertView.setupConstraints(targetComponent: targetButton)
    }
    
}


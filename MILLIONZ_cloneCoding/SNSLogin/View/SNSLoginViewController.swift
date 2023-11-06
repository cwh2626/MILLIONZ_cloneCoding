//
//  ViewController.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/03.
//

import UIKit
import SnapKit
import RxSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var naverButton: UIButton!
    @IBOutlet weak var kakaoButton: UIButton!
    
    private var previousSNSTypeAlertView: PreviousSNSTypeAlertView!
    private var viewModel: SharedRegistrationViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SharedRegistrationViewModel()
        let nib = UINib(nibName: PreviousSNSTypeAlertView.id, bundle: nil)
        previousSNSTypeAlertView = nib.instantiate(withOwner: self, options: nil).first as? PreviousSNSTypeAlertView
        
        self.view.addSubview(previousSNSTypeAlertView)

        
        setupConstraints()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NicknameInputViewController {
            destinationVC.viewModel = self.viewModel
        }
    }
    
    private func bindViewModel() {
        
    }

    
    private func setupConstraints() {
        previousSNSTypeAlertView.snp.makeConstraints {
//            $0.width.equalTo(104)
//            $0.height.equalTo(65)
            $0.top.equalTo(buttonStackView.snp.bottom).offset(8)
            $0.centerX.equalTo(kakaoButton.snp.centerX)
        }
    }
}


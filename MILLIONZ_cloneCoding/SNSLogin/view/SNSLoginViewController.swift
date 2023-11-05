//
//  ViewController.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/03.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var naverButton: UIButton!
    @IBOutlet weak var kakaoButton: UIButton!
    
    private var previousSNSTypeAlertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "PreviousSNSTypeAlertView", bundle: nil)
        previousSNSTypeAlertView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.view.addSubview(previousSNSTypeAlertView)

        
        setupConstraints()
    }
    
    private func setupConstraints() {
        previousSNSTypeAlertView.snp.makeConstraints {
            $0.width.equalTo(104)
            $0.height.equalTo(65)
            $0.top.equalTo(buttonStackView.snp.bottom).offset(8)
            $0.centerX.equalTo(kakaoButton.snp.centerX)
        }
    }


}


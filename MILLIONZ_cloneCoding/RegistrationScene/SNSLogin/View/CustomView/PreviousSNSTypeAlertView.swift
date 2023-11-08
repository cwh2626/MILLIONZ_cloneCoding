//
//  PreviousSNSTypeAlertView.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import UIKit
import SnapKit

class PreviousSNSTypeAlertView: UIView {
    // MARK: - Properties
    static let id = String(describing: PreviousSNSTypeAlertView.self)
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Interface Setup
    func setupConstraints(targetComponent: UIView) {
        self.snp.makeConstraints {
            $0.width.equalTo(104)
            $0.height.equalTo(65)
            $0.top.equalTo(targetComponent.snp.bottom).offset(8)
            $0.centerX.equalTo(targetComponent.snp.centerX)
        }
    }
}

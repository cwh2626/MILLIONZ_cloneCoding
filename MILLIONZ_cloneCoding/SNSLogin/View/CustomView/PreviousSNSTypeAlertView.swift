//
//  PreviousSNSTypeAlertView.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import UIKit
import SnapKit

class PreviousSNSTypeAlertView: UIView {
    static let id = String(describing: PreviousSNSTypeAlertView.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
    }
    
    func setupConstraints() {
        self.snp.makeConstraints {
            $0.width.equalTo(104)
            $0.height.equalTo(65)
        }
    }
}

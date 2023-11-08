//
//  SnsType.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/07.
//

enum SnsType: Int {
    case apple = 1
    case google
    case naver
    case kakao

    var stringValue: String {
        switch self {
        case .apple:
            return "APPLE"
        case .google:
            return "GOOGLE"
        case .naver:
            return "NAVER"
        case .kakao:
            return "KAKAO"
        }
    }
    
    init?(krValue: String) {
        switch krValue {
        case "애플":
            self = .apple
        case "구글":
            self = .google
        case "네이버":
            self = .naver
        case "카카오":
            self = .kakao
        default:
            return nil
        }
    }
}

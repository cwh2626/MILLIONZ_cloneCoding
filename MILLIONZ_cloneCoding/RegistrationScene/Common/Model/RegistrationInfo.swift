//
//  RegistrationInfo.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/08.
//

protocol RegistrationData {
    var snsType: String { get }
    var nickname: String { get }
    var character: Int64 { get }
}

struct RegistrationRequest: Codable, RegistrationData {
    var snsType: String
    var nickname: String
    var character: Int64
}

struct RegistrationResponse: Codable, RegistrationData {
    var snsType: String
    var nickname: String
    var character: Int64
    var characterName: String
}

struct ApiResponse<T: Codable>: Codable {
    let result: Bool
    let message: String
    let error: ErrorDetail?
    let data: T
    
    struct ErrorDetail: Codable {
        let code: String
        let viewType: String
        let message: String
    }
}




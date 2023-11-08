//
//  RegistrationInfo.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/08.
//

struct ApiResponse: Decodable {
    let result: Bool
    let message: String
    let error: ErrorDetail?
    let data: Decodable?
    
    private enum CodingKeys: String, CodingKey {
        case result, message, error, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decode(Bool.self, forKey: .result)
        message = try container.decode(String.self, forKey: .message)
        error = try container.decodeIfPresent(ErrorDetail.self, forKey: .error)
        
        if let dataString = try? container.decode(String.self, forKey: .data) {
            data = dataString
        } else if let dataObject = try? container.decode([Character].self, forKey: .data) {
            data = dataObject
        } else if let dataObject = try? container.decode(RegistrationResponse.self, forKey: .data) {
            data = dataObject
        }  else {
            data = nil
        }
    }
}

struct RegistrationRequest: Encodable {
    var snsType: String
    var nickname: String
    var character: Int64
}

struct RegistrationResponse: Decodable {
    var snsType: String
    var nickname: String
    var character: Int64
    var characterName: String
}

struct ErrorDetail: Codable {
    let code: String
    let viewType: String
    let message: String
}

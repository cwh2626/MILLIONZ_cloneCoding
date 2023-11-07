//
//  Environment.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/07.
//

import Foundation

public enum Environment {
    
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let apiToken = "API_TOKEN"
            static let apiUrl = "API_URL"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let apiToken: String = {
        guard let token = Environment.infoDictionary[Keys.Plist.apiToken] as? String else {
            fatalError("API TOKEN 키가 이 환경을 위한 plist에 설정되지 않았습니다.")
        }
        return token
    }()
    
    static let apiUrl: String = {
        guard let url = Environment.infoDictionary[Keys.Plist.apiUrl] as? String else {
            fatalError("API URL 키가 이 환경을 위한 plist에 설정되지 않았습니다.")
        }
        return url
    }()
    
    static func debugPrint_START(fileID: String = #fileID, function: String = #function, line: Int = #line) {
        #if DEBUG
        print("<== \(fileID) - \(function) - LINE:\(line) - START ==>")
        #endif
    }
    static func debugPrint_END(fileID: String = #fileID, function: String = #function, line: Int = #line) {
        #if DEBUG
        print("<== \(fileID) - \(function) - LINE:\(line) - END ==>")
        #endif
    }
}


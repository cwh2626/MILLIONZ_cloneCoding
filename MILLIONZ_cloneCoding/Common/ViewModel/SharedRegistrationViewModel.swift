//
//  SharedRegistrationViewModel.swift
//  MILLIONZ_cloneCoding
//
//  Created by 조웅희 on 2023/11/06.
//

import Foundation
import RxSwift
import RxCocoa

class SharedRegistrationViewModel {
    
    // MARK: - Input
    // 사용자의 입력을 BehaviorSubject로 관리합니다.
//    let snsType = BehaviorSubject<String?>(value: nil)
//    let nickname = BehaviorRelay<String?>(value: nil)
//    let character = BehaviorSubject<String?>(value: nil)
//    let characterName = BehaviorSubject<String?>(value: nil)
    // 입력 데이터 관찰
    let nicknameSubject = PublishSubject<String>()
    // 버튼 활성화 상태를 Driver로 변환
    var isNextButtonEnabled: Driver<Bool>!
    
    private let disposeBag = DisposeBag()

    init() {
        // Driver를 생성하여 메인 스레드에서만 작동하고 에러를 방출하지 않도록 설정
        isNextButtonEnabled = nicknameSubject
            .asObservable()
            .map { [weak self] in self!.isValidNickname($0) }
            .asDriver(onErrorJustReturn: false) // 에러 발생 시 기본값으로 false 반환
        
        setupBindings()
    }
    
    private func setupBindings() {
        
    }
    
    // MARK: - Validation
    // 입력된 데이터의 유효성을 검증합니다.
//    var isNicknameValid: Observable<Bool> {
//        return nickname
//            .map { $0?.count ?? 0 >= 2 && $0?.count ?? 0 <= 12 } // 2~12자 조건 검증
//            .share(replay: 1, scope: .whileConnected)
//    }
    
    // 입력한 닉네임이 조건에 맞는지 검증
    private func isValidNickname(_ nickname: String) -> Bool {
        let regex = "^[가-힣A-Za-z0-9]{2,12}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
    }

    // MARK: - Registration
    // 모든 데이터가 유효할 때 서버에 전송할 수 있는지 여부를 Observable로 제공합니다.
//    var canRegister: Observable<Bool> {
//        return Observable.combineLatest(
//            snsType,
//            nickname,
//            character,
//            characterName
//        ) { snsType, nickname, character, characterName in
//            // 모든 데이터가 nil이 아니고, 닉네임이 유효해야 합니다.
//            return snsType != nil && nickname != nil && character != nil && characterName != nil
//        }
//    }
    
    // MARK: - Registration Command
    // 회원가입을 수행하는 메서드
//    func register() -> Observable<Bool> {
//        // 이 메서드에서는 서버에 데이터를 전송하는 로직을 구현합니다.
//        // 여기에서는 단순히 Observable을 리턴하는 예시를 보여줍니다.
//        
//        // combineLatest를 사용하여 최신 데이터를 가져옵니다.
//        return Observable.combineLatest(snsType, nickname, character, characterName)
//            .take(1) // 단 한 번만 서버에 전송합니다.
//            .flatMapLatest { snsType, nickname, character, characterName in
//                // 서버에 회원가입 요청을 보내고 결과를 Observable로 변환합니다.
//                // 예: networkService.register(...)
//                return .just(true) // 성공했다고 가정합니다.
//            }
//    }
}


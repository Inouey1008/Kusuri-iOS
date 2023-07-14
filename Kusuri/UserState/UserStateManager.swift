//
//  UserStateManager.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2023/07/13.
//

import Foundation
import RxSwift

enum UserState {
    case onbording
    case configured
}

final class UserStateManager {
    private(set) var  userState: UserState!
    private(set) lazy var onUserStateChanges: Observable<UserState> = subject.asObservable()

    private let subject = PublishSubject<UserState>()
    static let shared = UserStateManager()
    
    private init() {
        updateUserState()
    }
    
    func updateUserState() {
        if Configuration.firstLaunch {
            userState = UserState.onbording
            subject.onNext(userState)
        } else {
            userState = UserState.configured
            subject.onNext(userState)
        }
    }
}

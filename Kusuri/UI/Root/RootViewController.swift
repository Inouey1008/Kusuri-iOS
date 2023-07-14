//
//  RootViewController.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2023/07/11.
//

import UIKit
import RxSwift

final class RootViewController: UIViewController {
    private var currentViewController: UIViewController?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        view.backgroundColor = .backgroundBase
        
        UserStateManager.shared.onUserStateChanges.subscribe(with: self, onNext: { RootViewController, UserState in
            print(#function, UserState)
            
            switch UserState {
            case .onbording:
                RootViewController.showOnbording()
            case .configured:
                RootViewController.showMainTab()
            }
        }).disposed(by: disposeBag)
        
        UserStateManager.shared.updateUserState()
    }
    
    private func showMainTab() {
        let nextViewController = MainTabViewController()
        add(childViewController: nextViewController)
        if let currentViewController = currentViewController {
            remove(childViewController: currentViewController)
        }
        currentViewController = nextViewController
    }
    
    private func showOnbording() {
        let nextViewController = OnboardingViewController()
        add(childViewController: nextViewController)
        if let currentViewController = currentViewController {
            remove(childViewController: currentViewController)
        }
        currentViewController = nextViewController
    }

    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParent: self)
    }

    private func remove(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}

//
//  ProfileImageViewModel.swift
//  OneFit
//
//  Created by Abzal on 22.01.2019.
//  Copyright © 2019 Codebusters. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

protocol ProfileAchievementsViewModelProtocol: MVVMViewModel {
    var shouldUpdateCollectionView: BehaviorRelay<Bool> { get }
    var achievements: [Achievement] { get }

    func openAchievements()
}

class ProfileAchievementsViewModel: ProfileAchievementsViewModelProtocol {
    // MARK: - Properties

    let router: MVVMRouter
    var shouldUpdateCollectionView = BehaviorRelay<Bool>(value: false)
    var achievements: [Achievement] = [] {
        didSet {
            shouldUpdateCollectionView.accept(true)
        }
    }

    // MARK: - Methods

    func openAchievements() {
        let context = ProfileRouter.RouteType.openAchievements
        router.enqueueRoute(with: context)
    }

    // MARK: - Method

    init(router: MVVMRouter, achievements: [Achievement]) {
        self.router = router
        self.achievements = achievements
    }
}

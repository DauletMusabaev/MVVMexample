//
//  SubscriptionDetailsViewModel.swift
//  OneFit
//
//  Created by Abzal on 13.12.2018.
//  Copyright © 2018 Codebusters. All rights reserved.
//

import PromiseKit
import RxCocoa
import RxSwift

protocol ProfileViewModelProtocol: MVVMViewModel {
    var shouldUpdateTableView: BehaviorRelay<Bool> { get }
    var profileImageViewModel: ProfileImageViewModelProtocol! { get }
    var profileStatisticsViewModel: ProfileStatisticsViewModelProtocol! { get }
    var profileAchievementsViewModel: ProfileAchievementsViewModelProtocol! { get }

    func openBonuses()
    func openSettings()
    func downloadUser()
}

class ProfileViewModel: ProfileViewModelProtocol {
    enum CellType: Int {
        case profileImage
        case profileStatistics
        case profileAchievements
    }

    // MARK: - Properties

    var router: MVVMRouter
    var user = UserSessionManager.shared.user {
        didSet {
            guard
                let user = user,
                let statistics = user.statistics
            else { return }

            profileImageViewModel = ProfileImageViewModel(router: router, profileName: user.fullName, imageURL: user.image?.url)
            profileStatisticsViewModel = ProfileStatisticsViewModel(router: router, userStatistics: statistics)
            profileAchievementsViewModel = ProfileAchievementsViewModel(router: router, achievements: statistics.achievements)
            shouldUpdateTableView.accept(true)
        }
    }

    var profileImageViewModel: ProfileImageViewModelProtocol!
    var profileStatisticsViewModel: ProfileStatisticsViewModelProtocol!
    var profileAchievementsViewModel: ProfileAchievementsViewModelProtocol!
    var shouldUpdateTableView = BehaviorRelay<Bool>(value: false)

    // MARK: - Methods

    func openSettings() {
        let context = ProfileRouter.RouteType.openSettings
        router.enqueueRoute(with: context)
    }

    func openBonuses() {
        let context = ProfileRouter.RouteType.bonuses
        router.enqueueRoute(with: context)
    }

    func downloadUser() {
        firstly {
            UserGeneralService.shared.downloadUser()
        }.done { response in
            self.user = response.user
        }.catch { _ in
        }
    }

    // MARK: - Method

    init(router: MVVMRouter) {
        self.router = router
        guard
            let user = user,
            let statistics = user.statistics
        else { return }

        profileImageViewModel = ProfileImageViewModel(router: router, profileName: user.fullName, imageURL: user.image?.url)
        profileStatisticsViewModel = ProfileStatisticsViewModel(router: router, userStatistics: statistics)
        profileAchievementsViewModel = ProfileAchievementsViewModel(router: router, achievements: statistics.achievements)
        shouldUpdateTableView.accept(true)
    }
}

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

protocol ProfileStatisticsViewModelProtocol: MVVMViewModel {
    var userStatistics: BehaviorRelay<UserStatistics> { get }

    func openVisitsHistory()
    func chooseWeeklyChallenge()
}

class ProfileStatisticsViewModel: ProfileStatisticsViewModelProtocol {
    // MARK: - Properties

    let router: MVVMRouter
    var userStatistics: BehaviorRelay<UserStatistics>
    private var weekGoal: Int

    // MARK: - Methods

    func openVisitsHistory() {
        let context = ProfileRouter.RouteType.visitsHistory(totalCount: userStatistics.value.totalVisits)
        router.enqueueRoute(with: context)
    }

    func chooseWeeklyChallenge() {
        let context = ProfileRouter.RouteType.chooseWeeklyChallenge(current: weekGoal) {
            guard let statistics = UserSessionManager.shared.user?.statistics else { return }

            self.userStatistics.accept(statistics)
            self.weekGoal = statistics.weekStats.total
        }
        router.enqueueRoute(with: context)
    }

    // MARK: - Method

    init(router: MVVMRouter, userStatistics: UserStatistics) {
        self.router = router
        self.userStatistics = BehaviorRelay<UserStatistics>(value: userStatistics)
        weekGoal = userStatistics.weekStats.total
    }
}

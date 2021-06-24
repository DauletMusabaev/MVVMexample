//
//  ProfileStatisticsTableViewCell.swift
//  OneFit
//
//  Created by Abzal on 24.01.2019.
//  Copyright © 2019 Codebusters. All rights reserved.
//

import Reusable
import RxSwift
import Spring
import UIKit

class ProfileStatisticsTableViewCell: UITableViewCell, MVVMView, NibReusable {
    private struct Constants {
        static let highlightColor = UIColor(hex: 0xE3E3E3)
    }

    // MARK: - Outlets

    @IBOutlet var sportCentersView: UIView!
    @IBOutlet var totalLabel: AnimatedLabel!
    @IBOutlet var fitnessStatsPieChart: PieChartView!
    @IBOutlet var weekStatsPieChart: PieChartView!
    @IBOutlet var barChartView: BarChartView!
    @IBOutlet var visitsHistoryView: UIView!
    @IBOutlet var weeklyChallengeView: UIView!
    @IBOutlet var emptyWeekGoalView: UIView!
    @IBOutlet var plusSignLabel: SpringLabel!

    // MARK: - Properties

    var viewModel: ProfileStatisticsViewModelProtocol! {
        didSet {
            configureBindings()
            configureGestures()
        }
    }

    private var disposeBag = DisposeBag()

    // MARK: - Configurations

    private func configureBindings() {
        viewModel?.userStatistics.subscribe(onNext: { [weak self] userStatistics in
            guard let `self` = self else { return }

            let duration = TimeInterval(userStatistics.totalVisits / 100)
            self.totalLabel.countFromCurrent(to: Float(userStatistics.totalVisits), duration: duration)

            // fitness statistics
            self.fitnessStatsPieChart.progress = CGFloat(userStatistics.fitnessStats.progress)
            self.fitnessStatsPieChart.setText(mainText: "\(userStatistics.fitnessStats.current)", secondaryText: "/\(userStatistics.fitnessStats.total)")

            // weekly statistics
            self.weekStatsPieChart.progress = CGFloat(userStatistics.weekStats.progress)
            self.weekStatsPieChart.setText(mainText: "\(userStatistics.weekStats.current)", secondaryText: "/\(userStatistics.weekStats.total)")
            if userStatistics.weekStats.total > 0 {
                self.emptyWeekGoalView.alpha = 0
            }

            // bar chart
            self.barChartView.labelTexts = userStatistics.pastWeekChart.dayStatistics.map { $0.name }
            let weeklyChellange = userStatistics.weekStats.total
            self.barChartView.progress = userStatistics.pastWeekChart.dayStatistics.map {
                guard weeklyChellange != 0 else { return -1 }

                return min(Double($0.value) / Double(weeklyChellange), 1)
            }
        }).disposed(by: disposeBag)
    }

    private func configureGestures() {
        configureVisitHistory()
        configureWeeklyChallenge()
        configureSportCentersView()
    }

    private func configureVisitHistory() {
        visitsHistoryView.layer.borderColor = UIColor.softBlueBorder.cgColor
        visitsHistoryView.layer.borderWidth = 1
        visitsHistoryView.layer.cornerRadius = 10
        visitsHistoryView.gestureRecognizers?.removeAll()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openVisitsHistory(_:)))
        gestureRecognizer.delegate = self

        visitsHistoryView.addGestureRecognizer(gestureRecognizer)
    }

    private func configureWeeklyChallenge() {
        weeklyChallengeView.layer.borderColor = UIColor.softBlueBorder.cgColor
        weeklyChallengeView.layer.borderWidth = 1
        weeklyChallengeView.layer.cornerRadius = 10
        weeklyChallengeView.gestureRecognizers?.removeAll()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseWeeklyChallenge(_:)))
        gestureRecognizer.delegate = self

        weeklyChallengeView.addGestureRecognizer(gestureRecognizer)
    }

    private func configureSportCentersView() {
        sportCentersView.layer.masksToBounds = true
        sportCentersView.layer.borderColor = UIColor.softBlueBorder.cgColor
        sportCentersView.layer.borderWidth = 1
        sportCentersView.layer.cornerRadius = 10
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    // MARK: - Actions

    @objc private func openVisitsHistory(_: UITapGestureRecognizer) {
        viewModel.openVisitsHistory()
    }

    @objc private func chooseWeeklyChallenge(_: UITapGestureRecognizer) {
        plusSignLabel.animation = "morph"
        plusSignLabel.animate()
        viewModel.chooseWeeklyChallenge()
    }
}

extension ProfileStatisticsTableViewCell {
    override func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}

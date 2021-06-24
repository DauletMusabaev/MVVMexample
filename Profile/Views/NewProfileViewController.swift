//
//  ProfileViewController.swift
//  OneFit
//
//  Created by Abzal on 21.01.2019.
//  Copyright © 2019 Codebusters. All rights reserved.
//

import RxSwift
import Sentry
import UIKit

private struct Constants {
    static let inviteFriendButtonTitle = "invite_friend"
    static let bonuses = "bonuses"
}

class NewProfileViewController: ViewController, MVVMView {
    // MARK: - Variables

    var viewModel: ProfileViewModelProtocol!
    let disposeBag = DisposeBag()

    // MARK: - Outlets

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.tableFooterView = UIView()
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.showsVerticalScrollIndicator = false
        view.estimatedRowHeight = 300
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        view.delegate = self
        view.dataSource = self
        view.register(cellType: ProfileAchievementsTableViewCell.self)
        view.register(cellType: ProfileImageTableViewCell.self)
        view.register(cellType: ProfileStatisticsTableViewCell.self)
        if #available(iOS 11, *) {
            view.estimatedRowHeight = 0
        }

        return view
    }()

    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .softBlueBackground
        button.layer.cornerRadius = 20
        button.setImage(#imageLiteral(resourceName: "settings"))
        button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        return button
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        markup()
        configureBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
        viewModel.downloadUser()
    }

    // MARK: - Configurations

    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .main
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }

        navigationItem.rightBarButtonItem = .init(customView: settingsButton)
        navigationItem.title = "profile_tab".localized
    }

    private func configureBindings() {
        viewModel.shouldUpdateTableView.subscribe(onNext: { [weak self] should in
            if should {
                self?.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }

    // MARK: - Actions

    @objc private func openSettings() {
        viewModel.openSettings()
    }

    @objc private func openBonuses() {
        viewModel.openBonuses()
    }

    // MARK: - Markup

    private func markup() {
        view.backgroundColor = .white

        [tableView].forEach { view.addSubview($0) }

        settingsButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension NewProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = ProfileViewModel.CellType(rawValue: indexPath.row)!
        switch type {
        case .profileImage:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ProfileImageTableViewCell.self)

            cell.viewModel = viewModel.profileImageViewModel

            return cell
        case .profileStatistics:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ProfileStatisticsTableViewCell.self)

            cell.viewModel = viewModel.profileStatisticsViewModel

            return cell
        case .profileAchievements:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ProfileAchievementsTableViewCell.self)

            cell.viewModel = viewModel.profileAchievementsViewModel

            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = ProfileViewModel.CellType(rawValue: indexPath.row)!

        switch type {
        case .profileImage: return 174
        case .profileStatistics: return 582
        case .profileAchievements: return 312
        }
    }
}

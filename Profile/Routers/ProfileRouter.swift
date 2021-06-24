//
//  SubscriptionStoreRouter.swift
//  OneFit
//
//  Created by Abzal on 12.12.2018.
//  Copyright © 2018 Codebusters. All rights reserved.
//

import Foundation

class ProfileRouter: MVVMRouter {
    
    // MARK: - Enums

    enum PresentationContext {
        case `default`
    }

    enum RouteType {
        case error(message: String, closeHandler: () -> Void)
        case changePhoto(completion: (UIImage) -> Void)
        case visitsHistory(totalCount: Int)
        case openSettings
        case chooseWeeklyChallenge(current: Int, completion: () -> Void)
        case openAchievements
        case bonuses
    }

    // MARK: - Properties

    weak var baseViewController: UIViewController?

    // MARK: - Methods

    func present(on baseVC: UIViewController, animated _: Bool, context: Any?, completion _: (() -> Void)?) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }

        guard let navigationController = baseVC.navigationController else {
            assertionFailure("Navigation controller is not set")
            return
        }

        baseViewController = baseVC

        switch context {
        case .default: break
        }
    }

    func enqueueRoute(with context: Any?, animated: Bool, completion: (() -> Void)?) {
        guard let routeType = context as? RouteType else {
            assertionFailure("The route type mismatch")
            return
        }

        guard let baseVC = baseViewController else {
            assertionFailure("baseViewController is not set")
            return
        }

        switch routeType {
        case let .error(message, closeHandler):
            let errorAlertRouter = AlertRouter()
            let context = AlertRouter.PresentationContext.error(message: message, closeHandler: closeHandler)
            errorAlertRouter.present(on: baseVC, animated: animated, context: context, completion: completion)
        case let .changePhoto(completion):
            let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertVC.view.tintColor = .main

            alertVC.addAction(UIAlertAction(title: "Сделать фото", style: .default) { _ in
                switch Permission.hasPermission(type: .camera) {
                case .granted:
                    let context = PhotoPickerRouter.PresentationContext.default(sourceType: .camera, photoPickerHandler: completion)
                    let router = PhotoPickerRouter()
                    router.present(on: baseVC, animated: true, context: context, completion: nil)
                default:
                    Permission.present(on: baseVC, type: .camera, force: true) { [weak baseVC] in
                        guard let baseVC = baseVC else { return }
                        let context = PhotoPickerRouter.PresentationContext.default(sourceType: .camera, photoPickerHandler: completion)
                        let router = PhotoPickerRouter()
                        router.present(on: baseVC, animated: true, context: context, completion: nil)
                    }
                }
            })
            alertVC.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in
                switch Permission.hasPermission(type: .library) {
                case .granted:
                    let context = PhotoPickerRouter.PresentationContext.default(sourceType: .photoLibrary, photoPickerHandler: completion)
                    let router = PhotoPickerRouter()
                    router.present(on: baseVC, animated: true, context: context, completion: nil)
                default:
                    Permission.present(on: baseVC, type: .library, force: true) { [weak baseVC] in
                        guard let baseVC = baseVC else { return }

                        let context = PhotoPickerRouter.PresentationContext.default(sourceType: .photoLibrary, photoPickerHandler: completion)
                        let router = PhotoPickerRouter()
                        router.present(on: baseVC, animated: true, context: context, completion: nil)
                    }
                }
            })
            alertVC.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

            baseVC.present(alertVC, animated: true)
        case let .visitsHistory(totalCount):
            let context = VisitsHistoryRouter.PresentationContext.default(totalCount: totalCount)
            let router = VisitsHistoryRouter()
            router.present(on: baseVC, animated: true, context: context, completion: nil)
        case .openSettings:
            let vc = Storyboard.settingsVC as! SettingsTableViewController
            vc.hidesBottomBarWhenPushed = true
            baseVC.navigationController?.pushViewController(vc, animated: true)
        case let .chooseWeeklyChallenge(current, completion):
            let context = ChooseWeeklyChanllengeRouter.PresentationContext.default(current: current)
            let router = ChooseWeeklyChanllengeRouter()
            router.present(on: baseVC, animated: true, context: context, completion: completion)
        case .openAchievements:
            let context = AchievementsRouter.PresentationContext.default
            let router = AchievementsRouter()
            router.present(on: baseVC, animated: true, context: context, completion: nil)
        case .bonuses:
            let router = BonusesRouter()
            let context = BonusesRouter.PresentationContext.default
            router.present(on: baseVC, animated: animated, context: context, completion: completion)
        }
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        baseViewController?.dismiss(animated: animated, completion: completion)
    }
}

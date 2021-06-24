//
//  AboutAppRouter.swift
//  OneFitDev
//
//  Created by Daulet Mussabayev on 21.01.2021.
//  Copyright © 2021 Codebusters. All rights reserved.
//

import Foundation
import UIKit

class AboutAppRouter: MVVMRouter {
       
    //MARK: - Enums
    enum PresentationContext {
        case `main`
    }
    
    enum RouteType {
        case error(message: String, closeHandler: () -> Void)
    }

    //MARK: - Properties
    weak var baseViewController: UIViewController?

    //MARK: - Methods
    func present(on baseVC: UIViewController, animated _: Bool, context: Any?, completion _: (() -> Void)?) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }

        baseViewController = baseVC

        switch context {
        case .main:
            let vc = AboutAppViewController()
            vc.viewModel = AboutAppViewModel(router: self)
            vc.hidesBottomBarWhenPushed = true
            
            baseVC.navigationController?.pushViewController(vc, animated: true)
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
            errorAlertRouter.present(on: baseVC, animated: true, context: context, completion: completion)
        }
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        baseViewController?.dismiss(animated: animated, completion: completion)
    }
}

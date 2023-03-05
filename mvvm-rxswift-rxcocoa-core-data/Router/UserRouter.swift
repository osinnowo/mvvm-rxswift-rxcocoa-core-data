//
//  UserRouter.swift
//  mvvm-rxswift-rxcocoa-core-data
//
//  Created by Emmanuel Osinnowo on 05/03/2023.
//

import UIKit

typealias Entry = UIViewController & UserViewProtocol

protocol UserRouterProtocol {
    var entry: Entry? { get }
    static func start() -> UserRouterProtocol
}

final class UserRouter: UserRouterProtocol {
    var entry: Entry?
    
    static func start() -> UserRouterProtocol {
        var router = UserRouter()
        var entry = UserViewController()
        var interactor = UserInteractor()
        var presenter = UserPresenter()
        
        interactor.presenter = presenter
        entry.presenter = presenter
        
        presenter.view = entry
        presenter.interactor = interactor
        presenter.router = router
        router.entry = entry
        
        return router
    }
}

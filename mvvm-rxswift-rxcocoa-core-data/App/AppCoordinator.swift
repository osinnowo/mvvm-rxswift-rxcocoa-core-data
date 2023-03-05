//
//  AppCoordinator.swift
//  mvvm-rxswift-rxcocoa-core-data
//
//  Created by Emmanuel Osinnowo on 05/03/2023.
//

import UIKit

final class AppCoordinator {
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        window?.rootViewController = UINavigationController(
            rootViewController: UserRouter.start().entry!
        )
        window?.makeKeyAndVisible()
    }
}

//
//  UserPresenter.swift
//  mvvm-rxswift-rxcocoa-core-data
//
//  Created by Emmanuel Osinnowo on 05/03/2023.
//

import UIKit

protocol UserPresenterProtocol {
    var interactor: UserInteractorProtocol? { get }
    var view: UserViewProtocol? { get }
    var router: UserRouterProtocol? { get }
    
    func fetchUserList()
    func didFetchUserList(with result: Result<[User], NetworkError>)
}

final class UserPresenter: UserPresenterProtocol {

    var view: UserViewProtocol?
    
    var router: UserRouterProtocol?
    
    var interactor: UserInteractorProtocol? {
        didSet {
           fetchUserList()
        }
    }
    
    func fetchUserList() {
        view?.showLoading()
        interactor?.getUserList()
    }
    
    func didFetchUserList(with result: Result<[User], NetworkError>) {
        view?.hideLoading()
        switch result {
            case .success(let users):
                self.view?.update(with: users)
            case .failure(let error):
                self.view?.update(with: error)
        }
    }
}

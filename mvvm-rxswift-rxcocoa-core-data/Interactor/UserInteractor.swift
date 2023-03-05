//
//  UserInteractor.swift
//  mvvm-rxswift-rxcocoa-core-data
//
//  Created by Emmanuel Osinnowo on 05/03/2023.
//

import UIKit
import RxSwift
import CoreData

protocol UserInteractorProtocol {
    var presenter: UserPresenterProtocol? { get set }
    func getUserList()
}

extension UserEntity: AutoMapper {
    func mapper(item: UserEntity, context: NSManagedObjectContext) -> User {
        let user = User(name: item.name ?? "", username: item.username ?? "")
        return user
    }
    
    typealias T = UserEntity
    
    typealias M = User

}

final class UserInteractor: UserInteractorProtocol {
    let disposeBag = DisposeBag()
    var presenter: UserPresenterProtocol?
    
    func getUserList() {
        var storage = CoreDataProvider<UserEntity>(
            context: (UIApplication.shared.delegate as! AppDelegate)
                .persistentContainer.viewContext)
        
        let users = try? storage.fetchRecords().map {
            $0.mapper(item: $0, context: storage.getContext())
        }
        if let users = users {
            self.presenter?.didFetchUserList(with: .success(users))
        }

        NetworkService<Empty, [User]>().send(path: "/users")
            .subscribe(onNext: { users in
                    do {
                        _ = try storage.create(multiple: users.map {
                                $0.mapper(item: $0, context: storage.getContext())
                            })
                            self.presenter?.didFetchUserList(with: .success(users))
                    } catch {
                        print(error.localizedDescription)
                    }
                },
                onError: { error in
                    self.presenter?.didFetchUserList(with: .failure(error as! NetworkError))
                }
        ).disposed(by: disposeBag)
    }
}

//
//  ViewController.swift
//  mvvm-rxswift-rxcocoa-core-data
//
//  Created by Emmanuel Osinnowo on 05/03/2023.
//

import UIKit

protocol UserViewProtocol {
    var presenter: UserPresenterProtocol? { get set }
    func update(with listOfUsers: [User])
    func update(with error: NetworkError)
    func showLoading()
    func hideLoading()
}

final class UserViewController: UIViewController, UserViewProtocol {
    var presenter: UserPresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    private var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemCyan
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with listOfUsers: [User]) {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.users = listOfUsers
            self.tableView.reloadData()
        }
    }
    
    func update(with error: NetworkError) {
        print("Error: \(error.localizedDescription)")
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            
        }
    }
}

extension UserViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.users[indexPath.row].name
        return cell
    }
}

//
//  MVCViewController.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

class MVCViewController: UIViewController {

    private let tableView = UITableView()
    private var headerView = Bundle.main.loadNibNamed("MVCTableViewHeaderView", owner: nil, options: nil)!.first as! MVCTableViewHeaderView

    private var model: MVCModel = MVCStore.shared.model

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        config()

        NotificationCenter.default.addObserver(self, selector: #selector(handleStoreChanged), name: MVCStore.changedNotification, object: nil)
    }

    @objc private func handleStoreChanged(notification: Notification) {
        guard let reason = notification.userInfo?[MVCModel.changeReasonKey] as? MVCModel.ChangeReasonKey else { return }
        switch reason {
        case .starChanged(index: let index):
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        case .addRepo:
            break
        case .removeRepo:
            break
        }
    }

    private func makeUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func config() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MVCTableViewCell", bundle: nil), forCellReuseIdentifier: "MVCTableViewCell")
        tableView.tableHeaderView = headerView
        headerView.setData(url: model.avatarURL, nickname: model.nickname)
        headerView.frame.size.height = 250

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
}

extension MVCViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVCTableViewCell", for: indexPath) as! MVCTableViewCell
        let repo = model.repositories[indexPath.row]
        cell.setData(title: repo.title, isStar: repo.isStar)
        cell.starImageViewTapAction = { [weak self] in
            self?.model.tapStarRepo(id: repo.id)
        }
        cell.selectionStyle = .none
        return cell
    }
}

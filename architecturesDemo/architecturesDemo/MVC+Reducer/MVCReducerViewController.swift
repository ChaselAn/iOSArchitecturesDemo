//
//  MVCStoreViewController.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

class MVCReducerViewController: UIViewController {

    private let tableView = UITableView()
    private var headerView = Bundle.main.loadNibNamed("MVCTableViewHeaderView", owner: nil, options: nil)!.first as! MVCTableViewHeaderView

    private var model: MVCModel = MVCStore.shared.model

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        config()

        mvcStateStore.subscribe(newStateOnly: true) { [weak self] (state) in
            guard let action = state.action else { return }
            switch action {
            case .starChanged(index: let index):
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            case .addRepo:
                self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            case .deleteRepo(index: let index):
                self?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addRepo))
    }

    @objc private func addRepo() {
        let alert = UIAlertController(title: "add repo", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "add", style: .default, handler: { [weak self] (_) in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            self?.model.addRepoForReducer(title: text)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension MVCReducerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVCTableViewCell", for: indexPath) as! MVCTableViewCell
        let repo = model.repositories[indexPath.row]
        cell.setData(title: repo.title, isStar: repo.isStar)
        cell.starImageViewTapAction = { [weak self] in
            self?.model.tapStarRepoForReducer(id: repo.id)
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let repo = model.repositories[indexPath.row]
        model.removeRepoForReducer(id: repo.id)
    }
}

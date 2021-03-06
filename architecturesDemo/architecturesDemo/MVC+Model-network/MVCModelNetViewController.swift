//
//  MVCControllerNetViewController.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

class MVCModelNetViewController: UIViewController {

    private let tableView = UITableView()
    private let hud = UIActivityIndicatorView(style: .gray)

    private var repoList = MVCNetworkStore.shared.model

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        config()

        showHud()
        repoList.load { [weak self] (res) in
            guard let strongSelf = self else { return }
            strongSelf.hideHud()
            switch res {
            case .success:
                break
            case .failure:
                let alert = UIAlertController(title: "request error", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }

        mvcNetStateStore.subscribe(newStateOnly: true) { [weak self] (state) in
            guard let action = state.action else { return }
            switch action {
            case .reload:
                self?.tableView.reloadData()
            default:
                break
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

        view.addSubview(hud)
        hud.translatesAutoresizingMaskIntoConstraints = false
        hud.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hud.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hud.isHidden = true
    }

    private func showHud() {
        hud.isHidden = false
        hud.startAnimating()
    }

    private func hideHud() {
        hud.isHidden = true
        hud.stopAnimating()
    }

    private func config() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MVCTableViewCell", bundle: nil), forCellReuseIdentifier: "MVCTableViewCell")

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addRepo))
    }

    @objc private func addRepo() {
        let alert = UIAlertController(title: "add repo", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "add", style: .default, handler: { [weak self] (_) in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            //            self?.model.addRepoForReducer(title: text)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension MVCModelNetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoList.repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVCTableViewCell", for: indexPath) as! MVCTableViewCell
        let repo = repoList.repos[indexPath.row]
        cell.setData(title: repo.name, isStar: false)
        cell.starImageViewTapAction = { [weak self] in
            //            self?.model.tapStarRepoForReducer(id: repo.id)
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        //        let repo = model.repositories[indexPath.row]
        //        model.removeRepoForReducer(id: repo.id)
    }
}

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
    private var headerView = Bundle.main.loadNibNamed("MVCTableViewHeaderView.xib", owner: nil, options: nil)!.first as! MVCTableViewHeaderView

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        config()
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
        tableView.register(MVCTableViewCell.self, forCellReuseIdentifier: "MVCTableViewCell")
        tableView.tableHeaderView = headerView
    }
}

extension MVCViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVCTableViewCell", for: indexPath) as! MVCTableViewCell
        return cell
    }
}

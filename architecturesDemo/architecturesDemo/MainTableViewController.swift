//
//  MainTableViewController.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/17.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = ViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

//
//  MVCStore.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit
import Disk

class MVCStore {

    static let shared = MVCStore()
    private(set) var model: MVCModel

    static let changedNotification = Notification.Name("StoreChanged")
    private let diskPath = "MVCStore"

    private init() {
        if let data = try? Disk.retrieve(diskPath, from: .documents, as: MVCModel.self) {
            self.model = data
        } else {
            self.model = MVCModel.mock()
        }
    }

    func save(_ model: MVCModel, userInfo: [AnyHashable: Any]) {
        try? Disk.save(model, to: .documents, as: diskPath)
        NotificationCenter.default.post(name: MVCStore.changedNotification, object: model, userInfo: userInfo)
    }
}

//
//  Model.swift
//  architecturesDemo
//
//  Created by ac on 2018/12/30.
//  Copyright © 2018年 ac. All rights reserved.
//

import UIKit

class Model {
    static let textDidChange = Notification.Name("textDidChange")
    static let textKey = "text"

    var value: String {
        didSet {
            NotificationCenter.default.post(name: Model.textDidChange, object: self, userInfo: [Model.textKey: value])
        }
    }

    init(value: String) {
        self.value = value
    }
}

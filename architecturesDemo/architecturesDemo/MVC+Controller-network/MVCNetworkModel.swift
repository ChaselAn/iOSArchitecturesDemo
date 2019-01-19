//
//  MVCNetworkModel.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

struct MVCNetworkRepository: Codable {
    var id: Int
    var name: String
    var isStar: Bool {
        get {
            return _isStar ?? false
        }
        set {
            _isStar = newValue
        }
    }
    private var _isStar: Bool?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case _isStar
    }
}

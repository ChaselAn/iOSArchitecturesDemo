//
//  MVCStore.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

class MVCStore {

    static let shared = MVCStore()
    private(set) var model = MVCModel.mock() // 注意为什么用struct

    private init() {}

}

//
//  MVCReducerStore.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit
import Disk

struct MVCState {
    public var action: MVCAction?
}

enum MVCAction {
    case starChanged(index: Int)
    case deleteRepo(index: Int)
    case addRepo
}

let mvcReducer = Reducer<MVCState, MVCAction> { state, action in
    MVCReducerStore.shared.save()
    state.action = action
}

var mvcStateStore = Store(reducer: mvcReducer, initialState: MVCState())

class MVCReducerStore {

    static let shared = MVCReducerStore()
    private(set) var model: MVCModel

    private let diskPath = "MVCStore"

    private init() {
        if let data = try? Disk.retrieve(diskPath, from: .documents, as: MVCModel.self) {
            self.model = data
        } else {
            self.model = MVCModel.mock()
        }
    }

    func save() {
        try? Disk.save(model, to: .documents, as: diskPath)
    }
}

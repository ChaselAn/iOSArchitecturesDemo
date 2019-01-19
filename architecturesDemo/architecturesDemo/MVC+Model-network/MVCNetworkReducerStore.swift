//
//  MVCNetworkReducerStore.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit
import Disk

struct MVCNetState {
    public var action: MVCNetAction?
}

enum MVCNetAction {
    case reload
    case starChanged(index: Int)
    case deleteRepo(index: Int)
    case addRepo
}

let mvcNetReducer = Reducer<MVCNetState, MVCNetAction> { state, action in
    MVCReducerStore.shared.save()
    state.action = action
}

var mvcNetStateStore = Store(reducer: mvcNetReducer, initialState: MVCNetState())

class MVCNetworkStore {

    static let shared = MVCNetworkStore()
    private(set) var model: MVCNetworkRepos

    private let diskPath = "MVCStore"

    private init() {
        if let data = try? Disk.retrieve(diskPath, from: .documents, as: MVCNetworkRepos.self) {
            self.model = data
        } else {
            self.model = MVCNetworkRepos(repos: [])
        }
    }

    func save() {
        try? Disk.save(model, to: .documents, as: diskPath)
    }
}

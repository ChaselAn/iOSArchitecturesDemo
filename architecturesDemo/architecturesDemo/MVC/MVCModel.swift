//
//  MVCModel.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

class MVCModel: Codable {
    var avatarURL: URL
    var nickname: String
    var repositories: [Repository]

    init(avatarURL: URL, nickname: String, repositories: [Repository]) {
        self.avatarURL = avatarURL
        self.nickname = nickname
        self.repositories = repositories
    }
}

class Repository: Codable {
    var id: String
    var title: String
    var isStar: Bool

    func tapStar() {
        isStar = !isStar
    }

    init(title: String, isStar: Bool) {
        self.id = UUID().uuidString
        self.title = title
        self.isStar = isStar
    }
}

extension MVCModel {
    static func mock() -> MVCModel {
        let repositories = [
            Repository(title: "ArchitecturesDemo", isStar: true),
            Repository(title: "Octopus", isStar: false),
            Repository(title: "SoapBubble", isStar: true),
            Repository(title: "MonkeyKing", isStar: true),
            Repository(title: "ACTagView", isStar: false),
            Repository(title: "FancyAlert", isStar: false)
        ]

        return MVCModel(avatarURL: URL(string: "https://raw.githubusercontent.com/ChaselAn/iOSArchitecturesDemo/master/architecturesDemo/timg.jpeg")!,
                        nickname: "ChaselAn",
                        repositories: repositories)
    }
}

// MARK: - MVC
extension MVCModel {
    static let changeReasonKey = "reason"

    enum ChangeReasonKey {
        case starChanged(index: Int)
        case addRepo
        case deleteRepo(index: Int)
    }

    func tapStarRepo(id: String) {
        for (index, repo) in repositories.enumerated() where repo.id == id {
            repo.tapStar()
            MVCStore.shared.save(self, userInfo: [
                MVCModel.changeReasonKey: ChangeReasonKey.starChanged(index: index)
                ]
            )
        }
    }

    func addRepo(title: String) {
        repositories.insert(Repository(title: title, isStar: false), at: 0)
        MVCStore.shared.save(self, userInfo: [
            MVCModel.changeReasonKey: ChangeReasonKey.addRepo
            ]
        )
    }

    func removeRepo(id: String) {
        if let index = repositories.firstIndex(where: { $0.id == id }) {
            repositories.remove(at: index)
            MVCStore.shared.save(self, userInfo: [
                MVCModel.changeReasonKey: ChangeReasonKey.deleteRepo(index: index)
                ]
            )
        }
    }
}

// MARK: - MVC
extension MVCModel {
    func tapStarRepoForReducer(id: String) {
        for (index, repo) in repositories.enumerated() where repo.id == id {
            repo.tapStar()
            mvcStateStore.dispatch(.starChanged(index: index))
        }
    }

    func addRepoForReducer(title: String) {
        repositories.insert(Repository(title: title, isStar: false), at: 0)
        mvcStateStore.dispatch(.addRepo)
    }

    func removeRepoForReducer(id: String) {
        if let index = repositories.firstIndex(where: { $0.id == id }) {
            repositories.remove(at: index)
            mvcStateStore.dispatch(.deleteRepo(index: index))
        }
    }
}

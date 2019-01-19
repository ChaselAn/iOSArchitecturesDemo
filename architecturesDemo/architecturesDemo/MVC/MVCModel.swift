//
//  MVCModel.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

struct MVCModel {
    var avatarURL: URL
    var nickname: String
    var repositories: [Repository]
}

struct Repository {
    var title: String
    var isStar: Bool
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

        return MVCModel(avatarURL: URL(string: "https://raw.githubusercontent.com/ChaselAn/iOSArchitecturesDemo/master/architecturesDemo/timg.jpeg")!, nickname: "ChaselAn", repositories: repositories)
    }
}


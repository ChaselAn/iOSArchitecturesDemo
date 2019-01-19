//
//  MVCNetworkRepos.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

class MVCNetworkRepos: Codable {
    var repos: [MVCNetworkRepo]

    init(repos: [MVCNetworkRepo]) {
        self.repos = repos
    }

    enum Result {
        case success
        case failure(Error?)
    }

    func load(completion: @escaping (Result) -> Void) {
        URLSession.shared.dataTask(with: URL(string: "https://api.github.com/users/ChaselAn/repos")!) { (data, _, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(error))
                    return
                }
                do {
                    let repos = try JSONDecoder().decode([MVCNetworkRepo].self, from: data)
                    self.repos = repos
                    mvcNetStateStore.dispatch(.reload)
                    completion(.success)
                } catch {
                    completion(.failure(error))
                    print("---------------", error)
                }
            }
        }.resume()
    }
}

class MVCNetworkRepo: Codable {

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

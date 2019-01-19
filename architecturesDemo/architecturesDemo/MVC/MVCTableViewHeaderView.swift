//
//  MVCTableViewHeaderView.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

class MVCTableViewHeaderView: UIView {

    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var nicknameLabel: UILabel!
    
    func setAvatar(url: URL) {
        guard let data = try? Data(contentsOf: url) else { return }
        avatarImageView.image = UIImage(data: data)
    }

    func setNickname(text: String) {
        nicknameLabel.text = text
    }
}

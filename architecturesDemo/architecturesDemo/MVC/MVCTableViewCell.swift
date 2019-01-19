//
//  MVCTableViewCell.swift
//  architecturesDemo
//
//  Created by ac on 2019/1/19.
//  Copyright © 2019年 ac. All rights reserved.
//

import UIKit

class MVCTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var starImageView: UIImageView!

    var starImageViewTapAction: (()-> Void)?

    private var isStar = false {
        didSet {
            starImageView.image = isStar ? #imageLiteral(resourceName: "icon_star") : #imageLiteral(resourceName: "icon_unstar")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        starImageView.isUserInteractionEnabled = true
        starImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(starImageViewDidTap)))
    }

    func setData(title: String, isStar: Bool) {
        titleLabel.text = title
        self.isStar = isStar
    }

    @objc private func starImageViewDidTap(_ sender: UITapGestureRecognizer) {
        starImageViewTapAction?()
    }
}

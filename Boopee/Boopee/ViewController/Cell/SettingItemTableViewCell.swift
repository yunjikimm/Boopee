//
//  SettingItemTableViewCell.swift
//  Boopee
//
//  Created by yunjikim on 3/31/24.
//

import UIKit

class SettingItemTableViewCell: UITableViewCell {
    static let id = "SettingItemTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .customSystemBackground
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  SettingItemTableViewCell.swift
//  Boopee
//
//  Created by yunjikim on 3/31/24.
//

import UIKit

class SettingItemTableViewCell: UITableViewCell {
    static let id = "SettingItemTableViewCell"
    
    private let icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .grayOne
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .customSystemBackground
        self.selectionStyle = .none
        
        self.addSubview(icon)
        
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

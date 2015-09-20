//
//  RepoPreviewTableViewCell.swift
//  SwiftHub
//
//  Created by Sahand Nayebaziz on 8/16/15.
//  Copyright (c) 2015 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SnapKit

class RepoPreviewTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let ownerLabel = UILabel()
    let starsLabel = UILabel()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setCell(repo: Repository) -> RepoPreviewTableViewCell {
        
        ownerLabel.font = UIFont.systemFontOfSize(15, weight: 0.0)
        ownerLabel.textAlignment = .Left
        ownerLabel.alpha = 0.33
        contentView.addSubview(ownerLabel)
        ownerLabel.snp_makeConstraints { make in
            make.centerY.equalTo(contentView.snp_centerY)
            make.left.equalTo(contentView.snp_left).offset(18)
        }
        
        nameLabel.font = UIFont.systemFontOfSize(16, weight: 0.3)
        nameLabel.textAlignment = .Left
        contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.centerY.equalTo(ownerLabel.snp_centerY)
            make.left.equalTo(ownerLabel.snp_right).offset(4)
        }
        
        
        nameLabel.text = "/ \(repo.name)"
        ownerLabel.text = repo.owner
        
        return self
    }

}

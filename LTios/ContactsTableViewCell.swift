//
//  ContactsTableViewCell.swift
//  LTios
//
//  Created by antoine beneteau on 2017-10-27.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    var didSetupConstraints = false
    
    let queue = SerialOperationQueue()
    
    var cellView = UIView()
    
    var name = UILabel()
    var surname = UILabel()
    var profilePicture = RoundShadowImageView()
    var country = UILabel()
    var status = UILabel()
    var lineSeparator = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundColor = .white
        
        name.textColor = UIColor.gray
        name.font = UIFont(name: "Roboto-Regular", size: 16)
        
        surname.textColor = UIColor.darkGray
        surname.font = UIFont(name: "Roboto-Bold", size: 16)
        
        country.textColor = UIColor.lightGray
        country.font = UIFont(name: "Roboto-Regular", size: 11)
        
        status.textColor = UIColor(red:0.69, green:0.42, blue:0.70, alpha:1.0)
        status.font = UIFont(name: "Roboto-Bold", size: 11)
        status.isHidden = true
                
        lineSeparator.backgroundColor = .gray
        lineSeparator.alpha = 0.3
        
        addSubview(cellView)
        addSubview(name)
        addSubview(surname)
        addSubview(profilePicture)
        addSubview(country)
        addSubview(status)
        addSubview(lineSeparator)
        
        updateConstraints()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            profilePicture.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(contentView).multipliedBy(0.8)
                make.width.equalTo(profilePicture.snp.height)
                make.centerY.equalTo(contentView)
                make.left.equalTo(contentView).offset(14)
            }
            
            name.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(16)
                make.left.equalTo(profilePicture.snp.right).offset(11)
            }
            
            surname.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(16)
                make.left.equalTo(name.snp.right).offset(4)
            }
            
            country.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(name.snp.bottom).offset(4)
                make.left.equalTo(name)
            }
            
            status.snp.makeConstraints { (make) -> Void in
                make.centerY.equalTo(contentView)
                make.right.equalTo(contentView).offset(-7)
            }
            
            lineSeparator.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(contentView).multipliedBy(0.9)
                make.centerX.equalTo(contentView)
                make.bottom.equalTo(contentView)
                make.height.equalTo(0.5)
            }
            
            didSetupConstraints = true
            
        }
        super.updateConstraints()
    }
    
}


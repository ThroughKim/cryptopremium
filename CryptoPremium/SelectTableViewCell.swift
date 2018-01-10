//
//  selectTableViewCell.swift
//  CryptoPremium
//
//  Created by KimSeulWoo on 2018. 1. 10..
//  Copyright © 2018년 Maxwell Stein. All rights reserved.
//

import UIKit

class SelectTableViewCell: UITableViewCell {

    var currencyImageView: UIImageView!
    var currencyName: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .white
        
        currencyImageView = UIImageView()
        currencyName = UILabel()
        
        self.addSubview(currencyImageView)
        self.addSubview(currencyName)
        
        currencyImageView.snp.makeConstraints{ make in
            make.width.height.equalTo(30)
            make.leftMargin.equalTo(15)
            make.topMargin.equalTo(10)
            make.bottomMargin.equalTo(-10)
        }
        currencyName.snp.makeConstraints{ make in
            make.left.equalTo(currencyImageView.snp.right).offset(30)
            make.centerY.equalTo(currencyImageView)
        }
        
    }
    
}

//
//  CircleImageView.swift
//  KUSBF
//
//  Created by 김지우 on 2017. 12. 28..
//  Copyright © 2017년 jiwoo. All rights reserved.
//

import Foundation
import UIKit

class CircleImageView : UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = CGRect(x: 68, y: 68, width: 68, height: 68)
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.init(hexString: "#EBEBEB").cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width/2.0
    }
}

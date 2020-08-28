//
//  CustomUILabel.swift
//  InstagramFB
//
//  Created by David on 07/10/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class LabelWithInsets: UILabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)))
    }
}

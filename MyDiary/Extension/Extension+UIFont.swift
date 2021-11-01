//
//  Extension+UIFont.swift
//  MyDiary
//
//  Created by 박연배 on 2021/11/01.
//

import UIKit

/*
    =====> S-CoreDream-2ExtraLight
    =====> S-CoreDream-5Medium
    =====> S-CoreDream-9Black
*/

extension UIFont {
    var mainFontBold: UIFont {
        return UIFont(name: "S-CoreDream-9Black", size: 17)!
    }
    
    var mainFontMedium: UIFont {
        return UIFont(name: "S-CoreDream-5Medium", size: 14)!
    }
    
    var mainFontLight: UIFont {
        return UIFont(name: "S-CoreDream-2ExtraLight", size: 14)!
    }
    
}

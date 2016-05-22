//
//  UIConstants.swift
//  Roposo
//
//  Created by starapps on 21/05/16.
//  Copyright © 2016 private. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let STATUS_BAR_HEIGHT: CGFloat = 20.0
    static let NAVIGATION_BAR_HEIGHT: CGFloat = 44.0
    static let SCREEN_WIDTH: CGFloat = UIScreen.mainScreen().bounds.width
    static let USERIMAGE_WIDTH: CGFloat = 50.0
    static let USERIMAGE_BIG_WIDTH: CGFloat = 75.0
    static let ACTION_BUTTON_WIDTH: CGFloat = 45.0
    static let ACTION_BUTTON_HEIGHT: CGFloat = 35.0
    static let BOTTOM_BORDER_HEIGHT: CGFloat = 10.0
    static let SMALL_PADDING: CGFloat = 5.0
    static let LARGE_PADDING: CGFloat = 10.0
    static let FOLLOW_BTN_BORDER_WIDTH: CGFloat = 1.0
    static let FOLLOW_BTN_CORNER_RADIUS: CGFloat = 5.0
}

/*  Global fonts    */
let _titleFont = UIFont(name: APP_FONT_NAME, size: 16.0)!
let _subtitleFont = UIFont(name: APP_FONT_NAME, size: 14.0)!
let _bigTitleFont = UIFont(name: APP_FONT_NAME, size: 18.0)!
let _bigSubtitleFont = UIFont(name: APP_FONT_NAME, size: 16.0)!

/*  Global images   */
let _placeholder = UIImage(named: "ic_placeholder")
let _likeImageEmpty = UIImage(named: "ic_like")
let _likeImageFill = UIImage(named: "ic_like_fill")
let _commentImage = UIImage(named: "ic_comment")
let _shareImage = UIImage(named: "ic_share")
let _followImage = UIImage(named: "ic_follow")
let _followingImage = UIImage(named: "ic_following")

/*  Global colors   */
let _navigationBarTitleColor = UIColor.whiteColor()
let _navigationBarTintColor = UIColor(red: 218/255.0, green: 81/255, blue: 102/255.0, alpha: 1.0)
let _titleColor = UIColor.blackColor()
let _subtitleColor = UIColor.blackColor()
let _followBtnColor = UIColor(red: 127/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1.0)
let _followBtnBackgorundColor = UIColor.whiteColor()
let _bottomBorderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
let _followingBtnBackgroundColor = UIColor(red: 244/255.0, green: 67/255.0, blue: 54/255.0, alpha: 1.0)
let _followingBtnTitleColor = UIColor.whiteColor()
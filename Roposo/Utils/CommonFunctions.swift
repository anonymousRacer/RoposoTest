//
//  CommonFunctions.swift
//  Roposo
//
//  Created by starapps on 22/05/16.
//  Copyright © 2016 private. All rights reserved.
//

import Foundation
import UIKit

class CommonFunctions {
    
    //  Native share
    static func nativeShare(viewController: UIViewController, story: Story, sender: UIButton) {
        let activityVC = UIActivityViewController(activityItems: ["\"" + story.getTitle() + "\"", NSURL(string: story.getUrl())!], applicationActivities: nil)
        activityVC.setValue(SHARE_STORY_TEXT, forKey: "subject")
        activityVC.popoverPresentationController?.sourceView = sender
        activityVC.popoverPresentationController?.sourceRect = sender.bounds
        viewController.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    // Scale image to device width keeping aspect ratio
    static func scaleImageToWidth(image: UIImage) -> UIImage {
        let requiredImageWidth = Constants.SCREEN_WIDTH
        let scaledImage: UIImage?
        
        if image.size.width != requiredImageWidth {
            let requiredImageHeight = image.size.height * (requiredImageWidth / image.size.width)
            let imageSize = CGSizeMake(requiredImageWidth, requiredImageHeight)
            
            UIGraphicsBeginImageContextWithOptions(imageSize, true, 0.0)
            image.drawInRect(CGRectMake(0, 0, requiredImageWidth, requiredImageHeight))
            scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        else {
            scaledImage = image
        }
        return scaledImage!
    }
    
    // Get story image height
    static func getStoryImageHeight() -> CGFloat {
        return Constants.SCREEN_WIDTH * 0.8
    }
    
}

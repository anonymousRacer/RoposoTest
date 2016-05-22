//
//  Story.swift
//  Roposo
//
//  Created by starapps on 21/05/16.
//  Copyright © 2016 private. All rights reserved.
//

import Foundation

class Story: NSObject {
    
    var storyDesc: String?
    var id: String?
    var verb: String?
    var db: String?
    var url: String?
    var si: String?
    var type: String?
    var title: String?
    var likeFlag: Bool?
    var likesCount: Int?
    var commentCount: Int?
    
    // Getters
    func getStoryDesc() -> String {
        return storyDesc == "" ? NO_DESC_AVAILABLE : storyDesc!
    }
    
    func getId() -> String {
        return id == nil ? "" : id!
    }
    
    func getVerb() -> String {
        return verb == nil ? "" : verb!
    }
    
    func getDb() -> String {
        return db == nil ? "" : db!
    }
    
    func getUrl() -> String {
        return url == nil ? "" : url!
    }
    
    func getSi() -> String {
        return si == nil ? "" : si!
    }
    
    func getType() -> String {
        return type == nil ? "" : type!
    }
    
    func getTitle() -> String {
        return title == nil ? "" : title!
    }
    
    func getLikeFlag() -> Bool {
        return likeFlag == nil ? false : likeFlag!
    }
    
    func getLikesCount() -> Int {
        return likesCount == nil ? 0 : likesCount!
    }
    
    func getCommentCount() -> Int {
        return commentCount == nil ? 0 : commentCount!
    }
    
}
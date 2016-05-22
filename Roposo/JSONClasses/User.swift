//
//  User.swift
//  Roposo
//
//  Created by starapps on 21/05/16.
//  Copyright © 2016 private. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var id: String?
    var about: String?
    var username: String?
    var followers: Int?
    var following: Int?
    var image: String?
    var url: String?
    var handle: String?
    var isFollowing: Bool?
    var createdOn: IntMax?
    
    // Getters
    func getId() -> String {
        return id == nil ? "" : id!
    }
    
    func getAbout() -> String {
        return about == nil ? NO_DESC_AVAILABLE : about!
    }
    
    func getUsername() -> String {
        return username == nil ? "" : username!
    }
    
    func getFollowers() -> Int {
        return followers == nil ? 0 : followers!
    }
    
    func getFollowing() -> Int {
        return following == nil ? 0 : following!
    }
    
    func getImage() -> String {
        return image == nil ? "" : image!
    }
    
    func getUrl() -> String {
        return url == nil ? "" : url!
    }
    
    func getHandle() -> String {
        return handle == nil ? "" : handle!
    }
    
    func getIsFollowing() -> Bool {
        return isFollowing == nil ? false : isFollowing!
    }
    
    func getCreatedOn() -> IntMax {
        return createdOn == nil ? 0 : createdOn!
    }
    
}
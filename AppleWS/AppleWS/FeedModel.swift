//
//  FeedModel.swift
//  AppleWS
//
//  Created by Parth on 30/11/16.
//  Copyright © 2016 Solution Analysts. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

// TODO:  Need to add code for realm -

class FeedModel: Mappable {
    var feed: FeedDict?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        feed <- map["feed"]
    }
}

class FeedDict: Mappable {
    var title: LabelDict?
    var updated: LabelDict?
    var rights: LabelDict?
    var author: Author?
    var entry: [AllEntry]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        updated <- map["updated"]
        rights <- map["rights"]
        author <- map["author"]
        entry <- map["entry"]
    }
}

class Author: Mappable {
    var name: LabelDict?
    var uri: LabelDict?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        uri <- map["uri"]
    }
}

class AllEntry: Mappable {
    var name: LabelDict?
    var image: [LabelDict]?
    var summary: LabelDict?
    var price: LabelDict?
    var rights: LabelDict?
    var title: LabelDict?
    var releaseDate: LabelDict?

    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["im:name"]
        image <- map["im:image"]
        summary <- map["summary"]
        price <- map["im:price"]
        rights <- map["rights"]
        title <- map["title"]
        releaseDate <- map["im:releaseDate"]
    }
}

class LabelDict: Mappable, CustomStringConvertible {
    var label: String?
    var description: String {
        get {
            return self.label ?? ""
        }
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        label <- map["label"]
    }
}

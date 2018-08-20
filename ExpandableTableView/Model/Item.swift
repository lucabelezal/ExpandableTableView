//
//  Item.swift
//  ExpandableTableView
//
//  Created by Lucas Nascimento on 19/08/18.
//  Copyright © 2018 Lucas Nascimento. All rights reserved.
//

import Foundation

public struct ItemModel {
    public let question : String
    public let answer : String
    public init(question:String, answer:String) {
        self.question = question
        self.answer = answer
    }
}

class Item {
    
    let title: String
    let description: String
    var isExpanded: Bool
    
    private init(title: String, description: String) {
        self.title = title
        self.description = description
        self.isExpanded = false
    }
    
    private convenience init?(dictionary: [String: String]) {
        guard let title = dictionary["Title"],
            let description = dictionary["Description"] else {
                return nil
        }
        
        self.init(title: title, description: description)
    }
    
    static func allItems() -> [Item] {
        var items = [Item]()
        
        guard let URL = Bundle.main.url(forResource: "FAQs", withExtension: "plist"),
            let itemsFromPlist = NSArray(contentsOf: URL) as? [[String:String]] else {
                return items
        }
        
        for dictionary in itemsFromPlist {
            if let item = Item(dictionary: dictionary) {
                items.append(item)
            }
        }
        
        return items
    }
}


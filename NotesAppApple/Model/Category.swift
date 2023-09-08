//
//  Category.swift
//  NotesAppApple
//
//  Created by Ananth Nair on 08/09/23.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let item = List<Item>()
    
}

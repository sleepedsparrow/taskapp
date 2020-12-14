//
//  Task.swift
//  taskapp
//
//  Created by 加藤桃香 on 2020/12/06.
//  Copyright © 2020 momoka.kato. All rights reserved.
//

import RealmSwift

class Task: Object{
    
    @objc dynamic var id = 0
    
    @objc dynamic var title = ""
    
     @objc dynamic var contents = ""
    
    @objc dynamic var date = Date()
    
    @objc dynamic var category = ""
   
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

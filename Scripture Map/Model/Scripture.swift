//
//  Scripture.swift
//  Scripture Map
//
//  Created by Gavin Nitta on 10/30/17.
//  Copyright © 2017 Gavin Nitta. All rights reserved.
//

import Foundation
import GRDB

struct Scripture : TableMapping, RowConvertible {
    var id: Int
    var bookId: Int
    var chapter: Int
    var verse: Int
    var flag: String
    var text: String
    
    static let databaseTableName = "scripture"
    
    static let id = "ID"
    static let bookId = "BookID"
    static let chapter = "Chapter"
    static let verse = "Verse"
    static let flag = "Flag"
    static let text = "Text"
    
    init(row: Row) {
        id = row[Scripture.id]
        bookId = row[Scripture.bookId]
        chapter = row[Scripture.chapter]
        verse = row[Scripture.verse]
        flag = row[Scripture.flag]
        text = String(data: row[Scripture.text], encoding: .utf8)!
    }
}


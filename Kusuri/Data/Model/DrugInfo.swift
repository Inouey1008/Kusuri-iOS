//
//  DrugInfo.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/08/14.
//

import Foundation

class DrugInfo {
    var genericName: String
    var tradeName: String
    var company: String
    var url: String
    
    init(genericName: String, tradeName: String, company: String, url: String) {
        self.genericName = genericName
        self.tradeName = tradeName
        self.company = company
        self.url = url
    }
}

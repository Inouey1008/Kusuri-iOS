//
//  DrugInfoEntity.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/02/08.
//

import Foundation

struct DrugInfoEntity: Codable {
    let genericName: String
    let tradeName: String
    let company: String
    let url: String
    
    func toDrugInfo() -> DrugInfo {
        return DrugInfo(genericName: genericName, tradeName: tradeName, company: company, url: url)
    }
}

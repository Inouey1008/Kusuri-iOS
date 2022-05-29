//
//  MedicalDrugHtmlParser.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/29.
//

import Foundation
import SwiftSoup

class MedicalDrugHtmlParser {
    private let html: String
    
    init(html: String) {
        self.html = html
    }
    
    func toDrugInfos() -> [DrugInfo] {
        var drugInfoes: [DrugInfo] = []
        
        let docuent: Document = try! SwiftSoup.parse(self.html)
        let resultList = try! docuent.select("#ResultList")[0].select("tr[class^=TrColor]")
        
        resultList.forEach { element in
            let e = try! element.select("td")
            var genericName = ""
            var tradeName = ""
            var company = ""
            var url = ""

            e.enumerated().forEach { index, e in
                switch index {
                case 0:
                    genericName = try! e.select("a[href~=/PmdaSearch/iyakuDetail/GeneralList.+]").text()
                case 1:
                    tradeName = try! e.text()
                case 2:
                    company = try! e.text()
                case 3:
                    url = try! "https://www.pmda.go.jp\(e.select("a[href~=/PmdaSearch/iyakuDetail/ResultDataSetPDF.+]").attr("href"))"
                default: break
                }
            }
            if genericName == "" || url == "" { return }

            let drugInfo = DrugInfo(genericName: genericName, tradeName: tradeName, company: company, url: url)
            drugInfoes.append(drugInfo)
        }
        return drugInfoes
    }
}

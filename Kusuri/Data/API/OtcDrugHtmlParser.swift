//
//  OtcDrugHtmlParser.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/29.
//

import Foundation
import SwiftSoup

class OtcDrugHtmlParser {
    private let html: String
    
    init(html: String) {
        self.html = html
    }
    
    func toDrugInfos() -> [DrugInfo] {
        var drugInfoes: [DrugInfo] = []
        
        let docuent: Document = try! SwiftSoup.parse(html)
        let resultList = try! docuent.select("#ResultList")[0].select("tr[class^=TrColor]")
        
        resultList.forEach { element in
            let e = try! element.select("td")
            let genericName = ""
            var tradeName = ""
            var company = ""
            var url = ""

            e.enumerated().forEach { index, e in
                switch index {
                case 0:
                    tradeName = try! e.select("a[href~=/PmdaSearch/otcDetail/GeneralList.+]").text()
                case 1:
                    company = try! e.text()
                case 2:
                    url = try! "https://www.pmda.go.jp\(e.select("a[href~=/PmdaSearch/otcDetail/ResultDataSetPDF.+]").attr("href"))"
                default: break
                }
            }
            if tradeName == "" || url == "" { return }

            let drugInfo = DrugInfo(genericName: genericName, tradeName: tradeName, company: company, url: url)
            drugInfoes.append(drugInfo)
        }
        return drugInfoes
    }
}

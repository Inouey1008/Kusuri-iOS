//
//  OtcDrugHtmlParser.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/29.
//

import Foundation
import SwiftSoup

final class OtcDrugHtmlParser {
    private let html: String
    
    init(html: String) {
        self.html = html
    }
    
    func toDrugInfos() -> [DrugInfo] {
        var drugInfoes: [DrugInfo] = []
        
        do {
            let docuent: Document = try SwiftSoup.parse(html)
            let resultList = try docuent.select("#ResultList")[0].select("tr[class^=TrColor]")
            
            resultList.forEach { element in
                let element = try! element.select("td")
                let genericName = ""
                var tradeName = ""
                var company = ""
                var url = ""

                element.enumerated().forEach { index, element in
                    switch index {
                    case 0:
                        do {
                            tradeName = try element.select("a[href~=/PmdaSearch/otcDetail/GeneralList.+]").text()
                        } catch {
                            print("!! tradeName error")
                        }
                    case 1:
                        do {
                            company = try element.text()
                        } catch {
                            print("!! company error")
                        }
                    case 2:
                        do {
                            url = try "https://www.pmda.go.jp\(element.select("a[href~=/PmdaSearch/otcDetail/ResultDataSetPDF.+]").attr("href"))"
                        } catch {
                            print("!! url error")
                        }
                    default:
                        break
                    }
                }
                
                if tradeName == "" || url == "" {
                    return
                }

                let drugInfo = DrugInfo(
                    genericName: genericName,
                    tradeName: tradeName,
                    company: company,
                    url: url
                )
                
                drugInfoes.append(drugInfo)
            }
            return drugInfoes
        } catch {
            return drugInfoes
        }
    }
}

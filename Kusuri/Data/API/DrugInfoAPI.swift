//
//  DrugInfoAPI.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/02/08.
//

import Foundation
import RxSwift
import Alamofire
import SwiftSoup

final class DrugInfoAPI {
    static func medicalSearch(_ keyword: String) -> Single<[DrugInfo]> {
        let url = "https://www.pmda.go.jp/PmdaSearch/iyakuSearch/"
        let parameters: [String: Any] = [
            "param1": "value1",
            "param2": "value2",
            "ListRows": 100,
            "btnA.x": 0,
            "btnA.y": 0,
            "nameWord": keyword,
            "iyakuHowtoNameSearchRadioValue": 1,
            "howtoMatchRadioValue": 1,
            "tglOpFlg": "",
            "dispColumnsList[0]": 1,
            "dispColumnsList[1]": 2,
            "dispColumnsList[2]": 3,
            "dispColumnsList[3]": 23,
            "dispColumnsList[4]": 25,
            "dispColumnsList[7]": 4,
            "dispColumnsList[8]": 11,
            "effectValue": "",
            "infoindicationsorefficacy": "",
            "infoindicationsorefficacyHowtoSearch": "and",
            "warnings": "",
            "warningsHowtoSearch": "and",
            "contraindicationsAvoidedadministration": "",
            "contraindicationsAvoidedadministrationHowtoSearch": "and",
            "contraindicatedcombinationPrecautionsforcombination": "",
            "contraindicatedcombinationPrecautionsforcombinationHowtoSearch": "and",
            "updateDocFrDt": "年月日 [YYYYMMDD]",
            "updateDocToDt": "年月日 [YYYYMMDD]",
            "compNameWord": "",
            "iyakuKoumokuSelectSwitchRadio": 2,
            "isNewReleaseDisp": "true",
            "koumoku1Value": "",
            "koumoku1Word": "",
            "koumoku1HowtoSearch": "and",
            "koumoku2Value": "",
            "koumoku2Word": "",
            "koumoku2HowtoSearch": "and",
            "koumoku3Value": "",
            "koumoku3Word": "",
            "koumoku3HowtoSearch": "and",
            "gs1code": "",
            "howtoRdSearchSel": "or",
            "relationDoc1Sel": "",
            "relationDoc1check1": "on",
            "relationDoc1check2": "on",
            "relationDoc1Word": "検索語を入力",
            "relationDoc1HowtoSearch": "and",
            "relationDoc1FrDt": "年月 [YYYYMM]",
            "relationDoc1ToDt": "年月 [YYYYMM]",
            "relationDocHowtoSearchBetween12": "and",
            "relationDoc2Sel": "",
            "relationDoc2check1": "on",
            "relationDoc2check2": "on",
            "relationDoc2Word": "検索語を入力",
            "relationDoc2HowtoSearch": "and",
            "relationDoc2FrDt": "年月 [YYYYMM]",
            "relationDoc2ToDt": "年月 [YYYYMM]",
            "relationDocHowtoSearchBetween23": "and",
            "relationDoc3Sel": "",
            "relationDoc3check1": "on",
            "relationDoc3check2": "on",
            "relationDoc3Word": "検索語を入力",
            "relationDoc3HowtoSearch": "and",
            "relationDoc3FrDt": "年月 [YYYYMM]",
            "relationDoc3ToDt": "年月 [YYYYMM]",
            "listCategory": ""
        ]

        return Single.create { singleEvent in
            let request = AF.request(url, method: .post, parameters: parameters).responseString (completionHandler: { response in
                if let error = response.error {
                    return singleEvent(.failure(error))
                }
                
                var drugInfoes: [DrugInfo] = []
                
                let html = String(data: response.data!, encoding: .utf8) ?? ""
                
                let docuent: Document = try! SwiftSoup.parse(html)
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
                singleEvent(.success(drugInfoes))
            })
            return Disposables.create { request.cancel() }
        }
    }
    
    
    static func otcSearch(_ keyword: String) -> Single<[DrugInfo]> {
        let url = "https://www.pmda.go.jp/PmdaSearch/otcSearch/"
        
        let parameters: [String: Any] = [
            "btnA.x": 0,
            "btnA.y": 0,
            "nameWord": keyword,
            "howtoMatchRadioValue": 1,
            "tglOpFlg": "",
            "dispColumnsList[0]": 1,
            "dispColumnsList[1]": 2,
            "dispColumnsList[2]": 11,
            "dispColumnsList[3]": 6,
            "effectValue": "",
            "txtEffect": "",
            "txtEffectHowtoSearch": "and",
            "cautions": "",
            "cautionsHowtoSearch": "and",
            "updateDocFrDt": "年月日 [YYYYMMDD]",
            "updateDocToDt": "年月日 [YYYYMMDD]",
            "compNameWord": "",
            "dosage": "",
            "ingredient": "",
            "ingredientNotInclude": "",
            "additive": "",
            "additiveNotInclude": "",
            "risk": "",
            "howtoRdSearchSel": "or",
            "relationDoc1Sel": "",
            "relationDoc1check1": "on",
            "relationDoc1check2": "on",
            "relationDoc1Word": "検索語を入力",
            "relationDoc1HowtoSearch": "and",
            "relationDoc1FrDt": "年月 [YYYYMM]",
            "relationDoc1ToDt": "年月 [YYYYMM]",
            "relationDocHowtoSearchBetween12": "and",
            "relationDoc2Sel": "",
            "relationDoc2check1": "on",
            "relationDoc2check2": "on",
            "relationDoc2Word": "検索語を入力",
            "relationDoc2HowtoSearch": "and",
            "relationDoc2FrDt": "年月 [YYYYMM]",
            "relationDoc2ToDt": "年月 [YYYYMM]",
            "relationDocHowtoSearchBetween23": "and",
            "relationDoc3Sel": "",
            "relationDoc3check1": "on",
            "relationDoc3check2": "on",
            "relationDoc3Word": "検索語を入力",
            "relationDoc3HowtoSearch": "and",
            "relationDoc3FrDt": "年月 [YYYYMM]",
            "relationDoc3ToDt": "年月 [YYYYMM]",
            "ListRows": 100,
            "listCategory": ""
        ]

        return Single.create { singleEvent in
            let request = AF.request(url, method: .post, parameters: parameters).responseString (completionHandler: { response in
                if let error = response.error {
                    return singleEvent(.failure(error))
                }
                
                var drugInfoes: [DrugInfo] = []
                
                let html = String(data: response.data!, encoding: .utf8) ?? ""
                
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
                singleEvent(.success(drugInfoes))
            })
            return Disposables.create { request.cancel() }
        }
    }
}

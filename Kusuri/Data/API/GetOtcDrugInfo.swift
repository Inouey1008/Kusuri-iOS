//
//  GetOtcDrugInfo.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/29.
//

import Foundation
import Alamofire

final class GetOtcDrugInfo {
    static func path() -> String {
        return "/otcSearch/"
    }

    static var method: HTTPMethod {
        return .post
    }

    static func parameters(keyword: String) -> [String: Any]? {
        return [
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
    }
}

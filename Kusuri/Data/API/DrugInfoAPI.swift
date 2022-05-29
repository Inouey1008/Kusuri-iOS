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
        let constants = APIConstants.getMedicalInfo(keyword: keyword)
        
        return Single.create { singleEvent in
            let request = AF.request(constants.url, method: constants.method, parameters: constants.parameters).responseString (completionHandler: { response in
                switch response.result {
                case let .success(response):
                    let drugInfoes: [DrugInfo] = MedicalDrugHtmlParser(html: response).toDrugInfos()
                    return singleEvent(.success(drugInfoes))
                case let .failure(error):
                    return singleEvent(.failure(error))
                }
            })
            return Disposables.create { request.cancel() }
        }
    }
    
    
    static func otcSearch(_ keyword: String) -> Single<[DrugInfo]> {
        let constants = APIConstants.getOtcInfo (keyword: keyword)
        
        return Single.create { singleEvent in
            let request = AF.request(constants.url, method: constants.method, parameters: constants.parameters).responseString (completionHandler: { response in
                switch response.result {
                case let .success(response):
                    let drugInfoes: [DrugInfo] = OtcDrugHtmlParser(html: response).toDrugInfos()
                    return singleEvent(.success(drugInfoes))
                case let .failure(error):
                    return singleEvent(.failure(error))
                }
            })
            return Disposables.create { request.cancel() }
        }
    }
}

//
//  APIConstants.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/29.
//

import Foundation
import Alamofire

enum APIConstants {
    case getMedicalInfo(keyword: String)
    case getOtcInfo(keyword: String)

    public var baseURL: String {
        return "https://www.pmda.go.jp/PmdaSearch"
    }

    public var headers: [String: String]? {
        return nil
    }

    public var path: String {
        switch self {
        case .getMedicalInfo:
            return GetMedicalDrugInfo.path()
        case .getOtcInfo:
            return GetOtcDrugInfo.path()
        }
    }
    
    public var url: URL {
        return  URL(string: baseURL + path)!
    }

    public var method: HTTPMethod {
        switch self {
        case .getMedicalInfo:
            return GetMedicalDrugInfo.method
        case .getOtcInfo:
            return GetOtcDrugInfo.method
        }
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case let .getMedicalInfo(keyword):
            return GetMedicalDrugInfo.parameters(keyword: keyword)
        case let .getOtcInfo(keyword):
            return GetOtcDrugInfo.parameters(keyword: keyword)
        }
    }
}

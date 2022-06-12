//
//  TargetType.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/29.
//

import Foundation
import Alamofire

protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

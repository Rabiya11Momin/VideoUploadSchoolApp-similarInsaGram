//
//  CustomError.swift
//  swiftMVVM
//
//  Created by Rabiya on 4/6/22.
//  Copyright © 2022 Rabia Momin. All rights reserved.
//

import Foundation
enum CustomError {
    case noConnection, noData
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData: return "Well, weird thing happens"
        case .noConnection: return "No Internet Connection"
        }
    }
}

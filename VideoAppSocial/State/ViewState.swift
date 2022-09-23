//
//  ViewState.swift
//  swiftMVVM
//
//  Created by Rabiya on 4/6/22.
//  Copyright © 2022 Rabia Momin. All rights reserved.
//

import Foundation

enum ViewState {
    case idle
    case loading
    case success
    case error(Error)
}

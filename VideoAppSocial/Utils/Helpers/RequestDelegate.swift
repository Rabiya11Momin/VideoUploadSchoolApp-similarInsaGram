//
//  RequestDelegate.swift
//  swiftMVVM
//
//  Created by Rabiya on 4/6/22.
//  Copyright © 2022 Rabia Momin. All rights reserved.
//

import Foundation

protocol RequestDelegate: AnyObject {
    func didUpdate(with state: ViewState)
}

//
//  MyVideoModel.swift
//  VideoAppSocial
//
//  Created by Rabiya on 9/4/22.
//

import Foundation

class MyVideoModel: NSObject{



}
extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}

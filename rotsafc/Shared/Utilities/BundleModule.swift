//
//  BundleModule.swift
//  rotsafc
//
//  Created by Mac on 03/11/26.
//

import Foundation

extension Bundle {
    #if !SWIFT_PACKAGE
    static var module: Bundle { .main }
    #endif
}


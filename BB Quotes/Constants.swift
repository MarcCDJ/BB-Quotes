//
//  Constants.swift
//  BB Quotes
//
//  Created by Marc Cruz on 7/30/23.
//

import Foundation

extension String {
    var replaceSpaceWithPlus: String {
        self.replacingOccurrences(of: " ", with: "+")
    }
}

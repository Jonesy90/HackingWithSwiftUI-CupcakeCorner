//
//  String-EmptyChecking.swift
//  HackingWithSwiftUI-CupcakeCorner
//
//  Created by Michael Jones on 23/06/2026.
//

import Foundation

extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

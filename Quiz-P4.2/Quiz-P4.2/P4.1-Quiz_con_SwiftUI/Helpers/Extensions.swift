//
//  Extensions.swift
//  P4.1-Quiz_con_SwiftUI
//
//  Created by c134 DIT UPM on 15/11/23.
//

import Foundation

extension String: LocalizedError{
    public var errorDescription: String?{
        return self
    }
}

//
//  IntGenerator.swift
//  MaxibonKataIOSTests
//
//  Created by Alberto on 28/9/18.
//  Copyright © 2018 GoKarumi. All rights reserved.
//

import Foundation
import SwiftCheck
@testable import MaxibonKataIOS

extension Int: Arbitrary {
    public static var arbitraryPositiveInteger: Gen<Int> {
        return Gen<Int>.fromElements(in: 1...Int.max).map {
            return $0
        }
    }
    
    public static var negativePositiveInteger: Gen<Int> {
        return Gen<Int>.fromElements(in: -Int.max...0).map {
            return $0
        }
    }
}

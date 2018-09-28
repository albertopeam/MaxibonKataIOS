//
//  DeveloperSpecs.swift
//  MaxibonKataIOSTests
//
//  Created by Alberto on 28/9/18.
//  Copyright © 2018 GoKarumi. All rights reserved.
//

import XCTest
import SwiftCheck
@testable import MaxibonKataIOS

class DeveloperSpecs: XCTestCase {
    
    func testAll() {
        //This spec is only to understand the API
        //This code is executed 100 by default
        property("The name is asigned in construction") <- forAll { (name: String) in
            print(name)
            let dev = Developer(name: name, numberOfMaxibonsToGet: 0)
            return dev.name == name
        }
        
        //This spec is only to understand the API
        //Check that the comparison is not an exact matching, the rules specify that the numbers of maxibons is always 0 or more than 0
        //Sin generadores
        property("The number of maxibons is asigned in construction") <- forAll { (numMaxibons: Int) in
            print(numMaxibons)
            let dev = Developer(name: "", numberOfMaxibonsToGet: numMaxibons)
            return dev.numberOfMaxibonsToGet >= numMaxibons
        }
        
        // Spec generator always greater than 0
        property("The number of maxibons is always more than 0") <- forAll(Int.arbitraryPositiveInteger) { (numMaxibons: Int) in
            print(numMaxibons)
            let dev = Developer(name: "", numberOfMaxibonsToGet: numMaxibons)
            return dev.numberOfMaxibonsToGet > 0
        }
        
        // Spec generator always less than 0
        property("The number of maxibons is asigned is always 0") <- forAll(Int.negativePositiveInteger) { (numMaxibons: Int) in
            print(numMaxibons)
            let dev = Developer(name: "", numberOfMaxibonsToGet: numMaxibons)
            return dev.numberOfMaxibonsToGet == 0
        }
        
        property("The number of maxibons at week start is always 10") <- forAll(Developer.arbitrary) { (developer: Developer) in
            print(developer)
            let hq = KarumiHQs()
            return hq.maxibonsLeft == 10
        }
        
        property("The number of maxibons at week start is always 10") <- forAll(Developer.arbitrary) { (developer: Developer) in
            print(developer)
            let hq = KarumiHQs()
            hq.openFridge(developer)
            return hq.maxibonsLeft > 2
        }
        
        property("If some karumies go to the kitchen the number of maxibons has to be correct") <- forAll { (developers: ArrayOf<Developer>) in
            print(developers)
            let hq = KarumiHQs()
            hq.openFridge(developers.getArray)
            //TODO: check that the number is correct(not only > 2), see solution in master. MAYBE NOT GOOD IDEA TO WRITE EXACT VALIDATIONS. THIS KIND OF TESTS ARE NOT DETERMINIST
            return hq.maxibonsLeft > 2
        }
        
        property("If one developer is hungry and take more than 8 maxibons then chat must be called") <- forAll(Developer.arbitraryHungry) { (developer: Developer) in
            print(developer)
            let spyChat = SpyChat()//BE CAREFULL, THIS SPY MUST BE USED HERE, BECAUSE THE BLOCK IS INVOKED N TIMES FOR EACH PROPERTY, SO THE SPY WILL BE THE SAME ALWAYS IF WE DECLARE IT AT CLASS LEVEL
            let hq = KarumiHQs(chat: spyChat)
            hq.openFridge(developer)
            return spyChat.message == "Hi guys, I'm \(developer). We need more maxibons!" && spyChat.numInvocations == 1
        }
        
        property("If one developer is NOT hungry and take less than 8 maxibons then chat must NOT be called") <- forAll(Developer.arbitraryNotSoHungry) { (developer: Developer) in
            print(developer)
            let spyChat = SpyChat()//BE CAREFULL, THIS SPY MUST BE USED HERE, BECAUSE THE BLOCK IS INVOKED N TIMES FOR EACH PROPERTY, SO THE SPY WILL BE THE SAME ALWAYS IF WE DECLARE IT AT CLASS LEVEL
            let hq = KarumiHQs(chat: spyChat)
            hq.openFridge(developer)
            return spyChat.message == nil && spyChat.numInvocations == 0
        }
        
        //TODO: "If N developers open fridge then chat must NOT be called"
        //The message isnot send for N dev
        //NOT EASY/NOT POSSIBLE TO TEST
    }
    
}

class SpyChat: Chat {
    
    var message: String?
    var numInvocations = 0
    
    func send(message: String) {
        self.message = message
        numInvocations += 1
    }
}

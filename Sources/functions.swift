//
//  functions.swift
//  publisher-daemon
//
//  Created by Stephen Brimhall on 11/5/16.
//
//

import Foundation

// Define constants
let AUTHORIZED_IDS = ["0","2003"];

/// Checks to see if user is authorized
public func authorized(_ groupIds: [UInt8]) -> Bool {
    let data = Data(groupIds);
    if let string = String(data: data, encoding: String.Encoding.ascii) {
        let stringArray = string.characters.split(separator: " ").map(String.init);
        for id in stringArray {
            for authId in AUTHORIZED_IDS {
                if id == authId {
                    return true;
                }
            }
        }
    }
    return false;
}

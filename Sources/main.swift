//
//  main.swift
//  publisher-daemon
//
//  Copyright (c) Stephen Brimhall 2016.
//  All rights reserved.
//
//

import Foundation;
import Socks;
import SwiftShell;

typealias Byte=UInt8;
// Define constants
let AUTHORIZED_IDS = ["2003"];

// Define command functions
let publish = { (_ bytes: [Byte]) -> [Byte] in
    let data = Data(bytes);
    if let string = String(data: data, encoding: String.Encoding.ascii) {
        let stringArray = string.characters.split(separator: " ").map(String.init);
        for id in stringArray {
            for authId in AUTHORIZED_IDS {
                if id == authId {
                    let _ = run("/usr/local/bin/website-update.sh");
                    return [6,4];
                }
            }
        }
    }
    return [21,4];
}

let upload = { (_ bytes: [Byte]) -> [Byte] in
    return [0,4];
}


// Define array of commands
let commands : [Byte: ([Byte])->[Byte]] = [
    0b00000000 : publish,
    0b00000001 : upload
];

// Let the user know the program has started
print("Waiting for connection...");

let clientReciever = { (_ client: TCPClient) in
    do {
        print("Attempting to recieve data");
        var data = try client.receiveAll();
        print("Attempting to close connection");

        
        print(data);
        
        if data.count < 1 {
            return;
        }
        
        print("Attempting to run command");
        if let command = commands[data[0]] {
            data.remove(at: 0);
            try client.send(bytes: command(data));
        }
        try client.close();
    } catch {
        
    }
}

do {
    // Attempt to create a server
    let server = try SynchronousTCPServer(port: 12345);
    
    // If server creation successful, attempt to start server.
    try server.startWithHandler( handler: clientReciever );
}  catch {
    // If server creation or server initialization fails, print error and exit.
    print("Error: server failed");
    exit(1);
}

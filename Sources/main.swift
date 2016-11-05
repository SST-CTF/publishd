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

// Define command functions
let publish = {
    let _ = run("cd /var/www/html && sudo git stash && sudo git stash drop && sudo git pull");
}

let upload = {
    
}


// Define array of commands
let commands : [UInt8: ()->Void] = [
    0b00000000 : publish,
    0b00000001 : upload
];

// Let the user know the program has started
print("Waiting for connection...");

let clientReciever = { (_ client: TCPClient) in
    do {
        print("Attempting to recieve data");
        let data = try client.receiveAll();
        print("Attempting to close connection");
        try client.close();
        
        if data.count < 1 {
            return;
        }
        
        print("Attempting to run command");
        if let command = commands[data[0]] {
            command();
        }
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

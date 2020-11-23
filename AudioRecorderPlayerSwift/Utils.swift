//
//  Utils.swift
//  AudioRecorderPlayerSwift
//
//  Created by Max Harris on 11/6/20.
//

import Foundation

func check(_ status: OSStatus, file: String = #file, function: String = #function, line: Int = #line) {
    if status != 0 {
        print("OSStatus: \(status)\ncaller: \(function)\n\(file):\(line)")
        exit(1)
    }
}

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

func makeWave(duration: Float64) {
    let SAMPLE_RATE: Float64 = 44100
    let frequency: Float64 = 440.0
    let wavelengthInSamples = SAMPLE_RATE / frequency
    var sampleCount: CLong = 0

    while sampleCount < Int(SAMPLE_RATE * duration) {
        for i in 0 ... Int(wavelengthInSamples) {
            let sample = Int16(Double(Int16.max) * sin(2 * Double.pi * (Double(i) / wavelengthInSamples))).byteSwapped
            audioData.append(sample)
            sampleCount += 1
        }
    }
}

func makeNoise() {
    for _ in 0 ..< frameCount {
        let sample = Int16.random(in: Int16.min ... Int16.max)
        audioData.append(sample)
    }
}

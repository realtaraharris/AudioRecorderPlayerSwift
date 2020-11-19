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

func makeWave(duration: Float64, frequency: Float64) {
    let wavelengthInSamples = SAMPLE_RATE / frequency
    var sampleCount: CLong = 0

    while sampleCount < Int(SAMPLE_RATE * duration) {
        for i in 0 ... Int(wavelengthInSamples) {
            // let sample = Int16(((Double(i) / wavelengthInSamples) * Double(Int16.max) * 2) - Double(Int16.max))
            // let sample: Int16 = (i < Int(wavelengthInSamples) / 2 ? Int16.max : Int16.min)
            let sample = Int16(Double(Int16.max) * sin(2 * Double.pi * (Double(i) / wavelengthInSamples)))
            audioData.append(sample)
            sampleCount += 1
        }
    }
}

func makeNoise(frameCount: Int) {
    for _ in 0 ..< frameCount {
        let sample = Int16.random(in: Int16.min ... Int16.max)
        audioData.append(sample)
    }
}

//
//  WaveGenerator.swift
//  AudioRecorderPlayerSwift
//
//  Created by Max Harris on 11/23/20.
//

import Foundation

struct WaveGuide {
    var offset: Double
    var duration: Double
    var sampleRate: Float64
    var frequency: Float64
    var channelCount: Int
    var leftOffset: Double
    var rightOffset: Double
}

func multiBeep(waveGuide: inout WaveGuide, frequencies: [Double], multiplier: Double) {
    for frequency in frequencies {
        waveGuide.frequency = frequency * multiplier
        audioData += generateWave(waveGuide)
    }
}

func generateSong(waveGuide: inout WaveGuide) {
    for _ in 0 ..< 2 {
        waveGuide.rightOffset = 0
        multiBeep(waveGuide: &waveGuide, frequencies: [64, 96, 128, 96], multiplier: 2.0)
//        waveGuide.rightOffset = Double.pi
        multiBeep(waveGuide: &waveGuide, frequencies: [64, 96, 128, 96], multiplier: 4.0)
    }
}

func generateSong2(waveGuide: inout WaveGuide) {
    for _ in 0 ..< 2 {
        waveGuide.rightOffset = 0
        multiBeep(waveGuide: &waveGuide, frequencies: [64, 96, 128, 96], multiplier: 1.77)
        waveGuide.rightOffset = 0
        multiBeep(waveGuide: &waveGuide, frequencies: [64, 96, 128, 96], multiplier: 4.0)
    }
}

func generateWave(_ waveGuide: WaveGuide) -> [Int16] {
    var wave = [Int16]()
    for frameIndex in 0 ..< Int((waveGuide.duration * waveGuide.sampleRate) / Double(waveGuide.channelCount)) {
        let time = waveGuide.offset + Double(frameIndex) / waveGuide.sampleRate
        let sampleL = Double(Int16.max) * sin(2 * Double.pi * waveGuide.frequency * time + waveGuide.leftOffset)
        wave.append(Int16(sampleL))
        let sampleR = Double(Int16.max) * sin(2 * Double.pi * waveGuide.frequency * time + waveGuide.rightOffset)
        wave.append(Int16(sampleR))
    }
    return wave
}

func generateNoise(frameCount: Int) {
    for _ in 0 ..< frameCount {
        let sample = Int16.random(in: Int16.min ... Int16.max)
        audioData.append(sample)
    }
}

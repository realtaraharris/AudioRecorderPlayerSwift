//
//  main.swift
//  AudioRecorderPlayerSwift
//
//  Created by Max Harris on 11/6/20.
//

import AudioToolbox
import Foundation

var audioData: [Int16] = []

let CHANNEL_COUNT = 2
let BUFFER_DURATION: Double = 0.1
let SAMPLE_RATE: Float64 = 44100.0
let BUFFER_COUNT = 3
let BYTES_PER_FRAME = UInt32(MemoryLayout<Int16>.size * CHANNEL_COUNT)
let FRAMES_PER_PACKET: UInt32 = 1

var audioFormat = AudioStreamBasicDescription(
    mSampleRate: SAMPLE_RATE,
    mFormatID: kAudioFormatLinearPCM,
    mFormatFlags: kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked,
    mBytesPerPacket: BYTES_PER_FRAME * FRAMES_PER_PACKET,
    mFramesPerPacket: FRAMES_PER_PACKET,
    mBytesPerFrame: BYTES_PER_FRAME,
    mChannelsPerFrame: UInt32(CHANNEL_COUNT),
    mBitsPerChannel: UInt32(8 * MemoryLayout<Int16>.size),
    mReserved: 0
)

// PCM buffer size: sample rate * number of channels * bytes per channel * duration of the buffer
let bufferByteSize: Int = Int(Double(Int(SAMPLE_RATE) * CHANNEL_COUNT * MemoryLayout<Int16>.size) * BUFFER_DURATION)

var waveGuide = WaveGuide(offset: 0, duration: 0.25, sampleRate: SAMPLE_RATE, frequency: 0, channelCount: CHANNEL_COUNT, leftOffset: 0.0, rightOffset: 0)

// generateSong(waveGuide: &waveGuide)
// makeNoise(frameCount: Int(44100.0 * 30))
_ = Recorder()
_ = Player()

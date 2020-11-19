//
//  main.swift
//  AudioRecorderPlayerSwift
//
//  Created by Max Harris on 11/6/20.
//

import AudioToolbox
import Foundation

var audioData: [Int16] = []

let NUM_CHANNELS = 2
let BUFFER_DURATION: Double = 0.25
let SAMPLE_RATE: Float64 = 44100.0
let BUFFER_COUNT = 3

var audioFormat = AudioStreamBasicDescription()
audioFormat.mSampleRate = SAMPLE_RATE
audioFormat.mFormatID = kAudioFormatLinearPCM
audioFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
audioFormat.mBitsPerChannel = UInt32(8 * MemoryLayout<Int16>.size)
audioFormat.mChannelsPerFrame = UInt32(NUM_CHANNELS)
audioFormat.mFramesPerPacket = 1
audioFormat.mBytesPerFrame =  UInt32(MemoryLayout<Int16>.size * NUM_CHANNELS)
audioFormat.mBytesPerPacket = audioFormat.mBytesPerFrame * audioFormat.mFramesPerPacket
audioFormat.mReserved = 0 // tweak for alignment to 8-bit bytes. always set this to 0

// PCM buffer size: sample rate * number of channels * bytes per channel * duration of the buffer
let bufferByteSize: Int = Int(Double(Int(audioFormat.mSampleRate) * NUM_CHANNELS * MemoryLayout<Int16>.size) * BUFFER_DURATION)

makeWave(duration: 30.0, frequency: 441.0)
//makeNoise(frameCount: Int(44100.0 * 30))
//_ = Recorder()
_ = Player()

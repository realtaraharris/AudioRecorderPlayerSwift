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

var audioFormat = AudioStreamBasicDescription()
audioFormat.mSampleRate = SAMPLE_RATE
audioFormat.mFormatID = kAudioFormatLinearPCM
audioFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
audioFormat.mBitsPerChannel = UInt32(8 * MemoryLayout<Int16>.size)
audioFormat.mChannelsPerFrame = UInt32(CHANNEL_COUNT)
audioFormat.mFramesPerPacket = 1
audioFormat.mBytesPerFrame = UInt32(MemoryLayout<Int16>.size * CHANNEL_COUNT)
audioFormat.mBytesPerPacket = audioFormat.mBytesPerFrame * audioFormat.mFramesPerPacket
audioFormat.mReserved = 0 // tweak for alignment to 8-bit bytes. always set this to 0

// PCM buffer size: sample rate * number of channels * bytes per channel * duration of the buffer
let bufferByteSize: Int = Int(Double(Int(audioFormat.mSampleRate) * CHANNEL_COUNT * MemoryLayout<Int16>.size) * BUFFER_DURATION)

var waveGuide = WaveGuide(offset: 0, duration: 0.25, sampleRate: SAMPLE_RATE, frequency: 0, channelCount: CHANNEL_COUNT, leftOffset: 0.0, rightOffset: 0)

// generateSong(waveGuide: &waveGuide)
// makeNoise(frameCount: Int(44100.0 * 30))
_ = Recorder()
_ = Player()

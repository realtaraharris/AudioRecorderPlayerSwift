//
//  main.swift
//  AudioRecorderPlayerSwift
//
//  Created by Max Harris on 11/6/20.
//

import AudioToolbox
import Foundation

var audioData: [Int16] = []

var audioFormat = AudioStreamBasicDescription()
audioFormat.mSampleRate = 44100
audioFormat.mFormatID = kAudioFormatLinearPCM
audioFormat.mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
audioFormat.mBytesPerPacket = 2
audioFormat.mFramesPerPacket = 1
audioFormat.mBytesPerFrame = 2
audioFormat.mChannelsPerFrame = 1
audioFormat.mBitsPerChannel = 16
audioFormat.mReserved = 0 // tweak for alignment to 8-bit bytes. always set this to 0

// PCM buffer size: sample rate * number of channels * bytes per channel * duration of the buffer
let bufferByteSize: UInt32 = 22050
let frameCount = 66150

//makeWave()
//makeNoise()

_ = Recorder()
_ = Player()

//
//  Recorder.swift
//  AudioRecorderPlayerSwift
//
//  Created by Max Harris on 11/6/20.
//

import AudioToolbox
import Foundation

func inputCallback(inUserData: UnsafeMutableRawPointer?, inQueue: AudioQueueRef, inBuffer: AudioQueueBufferRef, inStartTime _: UnsafePointer<AudioTimeStamp>, inNumPackets: UInt32, inPacketDesc: UnsafePointer<AudioStreamPacketDescription>?) {
    guard let recorder = inUserData?.assumingMemoryBound(to: Recorder.RecordingState.self) else {
        return
    }

    let numBytes: Int = Int(inBuffer.pointee.mAudioDataBytesCapacity)
    let int16Ptr = inBuffer.pointee.mAudioData.bindMemory(to: Int16.self, capacity: numBytes)
    let int16Buffer = UnsafeBufferPointer(start: int16Ptr, count: numBytes)

    audioData.append(contentsOf: Array(int16Buffer))

    recorder.pointee.packetPosition += inNumPackets

    // re-enqueue the used buffer
    if recorder.pointee.running {
        check(AudioQueueEnqueueBuffer(inQueue, inBuffer, 0, inPacketDesc))
    }
}

struct Recorder {
    let bufferCount = 3

    struct RecordingState {
        var packetPosition: UInt32 = 0
        var running: Bool = false
    }

    init() {
        var recordingState: RecordingState = RecordingState()
        var queue: AudioQueueRef?

        check(AudioQueueNewInput(&audioFormat, inputCallback, &recordingState, nil, nil, 0, &queue))

        for _ in 0 ..< bufferCount {
            var buffer: AudioQueueBufferRef?
            check(AudioQueueAllocateBuffer(queue!, bufferByteSize, &buffer))
            check(AudioQueueEnqueueBuffer(queue!, buffer!, 0, nil))
        }

        recordingState.running = true
        check(AudioQueueStart(queue!, nil))

        print("Recording - press a key to stop")
        getchar() // block on stdin while recording
        print("Recording complete")
        recordingState.running = false
        check(AudioQueueStop(queue!, true))
        check(AudioQueueDispose(queue!, true))
    }
}

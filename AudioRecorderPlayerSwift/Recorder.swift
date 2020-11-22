//
//  Recorder.swift
//  AudioRecorderPlayerSwift
//
//  Created by Max Harris on 11/6/20.
//

import AudioToolbox
import Foundation

func inputCallback(inUserData: UnsafeMutableRawPointer?, inQueue: AudioQueueRef, inBuffer: AudioQueueBufferRef, inStartTime _: UnsafePointer<AudioTimeStamp>, inNumPackets _: UInt32, inPacketDesc _: UnsafePointer<AudioStreamPacketDescription>?) {
    guard let recorder = inUserData?.assumingMemoryBound(to: Recorder.RecordingState.self) else {
        return
    }

    let bytesPerChannel = MemoryLayout<Int16>.size
    let numBytes: Int = Int(inBuffer.pointee.mAudioDataByteSize) / bytesPerChannel

    let int16Ptr = inBuffer.pointee.mAudioData.bindMemory(to: Int16.self, capacity: numBytes)
    let int16Buffer = UnsafeBufferPointer(start: int16Ptr, count: numBytes)

    audioData.append(contentsOf: int16Buffer)

    // enqueue the buffer, or re-enqueue it if it's a used one
    if recorder.pointee.running {
        check(AudioQueueEnqueueBuffer(inQueue, inBuffer, 0, nil))
    }
}

struct Recorder {
    struct RecordingState {
        var running: Bool = false
    }

    init() {
        var recordingState: RecordingState = RecordingState()
        var queue: AudioQueueRef?

        check(AudioQueueNewInput(&audioFormat, inputCallback, &recordingState, nil, nil, 0, &queue))

        for _ in 0 ..< BUFFER_COUNT {
            var buffer: AudioQueueBufferRef?
            check(AudioQueueAllocateBuffer(queue!, UInt32(bufferByteSize), &buffer))
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

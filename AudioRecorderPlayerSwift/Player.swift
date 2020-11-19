//
//  Player.swift
//  AudioRecorderPlayerSwift
//
//  Created by Max Harris on 11/6/20.
//

import AudioToolbox
import Foundation

var lastIndexRead: Int = 0

func outputCallback(inUserData: UnsafeMutableRawPointer?, inAQ: AudioQueueRef, inBuffer: AudioQueueBufferRef) {
    guard let player = inUserData?.assumingMemoryBound(to: Player.PlayingState.self) else {
        print("missing user data in output callback")
        return
    }

    let sliceStart = lastIndexRead
    let sliceEnd = min(audioData.count, lastIndexRead + bufferByteSize - 1)
    print("slice start:", sliceStart, "slice end:", sliceEnd, "audioData.count", audioData.count)

    if sliceEnd >= audioData.count {
        player.pointee.running = false
        print("found end of audio data")
        return
    }

    let slice = Array(audioData[sliceStart ..< sliceEnd])
    let sliceCount = slice.count

    // doesn't fix it
    // audioData[sliceStart ..< sliceEnd].withUnsafeBytes {
    //     inBuffer.pointee.mAudioData.copyMemory(from: $0.baseAddress!, byteCount: Int(sliceCount))
    // }

    memcpy(inBuffer.pointee.mAudioData, slice, sliceCount)
    inBuffer.pointee.mAudioDataByteSize = UInt32(sliceCount)
    lastIndexRead += sliceCount + 1

    // enqueue the buffer, or re-enqueue it if it's a used one
    check(AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil))
}

struct Player {
    struct PlayingState {
        var packetPosition: UInt32 = 0
        var running: Bool = false
        var start: Int = 0
        var end: Int = Int(bufferByteSize)
    }

    init() {
        var playingState: PlayingState = PlayingState()
        var queue: AudioQueueRef?

        // this doesn't help
        // check(AudioQueueNewOutput(&audioFormat, outputCallback, &playingState, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue, 0, &queue))

        check(AudioQueueNewOutput(&audioFormat, outputCallback, &playingState, nil, nil, 0, &queue))

        var buffers: [AudioQueueBufferRef?] = Array<AudioQueueBufferRef?>.init(repeating: nil, count: BUFFER_COUNT)

        print("Playing\n")
        playingState.running = true

        for i in 0 ..< BUFFER_COUNT {
            check(AudioQueueAllocateBuffer(queue!, UInt32(bufferByteSize), &buffers[i]))
            outputCallback(inUserData: &playingState, inAQ: queue!, inBuffer: buffers[i]!)

            if !playingState.running {
                break
            }
        }

        check(AudioQueueStart(queue!, nil))

        repeat {
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, BUFFER_DURATION, false)
        } while playingState.running

        // delay to ensure queue emits all buffered audio
        CFRunLoopRunInMode(CFRunLoopMode.defaultMode, BUFFER_DURATION * Double(BUFFER_COUNT + 1), false)

        check(AudioQueueStop(queue!, true))
        check(AudioQueueDispose(queue!, true))
    }
}

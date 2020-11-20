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

    let bytesPerChannel = MemoryLayout<Int16>.size
    let sliceStart = lastIndexRead
    let sliceEnd = min(audioData.count, lastIndexRead + bufferByteSize / bytesPerChannel)

    if sliceEnd >= audioData.count {
        player.pointee.running = false
        print("found end of audio data")
        return
    }

    let slice = Array(audioData[sliceStart ..< sliceEnd])
    let sliceCount = slice.count

    // print("slice start:", sliceStart, "slice end:", sliceEnd, "audioData.count", audioData.count, "slice count:", sliceCount)

    // need to be careful to convert from counts of Ints to bytes
    memcpy(inBuffer.pointee.mAudioData, slice, sliceCount * bytesPerChannel)
    inBuffer.pointee.mAudioDataByteSize = UInt32(sliceCount * bytesPerChannel)
    lastIndexRead += sliceCount

    // enqueue the buffer, or re-enqueue it if it's a used one
    check(AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil))
}

struct Player {
    struct PlayingState {
        var running: Bool = false
    }

    init() {
        var playingState: PlayingState = PlayingState()
        var queue: AudioQueueRef?

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

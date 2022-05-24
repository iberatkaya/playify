package com.kaya.playify.playify.Classes

enum class PlayerStatus(val value: Int) {
    stopped(0),
    playing(1),
    paused(2),
    interrupted(3),
    seekingForward(4),
    seekingBackward(5),
    unknown(6)
}
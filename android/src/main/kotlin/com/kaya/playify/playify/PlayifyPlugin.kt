package com.kaya.playify.playify

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** PlayifyPlugin */
class PlayifyPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var applicationContext: Context? = null
    private var eventSink: EventChannel.EventSink? = null


    private var playifyPlayer = PlayifyPlayer()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.kaya.playify/playify")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "com.kaya.playify/playify_status")
        eventChannel.setStreamHandler(this)
        val intentFilter = IntentFilter()
        intentFilter.addAction("android.media.VOLUME_CHANGED_ACTION")
        intentFilter.addAction("com.android.music.metachanged")
        intentFilter.addAction("com.android.music.playstatechanged")
        intentFilter.addAction("com.android.music.playbackcomplete")
        intentFilter.addAction("com.android.music.queuechanged")
        intentFilter.addAction("my_service")
        //ContextWrapper(applicationContext).registerReceiver(lis, intentFilter)
        val intent: Intent = Intent(
            applicationContext,
            PlayifyPlayer::class.java
        )
        applicationContext!!.startService(intent)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getAllSongs") {
            val songs = applicationContext?.let {
                playifyPlayer.getAllSongs(it)
            }

            result.success(
                songs?.map {
                    it.toMap()
                }?.toList()
            )
        } else if (call.method == "playItem") {
            val id = call.argument<String>("songID")

            id?.let { id ->
                applicationContext?.let {
                    val res = playifyPlayer.playItem(context = it, id = id, modifyQueue = true)
                    result.success(res)
                }
            } ?: run {
                result.error("ArgumentError", "Argument id was not provided!", null)
            }
        } else if (call.method == "getVolume") {
            applicationContext?.let {
                val vol = playifyPlayer.getVolume(it)
                result.success(vol)
            }
        } else if (call.method == "setVolume") {
            val amount = call.argument<Double>("volume")

            amount?.let { volumeAmount ->
                applicationContext?.let {
                    playifyPlayer.setVolume(it, volumeAmount)
                    result.success(null)
                }
            } ?: run {
                result.error("ArgumentError", "Argument volume was not provided!", null)
            }
        } else if (call.method == "play") {
            playifyPlayer.play()
        } else if (call.method == "pause") {
            playifyPlayer.pause()
        } else if (call.method == "setQueue") {
            val songIDs = call.argument<ArrayList<String>>("songIDs")
            val startID = call.argument<String>("startID")
            val startPlaying = call.argument<Boolean>("startPlaying")

            songIDs?.let { ids ->
                applicationContext?.let {
                    playifyPlayer.setQueue(it, ids, startID, startPlaying)
                }
            } ?: run {
                result.error("ArgumentError", "Argument songIDs was not provided!", null)
            }
        } else if (call.method == "getPlaybackTime"){
            val duration = playifyPlayer.getPlaybackTime()
            result.success(duration)
        } else if (call.method == "setPlaybackTime"){
            val time = call.argument<Double>("time")

            time?.let {
                    playifyPlayer.setPlaybackTime(it.toInt())
            } ?: run {
                result.error("ArgumentError", "Argument time was not provided!", null)
            }
        } else if (call.method == "nowPlaying") {
            val song = playifyPlayer.nowPlaying()
            song?.let {
                result.success(it.toMap())
            } ?: run {
                result.error("PlayerError", "An error occurred when fetching song information", null)
            }
        } else if (call.method == "next") {
            applicationContext?.let {
                playifyPlayer.next(it)
            }
        } else if (call.method == "previous") {
            applicationContext?.let {
                playifyPlayer.previous(it)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events
        playifyPlayer.statusStream = {
            println(it.value)
            eventSink?.success(it.value)
        }
    }

    override fun onCancel(arguments: Any?) {
        playifyPlayer.statusStream = null
        eventSink = null
    }
}

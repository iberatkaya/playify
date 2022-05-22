package com.kaya.playify.playify

import android.app.*
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.graphics.BitmapFactory
import android.graphics.Color
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import android.provider.MediaStore
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import com.kaya.playify.playify.Classes.Song
import java.nio.ByteBuffer
import java.util.*
import kotlin.Exception
import kotlin.collections.ArrayList


abstract class SongListener {
    abstract fun onSongChange(song: String);
}

class PlayifyPlayer: Service() {
    val player = MediaPlayer().apply {
//        setWakeMode(applicationContext, PowerManager.PARTIAL_WAKE_LOCK)
    }

    private lateinit var callback: SongListener

    fun setListener(callback: SongListener) {
        this.callback = callback;
    }

    private var songQueue: ArrayList<Song> = ArrayList<Song>()
    private var queueIndex: Int? = null

    private fun getSongFromMediaStore(context: Context, id: String): Song? {
        val selection = MediaStore.Audio.Media._ID + " == " + id

        val projection = arrayOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.DATA,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.YEAR,
            MediaStore.Audio.Media.TRACK,
        )

        val genresProjection = arrayOf(
            MediaStore.Audio.Genres.NAME
        )

        val albumArtProjection = arrayOf(
            MediaStore.Audio.Albums.ALBUM_ART
        )

        val cursor: Cursor? = context?.getContentResolver()?.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            projection,
            selection,
            null,
            null
        )

        if (cursor != null) {
            while (cursor.moveToNext()) {
                val id = cursor.getString(0)
                val artist = cursor.getString(1)
                val albumTitle = cursor.getString(2)
                val songTitle = cursor.getString(3)
                val path = cursor.getString(4)
                val playbackDuration = cursor.getString(5)
                val releaseYearStr = cursor.getString(6)
                val trackStr = cursor.getString(7)
                val track = Integer.parseInt(trackStr)
                val calendar = Calendar.getInstance()

                var releaseYear: Long? = null;
                if (releaseYearStr != null) {
                    calendar.set(Integer.parseInt(releaseYearStr), 0, 1)
                    releaseYear = calendar.timeInMillis
                }

                val song = Song(
                    albumTitle = albumTitle,
                    artist = artist,
                    songTitle = songTitle,
                    path = path,
                    playbackDuration = playbackDuration.toDoubleOrNull(),
                    releaseDate = releaseYear,
                    trackNumber = track,
                    songID = id,
                )

                val albumArtCursor: Cursor? = context?.getContentResolver()?.query(
                    MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                    albumArtProjection,
                    null,
                    null,
                    null
                )

                albumArtCursor?.moveToNext()

                val albumArt = albumArtCursor?.getString(0)

                var typedIntArray: Array<Int>? = null

                if (albumArt != null) {
                    val bitmap = BitmapFactory.decodeFile(albumArt)

                    val size: Int = bitmap.getRowBytes() * bitmap.getHeight()
                    val byteBuffer: ByteBuffer = ByteBuffer.allocate(size)
                    bitmap.copyPixelsToBuffer(byteBuffer)
                    val intBuffer = byteBuffer.asIntBuffer()
                    val intArray = IntArray(intBuffer.limit())

                    intBuffer.get(intArray)
                    typedIntArray = intArray.toTypedArray()
                }

                song.image = typedIntArray

                //Get the genre
                val genreUri = MediaStore.Audio.Genres.getContentUriForAudioId(
                    "external",
                    Integer.parseInt(id)
                )

                val genreCursor: Cursor? = context?.getContentResolver()?.query(
                    genreUri,
                    genresProjection,
                    null,
                    null,
                    null
                )

                genreCursor?.moveToNext()

                val genreName = genreCursor?.getString(0)
                song.genre = genreName

                genreCursor?.close()

                return song
            }
        }

        return null
    }

    fun getAllSongs(context: Context): Array<Song> {
        var songs = ArrayList<Song>()
        val selection = MediaStore.Audio.Media.IS_MUSIC + " != 0"

        val projection = arrayOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.DATA,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.YEAR,
            MediaStore.Audio.Media.TRACK,
        )

        val genresProjection = arrayOf(
            MediaStore.Audio.Genres.NAME
        )

        val albumArtProjection = arrayOf(
            MediaStore.Audio.Albums.ALBUM_ART
        )

        val cursor: Cursor? = context?.getContentResolver()?.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            projection,
            selection,
            null,
            null
        )

        if (cursor != null) {
            while (cursor.moveToNext()) {
                val id = cursor.getString(0)
                val artist = cursor.getString(1)
                val albumTitle = cursor.getString(2)
                val songTitle = cursor.getString(3)
                val path = cursor.getString(4)
                val playbackDuration = cursor.getString(5)
                val releaseYearStr = cursor.getString(6)
                val trackStr = cursor.getString(7)
                val track = Integer.parseInt(trackStr)
                val calendar = Calendar.getInstance()

                var releaseYear: Long? = null;
                if (releaseYearStr != null) {
                    calendar.set(Integer.parseInt(releaseYearStr), 0, 1)
                    releaseYear = calendar.timeInMillis
                }

                val song = Song(
                    albumTitle = albumTitle,
                    artist = artist,
                    songTitle = songTitle,
                    path = path,
                    playbackDuration = playbackDuration.toDoubleOrNull(),
                    releaseDate = releaseYear,
                    trackNumber = track,
                    songID = id,
                )

                val albumArtCursor: Cursor? = context?.getContentResolver()?.query(
                    MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                    albumArtProjection,
                    null,
                    null,
                    null
                )

                albumArtCursor?.moveToNext()

                val albumArt = albumArtCursor?.getString(0)

                var typedIntArray: Array<Int>? = null

                if (albumArt != null) {
                    val bitmap = BitmapFactory.decodeFile(albumArt)

                    val size: Int = bitmap.getRowBytes() * bitmap.getHeight()
                    val byteBuffer: ByteBuffer = ByteBuffer.allocate(size)
                    bitmap.copyPixelsToBuffer(byteBuffer)
                    val intBuffer = byteBuffer.asIntBuffer()
                    val intArray = IntArray(intBuffer.limit())

                    intBuffer.get(intArray)
                    typedIntArray = intArray.toTypedArray()
                }

                song.image = typedIntArray

                //Get the genre
                val genreUri = MediaStore.Audio.Genres.getContentUriForAudioId(
                    "external",
                    Integer.parseInt(id)
                )

                val genreCursor: Cursor? = context?.getContentResolver()?.query(
                    genreUri,
                    genresProjection,
                    null,
                    null,
                    null
                )

                genreCursor?.moveToNext()

                val genreName = genreCursor?.getString(0)
                song.genre = genreName

                genreCursor?.close()

                songs.add(song)
            }
            cursor.close()
        }
        return songs.toTypedArray()
    }

    fun setQueue(context: Context, songIDs: ArrayList<String>, startID: String?, startPlaying: Boolean?) {
        val songs = songIDs.map<String, Song?> {
            getSongFromMediaStore(context, it)
        }.filterNotNull()

        songQueue = ArrayList(songs)
        queueIndex = 0

        player.setOnCompletionListener { onSongComplete(context) }

        if (startPlaying != null && startPlaying) {
            if (startID != null) {
                playItem(context, startID)
            } else {
                if (songs.first() != null) {
                    val song = songs.first()
                    song.songID?.let {
                        playItem(context, it)
                    }
                } else {
                    throw Exception("Could not find song!")
                }
            }
        }
    }

    fun playItem(context: Context, id: String, modifyQueue: Boolean = false): Boolean {
       val song = getSongFromMediaStore(context, id)

        if (song?.path != null) {
            player.reset()
            if (modifyQueue) {
                songQueue = arrayListOf(song)
                queueIndex = 0
            }
            player.setOnCompletionListener { onSongComplete(context) }
            player.setDataSource(song.path)
            player.prepare()
            player.start()
            return true
        }

        return false
    }

    fun getVolume(context: Context): Double {
        val service = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        return service.getStreamVolume(AudioManager.STREAM_MUSIC).toDouble() / volMultiplier(context)
    }

    fun setVolume(context: Context, volume: Double) {
        val service = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val multiplier = volMultiplier(context)
        val min = 0
        val myVol = (min + volume * multiplier).toInt()
        service.setStreamVolume(AudioManager.STREAM_MUSIC, myVol, AudioManager.FLAG_SHOW_UI)
    }

    private fun volMultiplier(context: Context): Int {
        val service = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val max = service.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        val min = 0
        return max - min
    }

    fun play() {
        player.start()
    }

    fun pause() {
        player.pause()
    }

    fun getPlaybackTime(): Double {
        return player.currentPosition.toDouble()
    }

    fun setPlaybackTime(time: Int) {
        player.seekTo(time)
    }

    fun nowPlaying(): Song? {
        queueIndex?.let {
            return if (it < songQueue.size) {
                songQueue[it]
            } else {
                null
            }
        }
        return null
    }

    fun previous(context: Context) {
        queueIndex?.let {
            if (it >= 0 && it < songQueue.size) {
                songQueue[it - 1].songID?.let { id ->
                    playItem(context, id)
                }
                queueIndex = queueIndex?.dec()
            }
        }
    }

    fun next(context: Context) {
        queueIndex?.let {
            if (it < songQueue.size) {
                songQueue[it + 1].songID?.let { id ->
                    playItem(context, id)
                }
                queueIndex = queueIndex?.inc()
            }
        }
    }

    override fun onBind(p0: Intent?): IBinder? {
        TODO("Not yet implemented")
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel(channelId: String, channelName: String): String{
        val channel = NotificationChannel(channelId,
            channelName, NotificationManager.IMPORTANCE_NONE)
        channel.lightColor = Color.BLUE
        channel.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        val service = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        service.createNotificationChannel(channel)
        return channelId
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val channelId =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                createNotificationChannel("my_service", "My Background Service")
            } else {
                ""
            }
        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Playify")
            .setContentText("Playify Music")
            .build()
        startForeground(1, notification)
        return START_STICKY
    }

    private fun onSongComplete(context: Context){
        queueIndex?.let { index ->
            if (index + 1 < songQueue.size) {
                songQueue[index + 1].songID?.let {
                    playItem(context, it)
                }
                queueIndex = queueIndex?.inc()
            } else {
                queueIndex = 0
            }
        }
    }
}
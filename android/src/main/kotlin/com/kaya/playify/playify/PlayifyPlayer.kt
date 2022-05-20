package com.kaya.playify.playify

import android.content.Context
import android.database.Cursor
import android.graphics.BitmapFactory
import android.media.AudioManager
import android.media.MediaPlayer
import android.provider.MediaStore
import com.kaya.playify.playify.Classes.Song
import java.nio.ByteBuffer
import java.util.*
import kotlin.collections.ArrayList


class PlayifyPlayer {
    val player = MediaPlayer()


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

    fun playItem(context: Context, id: String): Boolean {
        val selection = MediaStore.Audio.Media._ID + " == " + id

        val projection = arrayOf(
            MediaStore.Audio.Media.DATA,
        )

        val cursor = context?.getContentResolver()?.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            projection,
            selection,
            null,
            null
        )

        if (cursor != null) {
            cursor.moveToFirst()
            val data = cursor.getString(0)

            if (data != null) {
                player.setDataSource(data)
                player.prepare()
                player.start()
                return true
            }
        }

        return false
    }

    fun getVolume(context: Context): Int {
        val service = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        return service.getStreamVolume(AudioManager.STREAM_MUSIC)
    }

    fun setVolume(context: Context, volume: Double) {
        val service = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val multiplier = volMultiplier(context)
        val min = minVol(context)
        val myVol = (min + volume * multiplier).toInt()
        service.setStreamVolume(AudioManager.STREAM_MUSIC, myVol, AudioManager.FLAG_SHOW_UI)
    }

    private fun volMultiplier(context: Context): Int {
        val service = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val max = service.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        val min = minVol(context)
        return max - min
    }

    private fun minVol(context: Context): Int {
        val service = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val min = service.getStreamMinVolume(AudioManager.STREAM_MUSIC)
        return min
    }
}
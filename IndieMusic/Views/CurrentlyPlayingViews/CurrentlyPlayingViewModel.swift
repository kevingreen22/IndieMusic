//
//  CurrentlyPlayingViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/25/21.
//

import SwiftUI
import AVKit

class CurrentlyPlayingViewModel: ObservableObject {
    
    @AppStorage("currentSongRefString") var currentSongRefString: String = ""
    @State private var delegate = AVDelegate()
    
    var song: Song = Song() {
        didSet {
            changeSong()
            playState = .play
            currentSongRefString = songPersistentRef()
        }
    }
    @Published var album: Album = Album()
    @Published var albumImage = UIImage(systemName: "photo")!
    
    @Published var audioPlayer = AVAudioPlayer()
    @Published var playState: SwimplyPlayIndicator.AudioState = .stop
    @Published var trackPlaying = false
    @Published var trackEnded = false
    @Published var currentPlayTrackWidth: CGFloat = 0
    @Published var currTime: TimeInterval = 0
    @Published var remainingTime: TimeInterval = 0
    @Published var showingLyrics = false
    @Published var showFullScreenCover: Bool = false
    @Namespace var namespace
    
    var dominantColors: (UIColor, UIColor) = (UIColor.gray, UIColor.black)
    
    init() {
        if currentSongRefString != "" {
            setCurrentPlayingSongFromRef()
        }
        preparePlayer()
    }
    
    
    
    func preparePlayer() {
        prepareInfoForSong()
        
        //for pre-cloud-storage testing
//        guard let songUrl = Bundle.main.path(forResource: song.url.absoluteString, ofType: "mp3") else { return nil }
         
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            audioPlayer = try AVAudioPlayer(contentsOf: song.url)
            audioPlayer.delegate = delegate
            audioPlayer.prepareToPlay()
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.audioPlayer.isPlaying {
                    let screen = UIScreen.main.bounds.width - 30
                    let value = self.audioPlayer.currentTime / self.audioPlayer.duration
                    self.currentPlayTrackWidth = screen * CGFloat(value)
                    self.currTime = self.audioPlayer.currentTime
                    self.remainingTime = self.audioPlayer.duration
                }
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("trackEnded"), object: nil, queue: .main) { _ in
                self.trackEnded = true
            }
        } catch {
            print(error)
        }
    }
    
    
    func playPauseSong() {
        if audioPlayer.isPlaying {
            // pause
            audioPlayer.pause()
            trackPlaying = false
            
        } else {
            // play
            if trackEnded {
                audioPlayer.currentTime = 0
                currTime = 0
                remainingTime = 0
                currentPlayTrackWidth = 0
                trackEnded = false
            }
            
            audioPlayer.play()
            trackPlaying = true
        }
    }
    
    
    func playNextSong(songList: [Song]) {
        if !songList.isEmpty {
            guard let currentSongIndex = songList.firstIndex(where: { $0 == song }) else { return }
            let nextSongIndex = songList.index(after: currentSongIndex)
            self.song = album.songs[nextSongIndex]
        } else {
            guard let currentSongIndex = album.songs.firstIndex(where: { $0 == song }) else { return }
            let nextSongIndex = album.songs.index(after: currentSongIndex)
            self.song = album.songs[nextSongIndex]
        }
    }
    
    
    func playPreviousSong(songList: [Song]) {
        if !songList.isEmpty {
            // previous song in play list
            guard let currentSongIndex = songList.firstIndex(where: { $0 == song }) else { return }
            let previousSongIndex = songList.index(before: currentSongIndex)
            self.song = album.songs[previousSongIndex]
        } else {
            // previous song in album
            guard let currentSongIndex = album.songs.firstIndex(where: { $0 == song }) else { return }
            let previousSongIndex = album.songs.index(before: currentSongIndex)
            self.song = album.songs[previousSongIndex]
        }
    }
    
    
    func changeSong() {
        prepareInfoForSong()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            audioPlayer = try AVAudioPlayer(contentsOf: song.url)
            audioPlayer.delegate = delegate
            audioPlayer.prepareToPlay()
            trackPlaying = true
            trackEnded = false
            currentPlayTrackWidth = 0
            audioPlayer.play()
        } catch {
            print(error)
        }
    }
    
    
    /// Prepares song info for playing song.
    fileprivate func prepareInfoForSong() {
        DatabaseManger.shared.fetchAlbumWith(id: self.song.albumID, artistID: self.song.artistID) { album in
            guard let album = album else { return }
            self.album = album
            
            StorageManager.shared.downloadAlbumArtworkFor(album: album) { uiimage in
                guard let image = uiimage else { return }
                self.dominantColors = DominantColors.getDominantColors(image: image)
                DispatchQueue.main.async {
                    self.albumImage = image
                }
            }
        }
    }
    
    
    func doSomething() {

    }
    
    
    
    func songPersistentRef() -> String {
        return "\(song.id)_\(song.albumID)_\(song.artistID)"
    }
    
    func setCurrentPlayingSongFromRef() {
        let refSlice = currentSongRefString.components(separatedBy: "_")
        DatabaseManger.shared.fetchSong(with: refSlice[0], albumID: refSlice[1], artistID: refSlice[2]) { song in
            guard let song = song else { return }
            self.song = song
        }
    }
    
    
}




class AVDelegate: NSObject, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("trackEnded"), object: nil)
    }
}

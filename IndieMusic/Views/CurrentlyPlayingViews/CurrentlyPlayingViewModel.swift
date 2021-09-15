//
//  CurrentlyPlayingViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/25/21.
//

import SwiftUI
import AVKit

class CurrentlyPlayingViewModel: ObservableObject {
    
    @Published var songListData: [Song] = [] // = MockData.Songs()
    @AppStorage("currentSongIndex") var currentSongIndex: Int = 0
    
    @State private var delegate = AVDelegate()
    @Published var audioPlayer = AVAudioPlayer()
    @Published var albumImage = UIImage(systemName: "photo")!
    @Published var playState: SwimplyPlayIndicator.AudioState = .stop
    @Published var trackPlaying = false
    @Published var trackEnded = false
    @Published var currentPlayTrackWidth: CGFloat = 0
    @Published var currTime: TimeInterval = 0
    @Published var remainingTime: TimeInterval = 0
    @Published var showingLyrics = false
    @Published var showFullScreenCover: Bool = false
    
    var dominantColors: (UIColor, UIColor) = (UIColor.gray, UIColor.black)
    
    
    
    
    
    /// Prepares song info for playing. i.e. album artwork, stream url, etc.
    fileprivate func prepareInfoForSong() -> URL? {
        let song = songListData[currentSongIndex]
        
        // for pre-cloud-storage testing
//        guard let songUrl = Bundle.main.path(forResource: song.url.absoluteString, ofType: "mp3") else { return nil }
        
        StorageManager.shared.downloadAlbumArtwork(for: song.albumID) { image in
            guard let img = image else { return }
            self.dominantColors = DominantColors.getDominantColors(image: img)
            DispatchQueue.main.async {
                self.albumImage = img
            }
        }
        
        return song.url
    }
    
    
    func preparePlayer() {
        guard let songURL = prepareInfoForSong() else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            audioPlayer = try AVAudioPlayer(contentsOf: songURL)
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
    
    
    
    
    func changeSong() {
        guard let songURL = prepareInfoForSong() else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            audioPlayer = try AVAudioPlayer(contentsOf: songURL)
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
    
    
    func playNextSong() {
        if songListData.count - 1 != currentSongIndex {
            currentSongIndex += 1
            changeSong()
        }
    }
    
    
    func playPreviousSong() {
        if currentSongIndex > 0 {
            currentSongIndex -= 1
            changeSong()
        }
    }
    
    
    
}



class AVDelegate: NSObject, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("trackEnded"), object: nil)
    }
}

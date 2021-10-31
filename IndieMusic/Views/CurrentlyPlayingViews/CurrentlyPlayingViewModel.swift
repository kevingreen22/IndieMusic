//
//  CurrentlyPlayingViewModel.swift
//  IndieMusic
//
//  Created by Kevin Green on 8/25/21.
//

import SwiftUI
import AVKit

class CurrentlyPlayingViewModel: ObservableObject {
    
    @AppStorage("currentSongRefString") var currentSongRefString: String?
    @State private var delegate = AVDelegate()
    
    var song: Song = Song() {
        didSet {
//            changeSong()
            DispatchQueue.global(qos: .userInitiated).async {
                self.prepareInfoForSong()
            }
            playerItem = AVPlayerItem(url: self.song.url)
            currentSongRefString = songPersistentRef()
        }
    }
    @Published var album: Album = Album()
    @Published var albumImage = UIImage.albumArtworkPlaceholder
    @Published var audioPlayer = AVAudioPlayer()
    @Published var playState: SwimplyPlayIndicator.AudioState = .stop
    @Published var trackPlaying = false
    @Published var trackEnded = false
    @Published var showingLyrics = false
    @Published var showFullScreenCover: Bool = false
    
    @Published var currentPlayTrackWidth: CGFloat = 0
    @Published var currTime: Double = 0
    @Published var remainingTime: Double = 0
    
    @Namespace var namespace
    
    var dominantColors: (UIColor, UIColor) = (UIColor.gray, UIColor.black)
    
    init() {
        setlastPlayedSongFromRef()
        DispatchQueue.global(qos: .userInitiated).async {
            self.prepareInfoForSong()
        }
        initAudioPlayer()
        
//        preparePlayer()
    }
    
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    let seekDuration: Float64 = 10


//    var labelOverallDuration: UILabel!
//    var labelCurrentTime: UILabel!
    
//    var playbackSlider: UISlider!

    //call this mehtod to init audio player
    func initAudioPlayer() {
        playerItem = AVPlayerItem(url: self.song.url)
        player = AVPlayer(playerItem: playerItem)
        
        guard player != nil, playerItem != nil else { return }
        
//        playbackSlider.minimumValue = 0
        
        // To get overAll duration of the audio
        let duration: CMTime = playerItem!.asset.duration
        let seconds: Float64 = CMTimeGetSeconds(duration)
        
//        labelOverallDuration.text = self.stringFromTimeInterval(interval: seconds)
        remainingTime = seconds
        
        // To get the current duration of the audio
        let currentDuration: CMTime = playerItem!.currentTime()
        let currentSeconds: Float64 = CMTimeGetSeconds(currentDuration)
        
//        labelCurrentTime.text = self.stringFromTimeInterval(interval: currentSeconds)
        currTime = currentSeconds
        
//        playbackSlider.maximumValue = Float(seconds)
        
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time: Float64 = CMTimeGetSeconds(self.player!.currentTime())
//                self.playbackSlider.value = Float(time)
                self.remainingTime = time
                
//                self.labelCurrentTime.text = self.stringFromTimeInterval(interval: time)
                self.currTime = time
            }
            
            self.setBuffering(possibleStalling: self.player!.currentItem?.isPlaybackLikelyToKeepUp)
        }
       
       
        //check player has completed playing audio
        let trackFinishedToEnd = NSNotification.Name.AVPlayerItemDidPlayToEndTime
        NotificationCenter.default.addObserver(forName: trackFinishedToEnd, object: playerItem, queue: .main) { [weak self] _ in
            self?.trackEnded = true
            
//            self?.playbackSlider.value = 0
            self?.currTime = 0
            self?.remainingTime = 0
            
            let targetTime: CMTime = CMTimeMake(value: 0, timescale: 1)
            self?.player!.seek(to: targetTime)
        }
        
        //change the progress value
 //        playbackSlider.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
         
    }

    func playbackSliderValueChanged(_ playbackSlider: UISlider) {
        let seconds: Int64 = Int64(playbackSlider.value)
        let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0 {
            player?.play()
        }
    }


    func playPauseSong() {
        if player?.rate == 0 {
            player?.play()
            trackPlaying = true
            playState = .play
        } else {
            player?.pause()
            trackPlaying = false
            playState = .pause
        }
        
//        if audioPlayer.isPlaying {
//            // pause
//            audioPlayer.pause()
//            trackPlaying = false
//            playState = .pause
//
//        } else {
//            // play
//            if trackEnded {
//                audioPlayer.currentTime = 0
//                currTime = 0
//                remainingTime = 0
//                currentPlayTrackWidth = 0
//                trackEnded = false
//            }
//
//            audioPlayer.play()
//            trackPlaying = true
//            playState = .play
//        }
    }

    
    func seekBackWards(_ sender: Any) {
        if player == nil { return }
        let playerCurrenTime = CMTimeGetSeconds(player!.currentTime())
        var newTime = playerCurrenTime - seekDuration
        if newTime < 0 { newTime = 0 }
        player?.pause()
        let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player?.seek(to: selectedTime)
        player?.play()
    }


    func seekForward(_ sender: Any) {
        if player == nil { return }
        if let duration = player!.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
            let newTime = playerCurrentTime + seekDuration
            if newTime < CMTimeGetSeconds(duration)
            {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as
                                                                    Float64), timescale: 1000)
                player!.seek(to: selectedTime)
            }
            player?.pause()
            player?.play()
        }
    }
    
    
    fileprivate func setBuffering(possibleStalling: Bool?) {
        if possibleStalling == false {
            print("IsBuffering")
//                self.ButtonPlay.isHidden = true
            //        self.loadingView.isHidden = false
        } else {
            //stop the activity indicator
            print("Buffering completed")
//                self.ButtonPlay.isHidden = false
            //        self.loadingView.isHidden = true
        }
    }
    
    fileprivate func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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
    
//    func preparePlayer() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.prepareInfoForSong()
//        }
//
//        //for pre-cloud-storage testing
////        guard let songUrl = Bundle.main.path(forResource: song.url.absoluteString, ofType: "mp3") else { return nil }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)
//            audioPlayer = try AVAudioPlayer(contentsOf: song.url)
//            audioPlayer.delegate = delegate
//            audioPlayer.prepareToPlay()
//
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                if self.audioPlayer.isPlaying {
//                    let screen = UIScreen.main.bounds.width - 30
//                    let value = self.audioPlayer.currentTime / self.audioPlayer.duration
//                    self.currentPlayTrackWidth = screen * CGFloat(value)
//                    self.currTime = self.audioPlayer.currentTime
//                    self.remainingTime = self.audioPlayer.duration
//                }
//            }
//
//            NotificationCenter.default.addObserver(
//                forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                object: nil,
//                queue: .main) { [weak self] _ in
//                    self?.trackEnded = true
//            }
//        } catch {
//            print("Error playing song: \(error)")
//        }
//    }
        
//    func changeSong() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.prepareInfoForSong()
//        }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback)
//            try AVAudioSession.sharedInstance().setActive(true)
//            audioPlayer = try AVAudioPlayer(contentsOf: song.url)
//            audioPlayer.delegate = delegate
//            audioPlayer.prepareToPlay()
//            trackPlaying = true
//            trackEnded = false
//            currentPlayTrackWidth = 0
//            audioPlayer.play()
//            playState = .play
//        } catch {
//            print("Error playing song: \(error)")
//        }
//    }
    
    
    /// Prepares song info for playing song. i.e. album artwork, album info, etc.
    fileprivate func prepareInfoForSong() {
        guard song.albumID != "" && song.artistID != "" else { return }
        DatabaseManger.shared.fetchAlbum(with: song.albumID, artistID: song.artistID) { [weak self] album in
            guard let album = album else { return }
            self?.album = album
            
            StorageManager.shared.downloadAlbumArtworkFor(album: album) { [weak self] uiimage in
                guard let image = uiimage else { return }
                self?.dominantColors = DominantColors.getDominantColors(image: image)
                DispatchQueue.main.async {
                    self?.albumImage = image
                }
            }
        }
    }
    
    
    func doSomething() {

    }
    
    
    
    func songPersistentRef() -> String {
        return "\(song.id)_\(song.albumID)_\(song.artistID)"
    }
    
    func setlastPlayedSongFromRef() {
        guard let refSlice = currentSongRefString?.components(separatedBy: "_") else { return }
            DatabaseManger.shared.fetchSong(with: refSlice[0], albumID: refSlice[1], artistID: refSlice[2]) { [weak self] song in
                guard let song = song else { return }
                self?.song = song
            }
    }
    
    
}








class AVDelegate: NSObject, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

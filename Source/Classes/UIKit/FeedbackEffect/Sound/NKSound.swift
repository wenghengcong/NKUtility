//
//  NKSound.swift
//  Alamofire
//
//  Created by Hunt on 2021/9/20.
//

import Foundation
import AVFoundation

#if os(iOS) || os(tvOS)
/// NKSoundCategory is a convenient wrapper for AVAudioSessions category constants.
/// source: https://github.com/adamcichy/SwiftySound
/*
 使用说明：
 NKSound.play(file: "dog.wav")
 NKSound.play(url: fileURL)
 NKSound.play(file: "dog", fileExtension: "wav", numberOfLoops: 2)    // 播放2+1=3 次
 NKSound.play(file: "dog", fileExtension: "wav", numberOfLoops: -1)   // 循环播放
 NKSound.stopAll()
 
 // 播放常用的声音
 NKSound.play(sound: NKKeyPressSound.tap)
 NKSound.play(sysSound: .newMail)

 或者实例：
 let mySound = NKSound(url: fileURL)
 mySound.volume = 0.5
 mySound.play()
 mySound.play { completed in
     print("completed: \(completed)")
 }

 配置：
 NKSound.enable = true
 NKSound.enable = false
 NKSound.category = .ambient
 */
public enum NKSoundCategory {
    
    /// Equivalent of AVAudioSession.Category.ambient.
    case ambient
    /// Equivalent of AVAudioSession.Category.soloAmbient.
    case soloAmbient
    /// Equivalent of AVAudioSession.Category.playback.
    case playback
    /// Equivalent of AVAudioSession.Category.record.
    case record
    /// Equivalent of AVAudioSession.Category.playAndRecord.
    case playAndRecord
    
    fileprivate var avFoundationCategory: AVAudioSession.Category {
        get {
            switch self {
            case .ambient:
                return .ambient
            case .soloAmbient:
                return .soloAmbient
            case .playback:
                return .playback
            case .record:
                return .record
            case .playAndRecord:
                return .playAndRecord
            }
        }
    }
}
#endif

/// Audio file to play
public enum NKSoundAudioSource {
    /// Name of asset in any .xcassets catalogs
    case asset(name: String)
    
    /// Searches main bundle for file with given name and extension
    case file(name: String, fileExtension: String)
    
    /// URL of audio file
    case url(URL)
    
    /// Predefined system sound included in all iPhones
    case system(NKSystemSound)
}

/// Sound is a class that allows you to easily play sounds in Swift. It uses AVFoundation framework under the hood.
open class NKSound {
    
    // MARK: - Global settings
    
    /// Number of AVAudioPlayer instances created for every sound. SwiftySound creates 5 players for every sound to make sure that it will be able to play the same sound more than once. If your app doesn't need this functionality, you can reduce the number of players to 1 and reduce memory usage. You can increase the number if your app plays the sound more than 5 times at the same time.
    public static var playersPerSound: Int = 5 {
        didSet {
            stopAll()
            sounds.removeAll()
        }
    }
    
    #if os(iOS) || os(tvOS)
    /// Sound session. The default value is the shared `AVAudioSession` session.
    public static var session: NKSoundSession = AVAudioSession.sharedInstance()
    
    /// Sound category for current session. Using this variable is a convenient way to set AVAudioSessions category. The default value is .ambient.
    public static var category: NKSoundCategory = {
        let defaultCategory = NKSoundCategory.ambient
        try? session.setCategory(defaultCategory.avFoundationCategory)
        return defaultCategory
    }() {
        didSet {
            try? session.setCategory(category.avFoundationCategory)
        }
    }
    #endif
    
    private static var sounds = [URL: NKSound]()
    
    ///  用户信息，用于区分不同用户的存储
    public static var userinfo = "NKUtility"
        
    private static func generateSoundEnableKey() -> String {
        let ori = "com.niki.NKSound.enable"
        let result = "\(NKSound.userinfo)_\(ori))"
        return result
    }
    
    /// Globally enable or disable sound. This setting value is stored in UserDefaults and will be loaded on app launch.
    public static var enable: Bool = {
        return !UserDefaults.standard.bool(forKey: generateSoundEnableKey())
    }() { didSet {
        let value = !enable
        UserDefaults.standard.set(value, forKey: generateSoundEnableKey())
        if value {
            stopAll()
        }
    }
    }
    
    private let players: [NKSoundPlayer]
    
    private var counter = 0
    
    /// The class that is used to create `NKSoundPlayer` instances. Defaults to `AVAudioPlayer`.
    public static var playerClass: NKSoundPlayer.Type = AVAudioPlayer.self
    
    /// The bundle used to load sounds from filenames. The default value of this property is Bunde.main. It can be changed to load sounds from another bundle.
    public static var soundsBundle: Bundle = .main
    
    // MARK: - Initialization
    
    /// Create a sound object.
    ///
    /// - Parameter url: Sound file URL.
    public init?(url: URL) {
        #if os(iOS) || os(tvOS)
        _ = NKSound.category
        #endif
        let playersPerSound = max(NKSound.playersPerSound, 1)
        var myPlayers: [NKSoundPlayer] = []
        myPlayers.reserveCapacity(playersPerSound)
        for _ in 0..<playersPerSound {
            do {
                let player = try NKSound.playerClass.init(contentsOf: url)
                myPlayers.append(player)
            } catch {
                print("SwiftySound initialization error: \(error)")
            }
        }
        if myPlayers.count == 0 {
            return nil
        }
        players = myPlayers
        NotificationCenter.default.addObserver(self, selector: #selector(NKSound.stopNoteRcv), name: NKSound.stopNotificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NKSound.stopNotificationName, object: nil)
    }
    
    @objc private func stopNoteRcv() {
        stop()
    }
    
    private static let stopNotificationName = Notification.Name("com.moonlightapps.SwiftySound.stopNotification")
    
    // MARK: - Main play method
    
    /// Play the sound.
    ///
    /// - Parameter numberOfLoops: Number of loops. Specify a negative number for an infinite loop. Default value of 0 means that the sound will be played once.
    /// - Returns: If the sound was played successfully the return value will be true. It will be false if sounds are disabled or if system could not play the sound.
    @discardableResult public func play(numberOfLoops: Int = 0, completion: PlayerCompletion? = nil) -> Bool {
        if !NKSound.enable {
            return false
        }
        paused = false
        counter = (counter + 1) % players.count
        let player = players[counter]
        return player.play(numberOfLoops: numberOfLoops, completion: completion)
    }
    
    // MARK: - Stop playing
    
    /// Stop playing the sound.
    public func stop() {
        for player in players {
            player.stop()
        }
        paused = false
    }
    
    /// Pause current playback.
    public func pause() {
        players[counter].pause()
        paused = true
    }
    
    
    /// Resume playing.
    @discardableResult public func resume() -> Bool {
        if paused {
            players[counter].resume()
            paused = false
            return true
        }
        return false
    }
    
    /// Indicates if the sound is currently playing.
    public var playing: Bool {
        return players[counter].isPlaying
    }
    
    /// Indicates if the sound is paused.
    public private(set) var paused: Bool = false
    
    // MARK: - Prepare sound
    
    /// Prepare the sound for playback
    ///
    /// - Returns: True if the sound has been prepared, false in case of error
    @discardableResult public func prepare() -> Bool {
        let nextIndex = (counter + 1) % players.count
        return players[nextIndex].prepareToPlay()
    }
    
    // MARK: - Convenience static methods
    @discardableResult public static func play(source: NKSoundAudioSource) -> Bool {
        switch source {
        case .asset(let name):
            return play(file: name)
        case .file(let name, let fileExtension):
            return play(file: name, fileExtension: fileExtension)
        case .url(let url):
            return play(url: url)
        case .system(let sound):
            play(sysSound: sound)
            return true
        }
        return false
    }
    
    
    /// Play sound from a sound file.
    ///
    /// - Parameters:
    ///   - file: Sound file name.
    ///   - fileExtension: Sound file extension.
    ///   - numberOfLoops: Number of loops. Specify a negative number for an infinite loop. Default value of 0 means that the sound will be played once.
    /// - Returns: If the sound was played successfully the return value will be true. It will be false if sounds are disabled or if system could not play the sound.
    @discardableResult public static func play(file: String, fileExtension: String? = nil, numberOfLoops: Int = 0) -> Bool {
        if let url = url(for: file, fileExtension: fileExtension) {
            return play(url: url, numberOfLoops: numberOfLoops)
        }
        return false
    }
    
    /// Play a sound from URL.
    ///
    /// - Parameters:
    ///   - url: Sound file URL.
    ///   - numberOfLoops: Number of loops. Specify a negative number for an infinite loop. Default value of 0 means that the sound will be played once.
    /// - Returns: If the sound was played successfully the return value will be true. It will be false if sounds are disabled or if system could not play the sound.
    @discardableResult public static func play(url: URL, numberOfLoops: Int = 0) -> Bool {
        if !NKSound.enable {
            return false
        }
        var sound = sounds[url]
        if sound == nil {
            sound = NKSound(url: url)
            sounds[url] = sound
        }
        return sound?.play(numberOfLoops: numberOfLoops) ?? false
    }
    
    /// Stop playing sound for given URL.
    ///
    /// - Parameter url: Sound file URL.
    public static func stop(for url: URL) {
        let sound = sounds[url]
        sound?.stop()
    }
    
    /// Duration of the sound.
    public var duration: TimeInterval {
        get {
            return players[counter].duration
        }
    }
    
    /// Sound volume.
    /// A value in the range 0.0 to 1.0, with 0.0 representing the minimum volume and 1.0 representing the maximum volume.
    public var volume: Float {
        get {
            return players[counter].volume
        }
        set {
            for player in players {
                player.volume = newValue
            }
        }
    }
    
    /// Stop playing sound for given sound file.
    ///
    /// - Parameters:
    ///   - file: Sound file name.
    ///   - fileExtension: Sound file extension.
    public static func stop(file: String, fileExtension: String? = nil) {
        if let url = url(for: file, fileExtension: fileExtension) {
            let sound = sounds[url]
            sound?.stop()
        }
    }
    
    /// Stop playing all sounds.
    public static func stopAll() {
        NotificationCenter.default.post(name: stopNotificationName, object: nil)
    }
    
    // MARK: - Private helper method
    private static func url(for file: String, fileExtension: String? = nil) -> URL? {
        return soundsBundle.url(forResource: file, withExtension: fileExtension)
    }
    
}

/// Player protocol. It duplicates `AVAudioPlayer` methods.
public protocol NKSoundPlayer: class {
    
    /// Play the sound.
    ///
    /// - Parameters:
    ///   - numberOfLoops: Number of loops.
    ///   - completion: Complation handler.
    /// - Returns: true if the sound was played successfully. False otherwise.
    func play(numberOfLoops: Int, completion: PlayerCompletion?) -> Bool
    
    /// Stop playing the sound.
    func stop()
    
    /// Pause current playback.
    func pause()
    
    /// Resume playing.
    func resume()
    
    /// Prepare the sound.
    func prepareToPlay() -> Bool
    
    /// Create a Player for sound url.
    ///
    /// - Parameter url: sound url.
    init(contentsOf url: URL) throws
    
    /// Duration of the sound.
    var duration: TimeInterval { get }
    
    /// Sound volume.
    var volume: Float { get set }
    
    /// Indicates if the player is currently playing.
    var isPlaying: Bool { get }
}

fileprivate var associatedCallbackKey = "com.moonlightapps.SwiftySound.associatedCallbackKey"

public typealias PlayerCompletion = ((Bool) -> ())

extension AVAudioPlayer: NKSoundPlayer, AVAudioPlayerDelegate {
    
    public func play(numberOfLoops: Int, completion: PlayerCompletion?) -> Bool {
        if let cmpl = completion {
            objc_setAssociatedObject(self, &associatedCallbackKey, cmpl, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.delegate = self
        }
        self.numberOfLoops = numberOfLoops
        return play()
    }
    
    public func resume() {
        play()
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let cmpl = objc_getAssociatedObject(self, &associatedCallbackKey) as? PlayerCompletion
        cmpl?(flag)
        objc_removeAssociatedObjects(self)
        self.delegate = nil
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("SwiftySound playback error: \(String(describing: error))")
    }
    
}

#if os(iOS) || os(tvOS)
/// NKSoundSession protocol. It duplicates `setCategory` method of `AVAudioSession` class.
public protocol NKSoundSession: AnyObject {
    /// Set category for session.
    ///
    /// - Parameter category: category.
    func setCategory(_ category: AVAudioSession.Category) throws
}

extension AVAudioSession: NKSoundSession {}
#endif

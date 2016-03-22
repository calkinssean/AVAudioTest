//
//  ViewController.swift
//  Integrated-Algorithm
//
//  Created by Sean Calkins on 3/21/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    var arrayOfAudioFiles = [AudioFile]()
    
    @IBOutlet weak var tracksTableView: UITableView!
    
    var currentAudioFile:AudioFile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func recordTapped(sender: UIButton) {
        startNewAudioFile()
        self.tracksTableView.reloadData()
    }
    
    @IBAction func playTapped(sender: UIButton) {
        
        if let filePath = self.currentAudioFile?.filePath {
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: filePath)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            } catch {
                print(error)
            }
        }
        print(self.currentAudioFile?.filePath)
    }
    
    @IBAction func pauseTapped(sender: UIButton) {
        
    }
    
    @IBAction func stopTapped(sender: UIButton) {
        
        if let recorder = audioRecorder {
            recorder.stop()
        }
        
    }
    
    func startNewAudioFile() {
        
        let today = NSDate()
        let timestamp = today.timeIntervalSince1970
        let fileURL = self.documentDirectory()?.URLByAppendingPathComponent("\(timestamp)")
        
        self.currentAudioFile = AudioFile(title: "\(timestamp)", filePath: fileURL!)
        
        self.arrayOfAudioFiles.append(self.currentAudioFile!)
        
        if let url = self.currentAudioFile?.filePath {
            startSessionWithFilePath(url)
        }
        
        print(self.arrayOfAudioFiles.count)
    }
    
    func startSessionWithFilePath(filePath: NSURL) {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
            
            let recorderSetting: [String: AnyObject] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(URL: filePath, settings: recorderSetting)
            audioRecorder?.delegate = self
            audioRecorder?.meteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
        } catch {
            print(error)
        }
        
    }
    
    func documentDirectory() -> NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let f = arrayOfAudioFiles[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Audio File Cell")!
        
        cell.textLabel?.text = f.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfAudioFiles.count
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let f = arrayOfAudioFiles[indexPath.row]
        let filePath = f.filePath
        print(f.title)
        print(f.filePath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: filePath)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            } catch {
                print(error)
            }
        
        print(f.filePath)
    }
    
}


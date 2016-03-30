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
    
    //MARK: - Audio Recorder and player instances
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    //Properties
    var arrayOfAudioFiles = [AudioFile]()
    var currentAudioFile:AudioFile?
    
    //Outlets
    @IBOutlet weak var tracksTableView: UITableView!
    
    
    //View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Record button
    @IBAction func recordTapped(sender: UIButton) {
        startNewAudioFile()
        self.tracksTableView.reloadData()
    }
    
    //MARK: - Play button
    @IBAction func playTapped(sender: UIButton) {
        
        //Grabs the file path of current audiofile (NSURL)
        if let filePath = self.currentAudioFile?.filePath {
            
            do {
                //Plays that audio file from filepath using AVAudioPlayer
                audioPlayer = try AVAudioPlayer(contentsOfURL: filePath)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            } catch {
                print(error)
            }
        }
        print(self.currentAudioFile?.filePath)
    }
    
    //MARK: - Pause button
    @IBAction func pauseTapped(sender: UIButton) {
        
        if let recorder = audioRecorder {
            
            recorder.pause()
            
        }
    }
    
    //MARK: - Stop button
    @IBAction func stopTapped(sender: UIButton) {
        
        if let recorder = audioRecorder {
        
            recorder.stop()
        
        }
        
    }
    
    //MARK: - Start new audio file
    func startNewAudioFile() {
        
        let today = NSDate()
        let timestamp = today.timeIntervalSince1970
        let fileURL = self.documentDirectory()?.URLByAppendingPathComponent("\(timestamp)")
        
        //Creates a new audiofile with a timeStamp in the filepath url and adds it to array
        self.currentAudioFile = AudioFile(title: "\(timestamp)", filePath: fileURL!)
        
        self.arrayOfAudioFiles.append(self.currentAudioFile!)
        
        if let url = self.currentAudioFile?.filePath {
            
            //Starts new audio session with new audiofile url
            startSessionWithFilePath(url)
        
        }
        
        print(self.arrayOfAudioFiles.count)
    }
    
    //MARK: - Start audio session
    func startSessionWithFilePath(filePath: NSURL) {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            //Trys to create a new audio session, if it doesn't work print error
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
            
            let recorderSetting: [String: AnyObject] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
            ]
            
            //Records new audio into current audiofile url
            audioRecorder = try AVAudioRecorder(URL: filePath, settings: recorderSetting)
            audioRecorder?.delegate = self
            audioRecorder?.meteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            
        } catch {
            print(error)
        }
        
    }
    
    //MARK: - Grabbing document directory
    func documentDirectory() -> NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first
    }
    
    
    //MARK: - Table view data source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let f = arrayOfAudioFiles[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Audio File Cell")!
        
        cell.textLabel?.text = f.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfAudioFiles.count
        
    }
    
    //MARK: - Did select table view cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //grab audio file from array and creates a new instance of it's filepath
        let f = arrayOfAudioFiles[indexPath.row]
        let filePath = f.filePath
        print(f.title)
        print(f.filePath)
        do {
            //tries to play audiofile with AVAudioPlayer
            audioPlayer = try AVAudioPlayer(contentsOfURL: filePath)
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            print(error)
        }
        
        print(f.filePath)
    }
    
}


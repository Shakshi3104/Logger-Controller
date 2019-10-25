//
//  MotionSensorLogger.swift
//  Logger5
//
//  Created by MacBook Air on 2019/10/25.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation
import CoreMotion

public class MotionSensorLogger {
    let motionManager = CMMotionManager()
    var timer = Timer()
    
    var acceleometerDataArray = [[Double]]()
    var gyroscopeDataArray = [[Double]]()
    var magnetometerDataArray = [[Double]]()
    
    var timestampArray = [String]()
    
    // initializer
    public init() {
        
    }
    
    // output csv file -> [URL]
    public func getOutputDataURLs(label: String, user: String) -> [URL] {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        let time = format.string(from: Date())
        
        // temporary file directory
        let tmppath = NSHomeDirectory() + "/tmp"
        
        // add filemame
        let adp = "\(time)_\(label)_\(user)"
        
        // output filepath
        let accelerometerFilepath = tmppath + "/accelermeter_\(adp).csv"
        let gyroFilepath = tmppath + "/gyroscope_\(adp).csv"
        let magnetFilepath = tmppath + "/magnetometer_\(adp).csv"
        
        let accGyrMagFilepath = tmppath + "/data_\(adp).csv"
        
        // output file column
        let dataColumn = "time,x,y,z\n"
        let dataAllColumn = "time,acc_x,acc_y,acc_z,gyr_x,gyr_y,gyr_z,mag_x,mag_y,mag_z\n"
        
        let outputAccelerometerData = dataColumn + self.doublesToString(data: self.acceleometerDataArray)
        let outputGyroscopeData = dataColumn + self.doublesToString(data: self.gyroscopeDataArray)
        let outputMagnetometerData = dataColumn + self.doublesToString(data: self.magnetometerDataArray)
        
        let outputAccelGyroMagnetData = dataAllColumn + self.doublesToString(data: self.concatenateAccGyrMagArray())
        
        // write data
        do {
            try outputAccelerometerData.write(toFile: accelerometerFilepath, atomically: true, encoding: String.Encoding.utf8)
            try outputGyroscopeData.write(toFile: gyroFilepath, atomically: true, encoding: String.Encoding.utf8)
            try outputMagnetometerData.write(toFile: magnetFilepath, atomically: true, encoding: String.Encoding.utf8)
            
            try outputAccelGyroMagnetData.write(toFile: accGyrMagFilepath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Failure to Write File\n\(error)")
        }
        
        
        // get filepath of csv file written
        var urls = [URL]()
        urls.append(URL(fileURLWithPath: accelerometerFilepath))
        urls.append(URL(fileURLWithPath: gyroFilepath))
        urls.append(URL(fileURLWithPath: magnetFilepath))
        urls.append(URL(fileURLWithPath: accGyrMagFilepath))
        
        return urls
    }
    
    // 2-dimention double array to string
    private func doublesToString(data: [[Double]]) -> String {
        var output = ""
        
        for (line, timestamp) in zip(data, self.timestampArray) {
            var lineString = timestamp + ","
            for element in line {
                lineString.append(contentsOf: String(element) + ",")
            }
            output.append(lineString + "\n")
        }
        
        return output
    }
    
    // concate accelerometerArray, gyroscopeArray, MagnetometerArray
    private func concatenateAccGyrMagArray() -> [[Double]] {
        var accGyrMagArray = [[Double]]()
        
        for i in 0..<self.acceleometerDataArray.count {
            var line = [Double]()
            line.append(contentsOf: self.acceleometerDataArray[i])
            line.append(contentsOf: self.gyroscopeDataArray[i])
            line.append(contentsOf: self.magnetometerDataArray[i])
            
            accGyrMagArray.append(line)
        }
        
        return accGyrMagArray
    }
    
    // get timestamp -> String
    private func nowTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        return format.string(from: Date())
    }
    
    // pull
    @objc private func recordSensorValue() {
        var isAcc = false
        var isGyr = false
        var isMag = false
        
        var accline = [Double]()
        var gyrline = [Double]()
        var magline = [Double]()
        
        if let data = motionManager.accelerometerData {
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            
            accline.append(contentsOf: [x, y, z])
            isAcc = true
        }
        
        if let data = motionManager.gyroData {
            let x = data.rotationRate.x
            let y = data.rotationRate.y
            let z = data.rotationRate.z
            
            gyrline.append(contentsOf: [x, y, z])
            isGyr = true
        }
        
        if let data = motionManager.magnetometerData {
            let x = data.magneticField.x
            let y = data.magneticField.y
            let z = data.magneticField.z
            
            magline.append(contentsOf: [x, y, z])
            isMag = true
        }
        
        
        if isAcc && isGyr && isMag {
            self.acceleometerDataArray.append(accline)
            self.gyroscopeDataArray.append(gyrline)
            self.magnetometerDataArray.append(magline)
            
            self.timestampArray.append(self.nowTime())
        }
    }
    
    // start sensor log
    public func startSensor(_ freq: Double) {
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates()
        }
        
        if motionManager.isGyroAvailable {
            motionManager.startGyroUpdates()
        }
        
        if motionManager.isMagnetometerAvailable {
            motionManager.startMagnetometerUpdates()
        }
        
        // プル型でデータ取得
        self.timer = Timer.scheduledTimer(timeInterval: 1/freq,
                                          target: self,
                                          selector: #selector(self.recordSensorValue),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    
    public func stopSensor() {
        self.timer.invalidate()
        
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
        
        if motionManager.isGyroActive {
            motionManager.stopGyroUpdates()
        }
        
        if motionManager.isMagnetometerActive {
            motionManager.stopMagnetometerUpdates()
        }
    }
    
    public func resetOutputData() {
        self.acceleometerDataArray = [[Double]]()
        self.gyroscopeDataArray = [[Double]]()
        self.magnetometerDataArray = [[Double]]()
        
        self.timestampArray = [String]()
    }
    
}

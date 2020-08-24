//
//  SensorLogger.swift
//  Logger
//
//  Created by MacBook Air on 2019/05/23.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation
import CoreMotion
import Combine

@available(iOS 14.0, *)
class SensorLogManager: NSObject, ObservableObject {
    var motionManager: CMMotionManager?
    var headphoneMotionManager: CMHeadphoneMotionManager?
    var logger = SensorLogger()
    
    // iPhone
    @Published var accX = 0.0
    @Published var accY = 0.0
    @Published var accZ = 0.0
    @Published var gyrX = 0.0
    @Published var gyrY = 0.0
    @Published var gyrZ = 0.0
    @Published var magX = 0.0
    @Published var magY = 0.0
    @Published var magZ = 0.0
    
    @Published var accXArray = [0.0]
    @Published var accYArray = [0.0]
    @Published var accZArray = [0.0]
    @Published var gyrXArray = [0.0]
    @Published var gyrYArray = [0.0]
    @Published var gyrZArray = [0.0]
    
    // Headphone
    @Published var headAccX = 0.0
    @Published var headAccY = 0.0
    @Published var headAccZ = 0.0
    @Published var headGyrX = 0.0
    @Published var headGyrY = 0.0
    @Published var headGyrZ = 0.0
    
    var timer = Timer()
    
    override init() {
        super.init()
        self.motionManager = CMMotionManager()
        self.headphoneMotionManager = CMHeadphoneMotionManager()
    }
    
    @objc private func startLogSensor() {
        let suffixLength = 64
        
        if let data = motionManager?.accelerometerData {
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            
            self.accX = x
            self.accY = y
            self.accZ = z
            
            // グラフ表示用
            self.accXArray.append(x)
            self.accXArray = self.accXArray.suffix(suffixLength)
            self.accYArray.append(y)
            self.accYArray = self.accYArray.suffix(suffixLength)
            self.accZArray.append(z)
            self.accZArray = self.accZArray.suffix(suffixLength)
        }
        else {
            self.accX = Double.nan
            self.accY = Double.nan
            self.accZ = Double.nan
        }
        
        if let data = motionManager?.gyroData {
            let x = data.rotationRate.x
            let y = data.rotationRate.y
            let z = data.rotationRate.z
            
            self.gyrX = x
            self.gyrY = y
            self.gyrZ = z
            
            // グラフ表示用
            self.gyrXArray.append(x)
            self.gyrXArray = self.gyrXArray.suffix(suffixLength)
            self.gyrYArray.append(y)
            self.gyrYArray = self.gyrYArray.suffix(suffixLength)
            self.gyrZArray.append(z)
            self.gyrZArray = self.gyrZArray.suffix(suffixLength)
        }
        else {
            self.gyrX = Double.nan
            self.gyrY = Double.nan
            self.gyrZ = Double.nan
        }
        
        if let data = motionManager?.magnetometerData {
            let x = data.magneticField.x
            let y = data.magneticField.y
            let z = data.magneticField.z
            
            self.magX = x
            self.magY = y
            self.magZ = z
        }
        else {
            self.magX = Double.nan
            self.magY = Double.nan
            self.magZ = Double.nan
        }
        
        
        if let data = self.headphoneMotionManager?.deviceMotion {
            let accX = data.gravity.x + data.userAcceleration.x
            let accY = data.gravity.y + data.userAcceleration.y
            let accZ = data.gravity.z + data.userAcceleration.z
            
            let gyrX = data.rotationRate.x
            let gyrY = data.rotationRate.y
            let gyrZ = data.rotationRate.z
            
            self.headAccX = accX
            self.headAccY = accY
            self.headAccZ = accZ
            self.headGyrX = gyrX
            self.headGyrY = gyrY
            self.headGyrZ = gyrZ
        }
        else {
            self.headAccX = Double.nan
            self.headAccY = Double.nan
            self.headAccZ = Double.nan
            self.headGyrX = Double.nan
            self.headGyrY = Double.nan
            self.headGyrZ = Double.nan
        }
        
        // センサデータを記録する
        let timestamp = self.logger.getTimestamp()
        self.logger.logAccelerometerData(time: timestamp, x: self.accX, y: self.accY, z: self.accZ)
        self.logger.logGyroscopeData(time: timestamp, x: self.gyrX, y: self.gyrY, z: self.gyrZ)
        self.logger.logMagnetometerData(time: timestamp, x: self.magX, y: self.magY, z: self.magZ)
        
        print(timestamp + ", \(self.headAccX), \(self.headAccY), \(self.headAccZ)")
        
    }
    
    func startUpdate(_ freq: Double) {
        if self.motionManager!.isAccelerometerAvailable {
            self.motionManager?.startAccelerometerUpdates()
        }
        
        if self.motionManager!.isGyroAvailable {
            self.motionManager?.startGyroUpdates()
        }
        
        if self.motionManager!.isMagnetometerAvailable {
            self.motionManager?.startMagnetometerUpdates()
        }
        
       
        if self.headphoneMotionManager!.isDeviceMotionAvailable {
            self.headphoneMotionManager?.startDeviceMotionUpdates()
        }
    
        
        // プル型でデータ取得
        self.timer = Timer.scheduledTimer(timeInterval: 1.0 / freq,
                           target: self,
                           selector: #selector(self.startLogSensor),
                           userInfo: nil,
                           repeats: true)
        
    }
    
    func stopUpdate() {
        self.timer.invalidate()
        
        if self.motionManager!.isAccelerometerActive {
            self.motionManager?.stopAccelerometerUpdates()
        }
        
        if self.motionManager!.isGyroActive {
            self.motionManager?.stopGyroUpdates()
        }
        
        if self.motionManager!.isMagnetometerActive {
            self.motionManager?.stopMagnetometerUpdates()
        }
        
        if self.headphoneMotionManager!.isDeviceMotionActive {
            self.headphoneMotionManager?.stopDeviceMotionUpdates()
        }
        
    }
    
}


class SensorLogger {
    // iPhone本体
    var accelerometerData : String
    var gyroscopeData : String
    var magnetometerData : String
    
    // ヘッドフォン
    var headphoneAccelerometerData : String
    var headphoneGyroscopeData : String
    
    private final let column = "time,x,y,z\n"
    
    public init() {
        self.accelerometerData = self.column
        self.gyroscopeData = self.column
        self.magnetometerData = self.column
        
        self.headphoneAccelerometerData = self.column
        self.headphoneGyroscopeData = self.column
    }
    
    // タイムスタンプを取得する
    func getTimestamp() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        return format.string(from: Date())
    }
    
    /* センサデータを保存する */
    func logAccelerometerData(time: String, x: Double, y: Double, z: Double) {
        var line = time + ","
        line.append(contentsOf: String(x) + ",")
        line.append(contentsOf: String(y) + ",")
        line.append(contentsOf: String(z) + "\n")
        
        self.accelerometerData.append(contentsOf: line)
    }
    
    func logGyroscopeData(time: String, x: Double, y: Double, z: Double) {
        var line = time + ","
        line.append(contentsOf: String(x) + ",")
        line.append(contentsOf: String(y) + ",")
        line.append(contentsOf: String(z) + "\n")
        
        self.gyroscopeData.append(contentsOf: line)
    }
    
    func logMagnetometerData(time: String, x: Double, y: Double, z: Double) {
        var line = time + ","
        line.append(contentsOf: String(x) + ",")
        line.append(contentsOf: String(y) + ",")
        line.append(contentsOf: String(z) + "\n")
        
        self.magnetometerData.append(contentsOf: line)
    }
    
    func logHeadphoneAccelerometerData(time: String, x: Double, y: Double, z: Double) {
        var line = time + ","
        line.append(contentsOf: String(x) + ",")
        line.append(contentsOf: String(y) + ",")
        line.append(contentsOf: String(z) + "\n")
        
        self.headphoneAccelerometerData.append(contentsOf: line)
    }
    
    func logHeadphoneGyroscopeData(time: String, x: Double, y: Double, z: Double) {
        var line = time + ","
        line.append(contentsOf: String(x) + ",")
        line.append(contentsOf: String(y) + ",")
        line.append(contentsOf: String(z) + "\n")
        
        self.headphoneGyroscopeData.append(contentsOf: line)
    }
    
    // 保存したファイルパスを取得する
    func getDataURLs(label: String, subject: String) -> [URL] {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        let time = format.string(from: Date())
        
        /* 一時ファイルを保存する場所 */
        let tmppath = NSHomeDirectory() + "/tmp"
        
        let apd = "\(time)_\(label)_\(subject)" // 付加する文字列(時間+ラベル+ユーザ名)
        // ファイル名を生成
        let accelerometerFilepath = tmppath + "/accelermeter_\(apd).csv"
        let gyroFilepath = tmppath + "/gyroscope_\(apd).csv"
        let magnetFilepath = tmppath + "/magnetometer_\(apd).csv"
        
        let headphoneAccelerometerFilepath = tmppath + "/headphone_accelerometer_\(apd).csv"
        let headphoneGyroscopeFilepath = tmppath + "/headphone_gyroscope_\(apd).csv"
        
        // ファイルを書き出す
        do {
            try self.accelerometerData.write(toFile: accelerometerFilepath, atomically: true, encoding: String.Encoding.utf8)
            try self.gyroscopeData.write(toFile: gyroFilepath, atomically: true, encoding: String.Encoding.utf8)
            try self.magnetometerData.write(toFile: magnetFilepath, atomically: true, encoding: String.Encoding.utf8)
            
            try self.headphoneAccelerometerData.write(toFile: headphoneAccelerometerFilepath, atomically: true, encoding: String.Encoding.utf8)
            try self.headphoneGyroscopeData.write(toFile: headphoneGyroscopeFilepath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError{
            print("Failure to Write File\n\(error)")
        }
        
        /* 書き出したcsvファイルの場所を取得 */
        var urls = [URL]()
        urls.append(URL(fileURLWithPath: accelerometerFilepath))
        urls.append(URL(fileURLWithPath: gyroFilepath))
        urls.append(URL(fileURLWithPath: magnetFilepath))
        
        urls.append(URL(fileURLWithPath: headphoneAccelerometerFilepath))
        urls.append(URL(fileURLWithPath: headphoneGyroscopeFilepath))
        
        // データをリセットする
        self.resetData()
        
        return urls
    }
    
    // データをリセットする
    func resetData() {
        self.accelerometerData = self.column
        self.gyroscopeData = self.column
        self.magnetometerData = self.column
        
        self.headphoneAccelerometerData = self.column
        self.headphoneGyroscopeData = self.column
    }
}

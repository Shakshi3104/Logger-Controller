//
//  SensorLogger.swift
//  Logger
//
//  Created by MacBook Air on 2019/05/23.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import Foundation
import CoreMotion

public class MotionSensorLogger {
    let motionManager = CMMotionManager()   // MotionManager
    var timer = Timer()
    
    // CSVファイルに書き出すデータ
    let columnTo3D = "time, x, y, z\n"  // 3軸データ用のカラム
    var outputAccelerometerData = ""    // 加速度センサのデータ
    var outputGyroscopeData = ""        // ジャイロセンサのデータ
    var outputMagnetometerData = ""     // 磁気センサのデータ
    
    let columnToChange = "time, data\n" // 照度センサ、近接センサ用
    
    let columnTo3DAll = "time, acc_x, acc_y, acc_z, gyr_x, gyr_y, gyr_z, mag_x, mag_y, mag_z\n" // 3軸データ全てを保存する用のカラム
    var outputAccelGyroMagnetData = ""  // 加速度、ジャイロ、磁気センサのデータ
    
    // イニシャライザ
    public init(){
        // 書き出し用のデータを保持するstringの1行目にカラム
        self.outputAccelerometerData = ""
        self.outputGyroscopeData = ""
        self.outputMagnetometerData = ""
        self.outputAccelGyroMagnetData = ""
    }
    
    // csvファイルに書き出す -> [URL]
    public func getOutputDataURLs(label: String, user: String) -> [URL] {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        let time = format.string(from: Date())
        
        /* 一時ファイルを保存する場所 */
        let tmppath = NSHomeDirectory() + "/tmp"
        
        let apd = "\(time)_\(label)_\(user)" // 付加する文字列(時間+ラベル+ユーザ名)
        
        let accelerometerFilepath = tmppath + "/accelermeter_\(apd).csv"
        let gyroFilepath = tmppath + "/gyroscope_\(apd).csv"
        let magnetFilepath = tmppath + "/magnetometer_\(apd).csv"
        
        let accGyrMagFilepath = tmppath + "/data_\(apd).csv"
        
        // データにカラムを追加
        self.outputAccelerometerData = self.columnTo3D + self.outputAccelerometerData
        self.outputGyroscopeData = self.columnTo3D + self.outputGyroscopeData
        self.outputMagnetometerData = self.columnTo3D + self.outputMagnetometerData
        self.outputAccelGyroMagnetData = self.columnTo3DAll + self.outputAccelGyroMagnetData
        
        /* tmpに書き出す*/
        do {
            try self.outputAccelerometerData.write(toFile: accelerometerFilepath, atomically: true, encoding: String.Encoding.utf8)
            try self.outputGyroscopeData.write(toFile: gyroFilepath, atomically: true, encoding: String.Encoding.utf8)
            try self.outputMagnetometerData.write(toFile: magnetFilepath, atomically: true, encoding: String.Encoding.utf8)
            
            try self.outputAccelGyroMagnetData.write(toFile: accGyrMagFilepath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError{
            print("Failure to Write File\n\(error)")
        }
        
        /* 書き出したcsvファイルの場所を取得 */
        var urls = [URL]()
        urls.append(URL(fileURLWithPath: accelerometerFilepath))
        urls.append(URL(fileURLWithPath: gyroFilepath))
        urls.append(URL(fileURLWithPath: magnetFilepath))
        urls.append(URL(fileURLWithPath: accGyrMagFilepath))
        
        return urls
    }
    
    // 時刻を取得する -> String
    private func nowTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        return format.string(from: Date())
    }
    
    // プル型
    @objc private func recordSensorValue() {
        var tmp = ""
        let now = self.nowTime()
        
        // 3つのセンサデータが取得されたか
        var isAcc = false
        var isGyr = false
        var isMag = false
        
        tmp.append(contentsOf: now + ",")
        // 加速度センサ
        if let data = motionManager.accelerometerData {
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            
            tmp.append(contentsOf: String(x) + ",")
            tmp.append(contentsOf: String(y) + ",")
            tmp.append(contentsOf: String(z) + ",")
            
            var tmp_acc = now + ","
            tmp_acc.append(contentsOf: String(x) + ",")
            tmp_acc.append(contentsOf: String(y) + ",")
            tmp_acc.append(contentsOf: String(z) + "\n")
            
            self.outputAccelerometerData.append(contentsOf: tmp_acc)
            isAcc = true
        }
        
        // ジャイロセンサ
        if let data = motionManager.gyroData {
            let x = data.rotationRate.x
            let y = data.rotationRate.y
            let z = data.rotationRate.z
            
            tmp.append(contentsOf: String(x) + ",")
            tmp.append(contentsOf: String(y) + ",")
            tmp.append(contentsOf: String(z) + ",")
            
            var tmp_gyr = now + ","
            tmp_gyr.append(contentsOf: String(x) + ",")
            tmp_gyr.append(contentsOf: String(y) + ",")
            tmp_gyr.append(contentsOf: String(z) + "\n")
            
            self.outputGyroscopeData.append(contentsOf: tmp_gyr)
            isGyr = true
        }
        
        // 磁気センサ
        if let data = motionManager.magnetometerData {
            let x = data.magneticField.x
            let y = data.magneticField.y
            let z = data.magneticField.z
            
            tmp.append(contentsOf: String(x) + ",")
            tmp.append(contentsOf: String(y) + ",")
            tmp.append(contentsOf: String(z) + "\n")
            
            var tmp_mag = now + ","
            tmp_mag.append(contentsOf: String(x) + ",")
            tmp_mag.append(contentsOf: String(y) + ",")
            tmp_mag.append(contentsOf: String(z) + "\n")
            
            self.outputMagnetometerData.append(contentsOf: tmp_mag)
            isMag = true
        }
        
        // iPod touch用
        if !motionManager.isMagnetometerAvailable {
            // 欠損値で詰める
            tmp.append(contentsOf: String(Double.nan) + ",")
            tmp.append(contentsOf: String(Double.nan) + ",")
            tmp.append(contentsOf: String(Double.nan) + "\n")
            
            var tmp_mag = now + ","
            tmp_mag.append(contentsOf: String(Double.nan) + ",")
            tmp_mag.append(contentsOf: String(Double.nan) + ",")
            tmp_mag.append(contentsOf: String(Double.nan) + "\n")
            
            self.outputMagnetometerData.append(contentsOf: tmp_mag)
            isMag = true
        }
        
        // すべてのデータが取得できた場合はappendする
        if isAcc && isGyr && isMag {
            self.outputAccelGyroMagnetData.append(contentsOf: tmp)
            print(tmp)
        }
        
    }
    
    // センサデータの取得を開始
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
    
    // データをリセットする
    public func resetOutputData() {
        // データ保持用のstringをカラムに初期化する
        self.outputAccelerometerData = ""
        self.outputGyroscopeData = ""
        self.outputMagnetometerData = ""
        self.outputAccelGyroMagnetData = ""
    }
    
    // センサデータの取得を停止
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
}

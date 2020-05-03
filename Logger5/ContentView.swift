//
//  ContentView.swift
//  Logger5
//
//  Created by MacBook Air on 2019/10/11.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var logStarting = false
    @State private var timingChoice = 0
    @State private var autoChoice = 0
    @State private var username = ""
    @State private var label = ""
    
    @State private var accXLabel = "X"
    @State private var accYLabel = "Y"
    @State private var accZLabel = "Z"
    @State private var gyrXLabel = "X"
    @State private var gyrYLabel = "Y"
    @State private var gyrZLabel = "Z"
    @State private var magXLabel = "X"
    @State private var magYLabel = "Y"
    @State private var magZLabel = "Z"
    
    @ObservedObject var sensorLogger = SensorManager()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                // 保存ボタン
                Button(action: {
                    // 保存の処理を書く
                    
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                Spacer()
                // 計測ボタン
                Button(action: {
                    self.logStarting.toggle()
                    
                    if self.logStarting {
                        self.sensorLogger.startUpdate(50.0)
                        self.accXLabel = String(format:  "%.3f", self.sensorLogger.accX)
                        self.accYLabel = String(format: "%.3f", self.sensorLogger.accY)
                        self.accZLabel = String(format: "%.3f", self.sensorLogger.accZ)
                        
                        self.gyrXLabel = String(format: "%.3f", self.sensorLogger.gyrX)
                        self.gyrYLabel = String(format: "%.3f", self.sensorLogger.gyrY)
                        self.gyrZLabel = String(format: "%.3f", self.sensorLogger.gyrZ)
                    }
                    else {
                        self.sensorLogger.stopUpdate()
                        self.accXLabel = "X"
                        self.accYLabel = "Y"
                        self.accZLabel = "Z"
                        self.gyrXLabel = "X"
                        self.gyrYLabel = "Y"
                        self.gyrZLabel = "Z"
                    }
                    
                }) {
                    if self.logStarting {
                        Image(systemName: "pause.circle")
                    }
                    else {
                        Image(systemName: "play.circle")
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            
            
            

            VStack {
                
                VStack {
                   Picker(selection: $timingChoice, label: Text("Timing")) {
                       Text("Immediately").tag(0)
                       Text("After 5 sec").tag(1)
                   }.pickerStyle(SegmentedPickerStyle())
                    
                   Picker(selection: $autoChoice, label: Text("Auto")) {
                       Text("Self").tag(0)
                       Text("Session").tag(2)
                   }.pickerStyle(SegmentedPickerStyle())
                }.padding(.horizontal, 25)
 
            }.padding(25)
            
            HStack {
                TextField("Subject Name", text: $username)

                TextField("Label", text: $label)
            }
            .padding(.leading, 80)
            
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Accelerometer")
                        .font(.headline)
                    
                    HStack {
                        Text("\(self.accXLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.accYLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.accZLabel)")
                            .multilineTextAlignment(.leading)
                        
                    }.padding(.horizontal)
                }.padding(25)
                
                VStack(alignment: .leading) {
                    Text("Gyroscope")
                    .font(.headline)
                    
                    HStack {
                        Text("\(self.gyrXLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.gyrYLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.gyrZLabel)")
                            .multilineTextAlignment(.leading)
                    }.padding(.horizontal)
                }.padding(25)
                
                
                VStack(alignment: .leading) {
                    Text("Magnetometer")
                        .font(.headline)
                    
                    HStack {
                        Text("\(self.magXLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.magYLabel)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(self.magZLabel)")
                            .multilineTextAlignment(.leading)
                    }.padding(.horizontal)
                }.padding(25)
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

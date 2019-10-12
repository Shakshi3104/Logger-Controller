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
    
    @State private var accX: Double = 0.0
    @State private var accY: Double = 0.0
    @State private var accZ: Double = 0.0
    @State private var gyrX: Double = 0.0
    @State private var gyrY: Double = 0.0
    @State private var gyrZ: Double = 0.0
    @State private var magX: Double = 0.0
    @State private var magY: Double = 0.0
    @State private var magZ: Double = 0.0
    
    var body: some View {
        VStack {
            VStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Save")
                }
            }
            VStack {
                HStack {
                    if logStarting {
                        Text("Now Logging")
                    }
                    
                    Toggle(isOn: $logStarting) {
                        Text("")
                    }
                }
                
                VStack {
                   Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Timing")) {
                       Text("Immediately").tag(1)
                       Text("After 5 sec").tag(2)
                   }.pickerStyle(SegmentedPickerStyle())
                    
                   Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Auto")) {
                       Text("Self").tag(1)
                       Text("Session").tag(2)
                   }.pickerStyle(SegmentedPickerStyle())
                }.padding(25)
 
            }.padding(25)
            
            
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Accelerometer")
                        .font(.headline)
                    
                    HStack {
                        Text("accX")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("accY")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("accZ")
                            .multilineTextAlignment(.leading)
                        
                    }
                }.padding(25)
                
                VStack(alignment: .leading) {
                    Text("Gyroscope")
                    .font(.headline)
                    
                    HStack {
                        Text("gyrX")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("gyrY")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("gyrZ")
                            .multilineTextAlignment(.leading)
                    }
                }.padding(25)
                
                
                VStack(alignment: .leading) {
                    Text("Magnetometer")
                        .font(.headline)
                    
                    HStack {
                        Text("magX")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("magY")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("magZ")
                            .multilineTextAlignment(.leading)
                    }
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

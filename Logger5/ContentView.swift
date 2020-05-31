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
    @State private var isSharePresented = false
    @State private var isEmptySubjectLabel = false
    @State private var timingChoice = 0
    @State private var autoChoice = 0
    @State private var username = ""
    @State private var label = ""
    
    @ObservedObject var sensorLogger = SensorLogManager()
    @State private var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 3104)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                // 保存ボタン
                Button(action: {
                    
                    if self.username.count == 0 || self.label.count == 0 {
                        // Subject NameかLabelが空だったら
                        self.isEmptySubjectLabel = true
                        self.isSharePresented = false
                    }
                    else {
                        self.isEmptySubjectLabel = false
                        self.isSharePresented = true
                    }
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Save")
                    }
                }
                .sheet(isPresented: $isSharePresented, content: {
                        // ActivityViewControllerを表示
                        ActivityViewController(activityItems: self.sensorLogger.logger.getDataURLs(label: self.label, subject: self.username), applicationActivities: nil)
                    })
                    .alert(isPresented: $isEmptySubjectLabel, content: {
                        Alert(title: Text("保存できません"), message: Text("Subject NameとLabelを入力してください"))
                    })
                
                Spacer()
                // 計測ボタン
                Button(action: {
                    self.logStarting.toggle()
                    
                    if self.logStarting {
                        self.backgroundTaskID =
                        UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                        self.sensorLogger.startUpdate(50.0)
                    }
                    else {
                        self.sensorLogger.stopUpdate()
                        UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
                    }
                    
                }) {
                    if self.logStarting {
                        HStack {
                            Image(systemName: "pause.circle")
                            Text("Stop")
                        }
                    }
                    else {
                        HStack {
                            Image(systemName: "play.circle")
                            Text("Start")
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            
            
            // モード切り替え
            VStack {
               Picker(selection: $timingChoice, label: Text("Timing")) {
                   Text("Immediately").tag(0)
                   Text("After 5 sec").tag(1)
               }.pickerStyle(SegmentedPickerStyle())
                
               Picker(selection: $autoChoice, label: Text("Auto")) {
                   Text("Self").tag(0)
                   Text("Session").tag(1)
               }.pickerStyle(SegmentedPickerStyle())
            }.padding(25)

            // ラベル情報入力
            HStack {
                TextField("Subject Name", text: $username).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Label", text: $label).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }.padding(.horizontal)
            
            // センサー値を表示
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Accelerometer")
                        .font(.headline)
                    
                    HStack {
                        Text(String(format: "%.3f", self.sensorLogger.accX))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.3f", self.sensorLogger.accY))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.3f", self.sensorLogger.accZ))
                            .multilineTextAlignment(.leading)
                        
                    }.padding(.horizontal)
                }.padding(25)
                
                VStack(alignment: .leading) {
                    Text("Gyroscope")
                    .font(.headline)
                    
                    HStack {
                        Text(String(format: "%.3f", self.sensorLogger.gyrX))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.3f", self.sensorLogger.gyrY))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.3f", self.sensorLogger.gyrZ))
                            .multilineTextAlignment(.leading)
                    }.padding(.horizontal)
                }.padding(25)
                
                
                VStack(alignment: .leading) {
                    Text("Magnetometer")
                        .font(.headline)
                    
                    HStack {
                        Text(String(format: "%.2f", self.sensorLogger.magX))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.2f", self.sensorLogger.magY))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(String(format: "%.2f", self.sensorLogger.magZ))
                            .multilineTextAlignment(.leading)
                    }.padding(.horizontal)
                }.padding(25)
                
            }
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

// UIActivityViewController on SwiftUI
struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//
//  ContentView.swift
//  Logger5
//
//  Created by MacBook Air on 2019/10/11.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @State private var logStarting = false
    @State private var isSharePresented = false
    @State private var isEmptySubjectLabel = false
    @State private var timingChoice = 0
    @State private var autoChoice = 0
    @State private var username = ""
    @State private var label = ""
    
    @State private var viewChoise = 0
    
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

            VStack {
                // ラベル情報入力
                HStack {
                    TextField("Subject Name", text: $username).textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Label", text: $label).textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }.padding(.horizontal)
                
                Picker(selection: $viewChoise, label: Text("View")) {
                    Text("Raw").tag(0)
                    Text("Chart").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20)
    
            }.padding(.vertical, 20)
            
            if self.viewChoise == 0 {
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
                    }.padding(.horizontal, 25)
                        .padding(.vertical, 20)
                    
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
                    }.padding(.horizontal, 25)
                        .padding(.vertical, 20)
                    
                    
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
                    }.padding(.horizontal, 25)
                        .padding(.vertical, 20)
                    
                }
            }
            else if self.viewChoise == 1 {
                HStack {
                    MultiLineChartView(data: [(self.sensorLogger.accXArray, GradientColors.green), (self.sensorLogger.accYArray, GradientColors.orange), (self.sensorLogger.accZArray, GradientColors.blue)], title: "Acc")
                    
                    MultiLineChartView(data: [(self.sensorLogger.gyrXArray, GradientColors.green), (self.sensorLogger.gyrYArray, GradientColors.orange), (self.sensorLogger.gyrZArray, GradientColors.blue)], title: "Gyr")
                }
            }
            
            
        }.onTapGesture {
            // タップしたときにキーボードを下げる
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

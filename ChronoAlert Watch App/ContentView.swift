//
//  ContentView.swift
//  ChronoAlert Watch App
//
//  Created by Arief Setyo Nugroho on 16/02/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTime = Date()
    @State private var showingAlarmSheet = false
    @State private var alarmHour = 0
    @State private var alarmMinute = 0
    @State private var alarmSecond = 0
    @State private var showAlert = false
    @State private var alertShow = false
    @State private var startTime: Date?
    @State private var countingResult: TimeInterval = 0
    
    @State private var showCountingResults = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text(getCurrentTime())
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Text("Hello, world!")
            
            Spacer()
            
            HStack {
                Button(action: {
                    showingAlarmSheet = true
                }) {
                    Text("Set Alarm")
                        .font(.custom("Arial", size: 10))
                        .padding()
                        .foregroundColor(.primary)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .frame(width: 100)
                .sheet(isPresented: $showingAlarmSheet){
                    alarmInputView(alarmHour: $alarmHour, alarmMinute: $alarmMinute, alarmSecond: $alarmSecond)
                }
                
                
                Button(action: {
                    showCountingResults = true
                }) {
                    Text("Get Data")
                        .font(.custom("Arial", size: 10))
                        .padding()
                        .foregroundColor(.primary)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .frame(width: 100)
                .sheet(isPresented: $showCountingResults){
                    CountingResultsView(countingResult: countingResult)
                }
            }
            ///Line Terakhir
        }
        .padding(.top, 16)
        .buttonStyle(BorderlessButtonStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            self.currentTime = Date()
            self.checkAlarm()
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Alarm!"), message: Text("Waktu alarm telah tercapai!"), dismissButton: .default(Text("OK")){
                if let startTime = startTime {
                    let endTime = Date()
                    countingResult = endTime.timeIntervalSince(startTime)
                }
            })
        }

    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: currentTime)
    }
    
    func checkAlarm() {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: currentTime)
        let currentMinute = calendar.component(.minute, from: currentTime)
        let currentSecond = calendar.component(.second, from: currentTime)
        
        if currentHour == alarmHour && currentMinute == alarmMinute && currentSecond == alarmSecond {
            showAlert = true
            startTime = Date()
        }
    }
}

struct alarmInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var alarmHour: Int
    @Binding var alarmMinute: Int
    @Binding var alarmSecond: Int
    @State private var secondText = "01"
    
    var body: some View {
        VStack {
            Text("Set Alarm")
                .font(.custom("Arial", size: 14))
                .padding()
            
            Picker(selection: $alarmHour, label: Text("Hour")){
                ForEach(0..<24) { hour in
                    Text("\(hour)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .frame(width: 100)
            
            Picker(selection: $alarmMinute, label: Text("Minute")) {
                ForEach(0..<60) { minute in
                    Text("\(minute)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .frame(width: 100)
            
            Button(action: {
                if let second = Int(secondText){
                    alarmSecond = second
                }
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .font(.custom("Arial", size: 12))
                    .padding()
                    .foregroundColor(.primary)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .frame(width: .infinity)
        }
        .padding()
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct CountingResultsView: View {
    var countingResult: TimeInterval

    var body: some View {
        List {
            Text("Alarm 1: \(Int(countingResult * 1000)) ms")
        }
        .navigationTitle("Results").font(.custom("Arial", size: 12))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

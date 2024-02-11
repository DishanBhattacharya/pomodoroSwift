//
//  ContentView.swift
//  pomodoro
//
//  Created by Dishan Bhattacharya on 1/28/24.
//

import SwiftUI
import SwiftData
import Combine


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    // Current Time
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    /*
     @State var currentDate: Date = Date()
     var dateFormatter: DateFormatter {
     
     let formatter = DateFormatter()
     formatter.timeStyle = .medium
     return formatter
     
     }
     */
    
    // Countdown
    @State var count: Int = 20
    @State var finishedText: String? = nil
    @State var isCountdownRunning = false
    
    @State private var startTime =  Date()
    @State private var timerString = "9.00"
    
    var body: some View {
        
        ZStack {
        
            Text(finishedText ?? "\(count)")
        }

        Text(self.timerString)
            .font(Font.system(.largeTitle, design: .monospaced))
            .onReceive(timer) { _ in
                if count < 1 {
                    finishedText = "Wow"
                } else {
                    count -= 1
                }
            }
            .onTapGesture {
                if !isCountdownRunning {
                    timerString = "0.00"
                    startTime = Date()
                }
                isCountdownRunning.toggle()
            }

        }
        

        
    
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

    
    #Preview {
        ContentView()
            .modelContainer(for: Item.self, inMemory: true)
    }
    


struct ToDoView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}


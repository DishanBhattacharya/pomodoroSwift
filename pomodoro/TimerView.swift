import SwiftUI

struct CountdownView: View {
    @State private var minutes: Int = 25
    @State private var seconds: Int = 0
    @State private var isCountingDown = false
    @State private var timer: Timer?
    @State private var isTimerOptionsPresented = false

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        restartTimer()
                    }) {
                        Text("Restart")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }

                Spacer()

                Text(String(format: "%02d:%02d", minutes, seconds))
                    .font(.system(size: 90, weight: .regular, design: .serif))
                    .foregroundColor(.white)
                    .onTapGesture {
                        if minutes == 0 && seconds == 0 {
                            isTimerOptionsPresented = true
                        }
                    }

                HStack {
                    Button(action: {
                        if minutes == 0 && seconds == 0 {
                            isTimerOptionsPresented = true
                        } else {
                            toggleTimer()
                        }
                    }) {
                        if isCountingDown {
                            Image(systemName: "pause.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        } else {
                            Image(systemName: "play.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }

                HStack {
                    Button(action: {
                        stopTimer()
                        minutes = 25
                        seconds = 0
                        isTimerOptionsPresented = false
                    }) {
                        Text("25 m")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        stopTimer()
                        minutes = 50
                        seconds = 0
                        isTimerOptionsPresented = false
                        
                    }) {
                        Text("50 m")
                            .padding()
                            .foregroundColor(.black)
                            .background(Color(red:68, green:98, blue:74))
                            .cornerRadius(10)
                    }
                    Button(action: {
                        stopTimer()
                        minutes = 0
                        seconds = 3
                        isTimerOptionsPresented = false
                    }) {
                        Text("25 m")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding()

                Spacer()
            }
        }
        .onDisappear() {
            stopTimer()
        }
        
    }

    private func setPresetTimer(minutes: Int) {
        self.minutes = minutes
        seconds = 0
        stopTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if isCountingDown {
                if minutes == 0 && seconds == 0 {
                    stopTimer()
                } else {
                    if seconds == 0 {
                        minutes -= 1
                        seconds = 59
                    } else {
                        seconds -= 1
                    }
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isCountingDown = false
    }
    private func startShortTimer() {
        if minutes == 0 && seconds == 0 {
            minutes = 5
            seconds = 0
        }
    }

    private func toggleTimer() {
        isCountingDown.toggle()

        if isCountingDown {
            startTimer()
        } else {
            stopTimer()
        }
    }

    private func restartTimer() {
        stopTimer()
        startTimer()
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
            .preferredColorScheme(.dark)
    }
}

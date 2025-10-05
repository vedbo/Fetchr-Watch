import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // 🐾 Pet Info
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("🐾")
                            .font(.title2)
                        Text("C • Siberian Husky")
                            .font(.headline)
                            .bold()
                    }
                    Text("Status: Safe at Home")
                        .font(.caption2)
                        .foregroundColor(.green)
                        .padding(.top, 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    LinearGradient(colors: [.blue.opacity(0.4), .cyan.opacity(0.2)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(14)
                .shadow(radius: 3)
                
                // ❤️ Live Vitals Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Live Vitals")
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    VStack(spacing: 10) {
                        HStack {
                            PulsingVitalCard(icon: "heart.fill",
                                             title: "Heart Rate",
                                             value: "84 bpm",
                                             status: "Normal",
                                             color: .red) {
                                alertMessage = "❤️ Heart Rate Elevated!"
                                showAlert = true
                            }
                            
                            VitalCard(icon: "thermometer",
                                      title: "Body Temp",
                                      value: "70°F",
                                      status: "Stable",
                                      color: .orange) {
                                alertMessage = "🌡️ Body Temperature Normal"
                                showAlert = true
                            }
                        }
                        
                        HStack {
                            VitalCard(icon: "exclamationmark.triangle.fill",
                                      title: "Danger Mode",
                                      value: "Safe",
                                      status: "Inactive",
                                      color: .yellow) {
                                alertMessage = "🚨 Danger Mode Triggered!"
                                showAlert = true
                            }
                            
                            VitalCard(icon: "figure.walk",
                                      title: "Activity",
                                      value: "Playing",
                                      status: "Normal",
                                      color: .green) {
                                alertMessage = "🐕 Pet is currently active!"
                                showAlert = true
                            }
                        }
                    }
                }
                .padding()
                .background(
                    LinearGradient(colors: [.gray.opacity(0.1), .black.opacity(0.05)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(14)
                .shadow(radius: 2)
                
                // 🗺 Locations Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Locations")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    ZStack {
                        Image("rutgers_map")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                            )
                            .frame(height: 120)
                        
                        AnimatedMapPinView()
                            .offset(y: -10)
                    }
                }
            }
            .padding()
        }
        .background(Color.black)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Pet Alert"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}

//
// MARK: - Vital Card Base
//
struct VitalCard: View {
    var icon: String
    var title: String
    var value: String
    var status: String
    var color: Color
    var action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                isPressed = false
                action()
            }
        }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                    .scaleEffect(isPressed ? 1.2 : 1.0)
                Text(value)
                    .font(.headline)
                    .bold()
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(status)
                    .font(.caption2)
                    .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .padding(6)
            .background(
                LinearGradient(colors: [color.opacity(0.25),
                                        color.opacity(0.1)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            )
            .cornerRadius(10)
            .shadow(radius: 1)
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

//
// MARK: - Pulsing Heart Card
//
struct PulsingVitalCard: View {
    var icon: String
    var title: String
    var value: String
    var status: String
    var color: Color
    var action: () -> Void
    @State private var pulse = false

    var body: some View {
        VitalCard(icon: icon, title: title, value: value, status: status, color: color, action: action)
            .overlay(
                Circle()
                    .stroke(color.opacity(0.4), lineWidth: 3)
                    .scaleEffect(pulse ? 1.3 : 1.0)
                    .opacity(pulse ? 0 : 1)
                    .animation(
                        Animation.easeOut(duration: 1.2)
                            .repeatForever(autoreverses: false),
                        value: pulse
                    )
            )
            .onAppear { pulse = true }
    }
}

//
// MARK: - Animated Map Pin
//
struct AnimatedMapPinView: View {
    @State private var drop = false
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.red)
                .font(.title2)
                .scaleEffect(drop ? 1.0 : 2.5)
                .offset(y: drop ? 0 : -60)
                .shadow(radius: 3)
                .animation(.spring(response: 0.6, dampingFraction: 0.5), value: drop)
            
            Text("📍 College Ave Student Center")
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(4)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
                .opacity(drop ? 1 : 0)
                .animation(.easeIn(duration: 0.5).delay(0.4), value: drop)
        }
        .onAppear {
            drop = true
        }
    }
}

#Preview {
    ContentView()
}

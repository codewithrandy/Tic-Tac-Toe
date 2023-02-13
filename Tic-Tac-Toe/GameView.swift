//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Randy McKown on 2/12/23.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        NavigationView {
            Home()
                .preferredColorScheme(.dark)
        }
    }
}

struct Home: View {
    @StateObject private var vm = GameViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.indigo, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                    ForEach(0..<9, id: \.self) {i in
                        ZStack {
                            // Flip Animation
                            Color.teal
                            Color.white
                                .blur(radius: 75)
                                .opacity(vm.moves[i] == nil ? 1 : 0)
                            // Player Indicator
                            Text(vm.moves[i]?.indicator ?? "")
                                .font(.system(size: 55))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .opacity(vm.moves[i] != nil ? 1 : 0)
                        }
                        .frame(width: vm.getDeviceWidth(), height: vm.getDeviceWidth())
                        .cornerRadius(15)
                        .rotation3DEffect(
                            .init(degrees: vm.moves[i] != nil ? 180 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0),
                            anchor: .center,
                            anchorZ: 0.0,
                            perspective: 1.0
                            )
                        // add move on tap
                        .onTapGesture {
                            withAnimation(Animation.easeIn(duration: 0.5)) {
                                vm.processMove(for: i)
                            }
                        }
                    }
                }
                .padding(15)
                .disabled(vm.isGameBoardDisabled)
                .alert(item: $vm.alertItem, content: { alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: .default(alertItem.buttonTitle, action: {vm.resetGame()}))
                })
            }
        }
    }
}

enum Player {
    case human, AI
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "X" : "O"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

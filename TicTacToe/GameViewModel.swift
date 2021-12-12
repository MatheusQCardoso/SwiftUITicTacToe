//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Matheus Quirino on 11/12/21.
//

import SwiftUI

final class GameViewModel: ObservableObject{
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    let writtenSymbols: [Player : String] = [Player.human: "Human",
                                    Player.cpu: "CPU"]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isBoardDisabled = false
    @Published var alertItem: AlertItem?
    @Published var currentPlayerLabel: String = "Human"
    @Published var scoreboard: [Player : Int] = [Player.human: 0, Player.cpu: 0]
    
    func makeMove(for position: Int){
        if isSquareOccupied(in: moves, forIndex: position) { return }
        
        moves[position] = Move(player: .human, boardIndex: position)
        
        if checkWinConditions(for: .human, in: moves) {
            scoreboard[.human]! += 1
            alertItem = AlertContext.winHuman
            return
        }else if checkDrawConditions(in: moves){
            alertItem = AlertContext.draw
            return
        }
        
        //CHANGE TURN TO CPU
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){[self] in
            currentPlayerLabel = writtenSymbols[Player.cpu]!
            isBoardDisabled = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [self] in
            let computerPosition = determineCPUMovePosition(in: moves)
            moves[computerPosition] = Move(player: .cpu, boardIndex: computerPosition)
            
            //CHANGE TURN TO HUMAN
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){[self] in
                currentPlayerLabel = writtenSymbols[Player.human]!
                isBoardDisabled = false
            }
            
            if checkWinConditions(for: .cpu, in: moves){
                scoreboard[.cpu]! += 1
                alertItem = AlertContext.winCPU
                return
            }else if checkDrawConditions(in: moves){
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        //$0 MEANS IT'S A CHECK FOR EVERY INDEX IN THE ARRAY
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineCPUMovePosition(in moves: [Move?]) -> Int {
        //IF CAN WIN, WIN
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5],
                                          [6, 7, 8], [0, 3, 6],
                                          [1, 4, 7], [2, 5, 8],
                                          [0, 4, 8], [2, 4, 6]]
        
        let cpuMoves = moves.compactMap{ $0 }.filter{ $0.player == .cpu }
        let cpuPositions = Set(cpuMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(cpuPositions)
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        //IF HUMAN CAN WIN, BLOCK
        let humanMoves = moves.compactMap{ $0 }.filter{ $0.player == .human }
        let humanPositions = Set(humanMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        //IF CAN'T BLOCK, TAKE MIDDLE SQUARE
        let middleCircleIndex = 4
        if !isSquareOccupied(in: moves, forIndex: middleCircleIndex) { return middleCircleIndex }
        
        //ELSE, TAKE RANDOM MOVE
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinConditions(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                                          [0, 3, 6], [1, 4, 7], [2, 5, 8],
                                          [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap{ $0 }.filter{ $0.player == player }
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){ return true }
        
        return false
    }
    
    func checkDrawConditions(in moves: [Move?]) -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
    
    func restart() {
        resetGame()
        scoreboard[.human] = 0
        scoreboard[.cpu] = 0
    }
    
}

enum Player{
    case human
    case cpu
}

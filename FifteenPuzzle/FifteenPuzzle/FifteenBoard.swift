//
//  FifteenBoard.swift
//  FifteenPuzzle
//
//  Created by Ron Cotton on 2/19/18.
// Copyright © 2018 Ron Cotton.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//import UIKit is not needed, this class needs to know nothing of UIKit...
import Foundation

class FifteenBoard {
    var state : [[Int]] = [
        [1, 2, 3, 4],
        [5, 6, 7 ,8],
        [9, 10, 11, 12],
        [13, 14, 15, 0]  // 0 => empty
    ]

    let rows = 4
    let cols = 4
    
    func random(_ n:Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    } // end random()
    
    func swapTile(fromRow r1: Int, Column c1: Int, toRow r2: Int, Column c2: Int) {
        state[r2][c2] = state[r1][c1]
        state[r1][c1] = 0
    } // end swapTile()

    // Choose one of the “slidable” tiles at random and slide it into the empty space; repeat n times. We use this method to start a new game using a large value (e.g., 150) for n.
    func scramble(numTimes n: Int) {
        resetBoard()
        for _ in 1...n {
            var movingTiles : [(atRow: Int, Column: Int)] = []
            var numMovingTiles : Int = 0
            for r in 0..<rows {
                for c in 0..<cols {
                    if canSlideTile(atRow: r, Column: c) {
                        movingTiles.append((r, c))
                        numMovingTiles = numMovingTiles + 1
                    } // end if canSlideTile()
                } // end for c
            } // end for r
            let randomTile = random(numMovingTiles)
            var moveRow : Int, moveCol : Int
            (moveRow , moveCol) = movingTiles[randomTile]
            slideTile(atRow: moveRow, Column: moveCol)
        } // end for i
    } // end scamble()
    
    // Fetch the tile at the given position (0 is used for the space).
    func getTile(atRow r: Int, atColumn c: Int) -> Int {
        return state[r][c]
    } // end getTile()
    
    // Find the position of the given tile (0 is used for the space) – returns tuple holding row and column.
    func getRowAndColumn(forTile tile: Int) -> (row: Int, column: Int)? {
        if (tile > (rows*cols-1)) {
            return nil
        }
        for x in 0..<rows {
            for y in 0..<cols {
                if ((state[x][y]) == tile) {
                    return (row: x,column: y)
                }
            }
        }
        return nil
    } // end getRowAndColumn()
    
    // Determine if puzzle is in solved configuration.
    func canSlideTileUp(atRow r : Int, Column c : Int) -> Bool {
            return (r < 1) ? false : ( state[r-1][c] == 0 )
    } // end canSlideTileUp
    
    // Determine if the specified tile can be slid up into the empty space.
    func canSlideTileDown(atRow r :  Int, Column c :  Int) -> Bool {
        return (r > (rows-2)) ? false : ( state[r+1][c] == 0 )
    } // end canSlideTileDown
    
    func canSlideTileLeft(atRow r :  Int, Column c :  Int) -> Bool {
            return (c < 1) ? false : ( state[r][c-1] == 0 )
    } // end canSlideTileLeft
    
    func canSlideTileRight(atRow r :  Int, Column c :  Int) -> Bool {
            return (c > (cols-2)) ? false : ( state[r][c+1] == 0 )
    } // end canSlideTileRight
    
    func canSlideTile(atRow r :  Int, Column c :  Int) -> Bool {
        return  (canSlideTileRight(atRow: r, Column: c) ||
            canSlideTileLeft(atRow: r, Column: c) ||
            canSlideTileDown(atRow: r, Column: c) ||
            canSlideTileUp(atRow: r, Column: c))
    } // canSlideTile()

    // Slide the tile into the empty space, if possible.
    // tile is at [r,c]
    // 0 is at [r-1,c], [r+1,c], [r,c-1], [r, c+1]
    func slideTile(atRow r: Int, Column c: Int) {
        // basecase
        if (r > rows || c > cols || r < 0 || c < 0) {
            return
        }
        if (canSlideTile(atRow: r, Column: c)) {
            if (canSlideTileUp(atRow: r, Column: c)) {
                swapTile(fromRow: r, Column: c, toRow: r-1, Column: c)
            }
            if (canSlideTileDown(atRow: r, Column: c)) {
                swapTile(fromRow: r, Column: c, toRow: r+1, Column: c)
            }
            if (canSlideTileLeft(atRow: r, Column: c)) {
                swapTile(fromRow: r, Column: c, toRow: r, Column: c-1)
            }
            if (canSlideTileRight(atRow: r, Column: c)) {
                swapTile(fromRow: r, Column: c, toRow: r, Column: c+1)
            }
        } // end if canSlideTile
    } // end slideTile()
    
    func isSolved() -> Bool {
        var comparison = 1
        for r in 0..<rows {
            for c in 0..<cols {
                if state[r][c] != comparison%16 {
                    return false
                } // end if
                comparison = comparison + 1
            }
        }
        return true
    } // end isSolved()
    
    // reset board to default
    func resetBoard() {
        var set = 1
        for r in 0..<rows {
            for c in 0..<cols {
                state[r][c] = set%16
                set = set + 1
            }
        }
    } // end resetBoard()
} // end FifteenBoard()

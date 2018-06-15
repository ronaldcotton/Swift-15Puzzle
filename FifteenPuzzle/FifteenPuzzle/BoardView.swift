//
//  BoardView.swift
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

import UIKit

class BoardView: UIView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // We want to programmatically control the size and positions of the tile buttons so we override the values computed by the AutoLayout engine. This is accomplished by overriding UIView’s layoutSubviews method. Once the AutoLayout is finished, we immediately reset by assigning to desired values of the bounds and center properties of each button.
    
    // Auxiliary method that determines the largest square that fits in the center of the board view. We make sure the board size of is a multiple of 8 so the tile centers lie on the integer grid
    
    func boardRect() -> CGRect { // get square for holding 4x4 tiles buttons
        let W = self.bounds.size.width
        let H = self.bounds.size.height
        let margin : CGFloat = 0
        let size = ((W <= H) ? W : H) - margin
        let boardSize : CGFloat = CGFloat((Int(size) + 7)/8)*8.0 // next multiple of 8
        let leftMargin = (W - boardSize)/2
        let topMargin = (H - boardSize)/2
        return CGRect(x: leftMargin, y: topMargin, width: boardSize, height: boardSize)
    }
    
    // BoardView method that overrides UIViews layoutSubviews method to position the tile buttons to reflect the state of the board model.
    
    override func layoutSubviews() {
        super.layoutSubviews() // let autolayout engine finish first
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let board = appDelegate.board  // get model from app delegate
        
        let boardSquare = boardRect()  // determine region to hold tiles (see below)
        let tileSize = (boardSquare.width) / 4.0
        let tileBounds = CGRect(x: 0, y: 0, width: tileSize, height: tileSize)
        
        for r in 0 ..< 4 {      // manually set the bounds, and of each tile
            for c in 0 ..< 4 {
                let tile = board!.getTile(atRow: r, atColumn: c)
                if tile > 0 {
                    let button = self.viewWithTag(tile)
                    button!.bounds = tileBounds
                    button!.center = CGPoint(x: boardSquare.origin.x + (CGFloat(c) + 0.5)*tileSize,
                                             y: boardSquare.origin.y + (CGFloat(r) + 0.5)*tileSize)
                }
            }
        }
    } // end layoutSubviews()
    
    func switchTileImages(_ imageOn : Bool) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let board = appDelegate.board  // get model from app delegate
        
        for r in 0..<4 {
            for c in 0..<4 {
                let tile = board!.getTile(atRow: r, atColumn: c)
                if tile > 0 {
                    let button = self.viewWithTag(tile) as! UIButton
                    if (imageOn) {
                        button.setTitle("", for: UIControlState.normal)
                        button.titleEdgeInsets = UIEdgeInsets.zero // no margins
                        button.imageEdgeInsets = UIEdgeInsets.zero
                        button.contentEdgeInsets = UIEdgeInsets.zero
                        //button.layoutMargins = UIEdgeInsets.zero
                        button.contentMode = .center
                        button.imageView?.contentMode = UIViewContentMode.scaleAspectFill
                        //button.imageView?.contentMode = .scaleAspectFit
                        let convert : UIImage? = UIImage(named: String(tile))
                        button.setImage(convert, for: .normal)
                    } else {
                        button.setTitle(String(tile), for: UIControlState.normal)
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
                        button.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                        button.setImage(nil, for: .normal)
                    }
                }
            }
        }
    }
    
    func switchTileOrder(_ shuffle : Bool) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let board = appDelegate.board  // get model from app delegate
        
        if (shuffle) {
            board?.scramble(numTimes: 150)
        } else {
            board?.resetBoard()
        }
    }

} // end BoardView()

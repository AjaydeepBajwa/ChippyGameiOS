//
//  GameScene.swift
//  ChippyGame
//
//  Created by AJAY BAJWA on 2019-10-05.
//  Copyright © 2019 AJAY BAJWA. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player:Player = Player(imageNamed: "player")
    //var playerBullet: SKSpriteNode!
    var playerBullet:Bullet = Bullet(imageNamed: "player_bullet")
    var screenBorder:SKSpriteNode!
    var bulletsArray:[SKSpriteNode] = []
    var upArrow:SKSpriteNode!
    var downArrow:SKSpriteNode!
    var leftArrow:SKSpriteNode!
    var rightArrow:SKSpriteNode!
    var upLeftArrow:SKSpriteNode!
    var downLeftArrow:SKSpriteNode!
    var upRightArrow:SKSpriteNode!
    var downRightArrow:SKSpriteNode!
    var arrowTouched:String = ""
    var touch:UITouch!
    var isTouched:Bool = false
    var mouseX:CGFloat! = 100
    var mouseY:CGFloat! = 100
    
    override func didMove(to view: SKView) {
        // Set the background color of the app
        self.backgroundColor = SKColor.black;
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        print("screen: \(self.size.width), \(self.size.height)")
        
        
        self.player = Player(imageNamed: "player")
        self.player.size.width = self.size.width/13
        self.player.size.height = self.size.height/10
        self.player.position = CGPoint(x: self.size.width - 400, y: self.size.height / 2)
        addChild(self.player)
        
        self.leftArrow = SKSpriteNode(imageNamed: "left")
        self.leftArrow.size = CGSize(width: self.size.width/20, height: self.size.height/15)
        self.leftArrow.position = CGPoint(x: 150, y: 300)
        addChild(self.leftArrow)
        
        self.downArrow = SKSpriteNode(imageNamed: "down")
        self.downArrow.size = CGSize(width: self.size.height/15 , height: self.size.width/25)
        self.downArrow.position = CGPoint(x: self.leftArrow.position.x + self.leftArrow.size.width*1.5, y: self.leftArrow.position.y - self.leftArrow.size.height*1.5)
        addChild(self.downArrow)
        
        self.rightArrow = SKSpriteNode(imageNamed: "right")
        self.rightArrow.size = CGSize(width: self.size.width/20, height: self.size.height/15)
        self.rightArrow.position = CGPoint(x: self.downArrow.position.x + self.leftArrow.size.width*1.5, y: self.leftArrow.position.y)
        addChild(self.rightArrow)
        
        self.upArrow = SKSpriteNode(imageNamed: "up")
        self.upArrow.size = CGSize(width: self.size.height/15, height: self.size.width/25)
        self.upArrow.position = CGPoint(x: self.downArrow.position.x, y: self.leftArrow.position.y + self.leftArrow.size.height*1.5)
        addChild(self.upArrow)
        
        self.upLeftArrow = SKSpriteNode(imageNamed: "upLeft")
        self.upLeftArrow.size = CGSize(width: self.size.height/15, height: self.size.width/25)
        self.upLeftArrow.position = CGPoint(x: self.leftArrow.position.x + self.leftArrow.size.width*0.7, y: self.upArrow.position.y - self.upArrow.size.height*0.7)
        addChild(self.upLeftArrow)
        
        self.downLeftArrow = SKSpriteNode(imageNamed: "downLeft")
        self.downLeftArrow.size = CGSize(width: self.size.height/15, height: self.size.width/25)
        self.downLeftArrow.position = CGPoint(x: self.upLeftArrow.position.x, y: self.downArrow.position.y + self.downArrow.size.height*0.7)
        addChild(self.downLeftArrow)
        
        self.downRightArrow = SKSpriteNode(imageNamed: "downRight")
        self.downRightArrow.size = CGSize(width: self.size.height/15, height: self.size.width/25)
        self.downRightArrow.position = CGPoint(x: self.rightArrow.position.x - self.rightArrow.size.width*0.7, y: self.downLeftArrow.position.y)
        addChild(self.downRightArrow)
        
        self.upRightArrow = SKSpriteNode(imageNamed: "upRight")
        self.upRightArrow.size = CGSize(width: self.size.height/15, height: self.size.width/25)
        self.upRightArrow.position = CGPoint(x: self.downRightArrow.position.x, y: self.upLeftArrow.position.y)
        addChild(self.upRightArrow)
        
        
    }
    override func update(_ currentTime: TimeInterval) {
        self.removeBullet()
        self.moveBulletToTarget()
    }
    func spawnPlayerBullet() {
        // 1. Make a bullet
        
       
        
        if(self.bulletsArray.count <= 1){
            self.playerBullet = Bullet(imageNamed: "player_bullet")
            playerBullet.size.width = self.player.size.width/2
            playerBullet.size.height = self.player.size.height/2
        playerBullet.position = CGPoint(x: self.player.position.x - 30, y: self.player.position.y)
        addChild(playerBullet)
        self.bulletsArray.append(playerBullet)
        }
        //        else{
        //            let previousBullet = self.bulletsArray[self.bulletsArray.count - 1]
        //            playerBullet.position = CGPoint(x: previousBullet.position.x-200, y: self.player.position.y)
        //            addChild(playerBullet)
        //            self.bulletsArray.append(playerBullet)
        //        }
//        let moveBullet = SKAction.moveBy(x: -50, y: 0, duration: 0.05)
//        let indefiniteBulletMove = SKAction.repeatForever(moveBullet)
//        playerBullet.run(indefiniteBulletMove)
//
        
        
        print("size of bullets: \(self.bulletsArray.count)")
        print("x of bullet: \(self.bulletsArray[self.bulletsArray.count-1].position.x)" )
    }

    func movePlayer(){
        
        if ((self.arrowTouched == "up")&&(self.player.position.y < self.size.height)){
            let playerMove = SKAction.moveBy(x: 0, y: 30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / 2
        }
        else if (self.arrowTouched == "down")&&(self.player.position.y > 0){
            let playerMove = SKAction.moveBy(x: 0, y: -30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / -2
        }
        else if (self.arrowTouched == "left")&&(self.player.position.x > 0 ){
            let playerMove = SKAction.moveBy(x: -30, y: 0, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi
            //self.player.position.x = self.player.position.x - 10
        }
        else if (self.arrowTouched == "right")&&(self.player.position.x < self.size.width){
            let playerMove = SKAction.moveBy(x: 30, y: 0, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = 0
            //self.player.position.x = self.player.position.x + 10
        }
        else if (self.arrowTouched == "upRight")&&(self.player.position.x < self.size.width){
            let playerMove = SKAction.moveBy(x: 30, y: 30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / 4
            //self.player.position.x = self.player.position.x + 10
        }
        else if (self.arrowTouched == "downRight")&&(self.player.position.x < self.size.width)&&(self.player.position.y < self.size.height){
            let playerMove = SKAction.moveBy(x: 30, y: -30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / -4
            //self.player.position.x = self.player.position.x + 10
        }
        
        else if (self.arrowTouched == "downLeft")&&(self.player.position.x > 0)&&(self.player.position.y > 0){
            let playerMove = SKAction.moveBy(x: -30, y: -30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / -1.5
            //self.player.position.x = self.player.position.x + 10
        }
        
        else if (self.arrowTouched == "upLeft")&&(self.player.position.x > 0)&&(self.player.position.y < self.size.height){
            let playerMove = SKAction.moveBy(x: -30, y: 30, duration: 0.01)
            self.player.run(playerMove)
            self.player.zRotation = .pi / 1.5
            //self.player.position.x = self.player.position.x + 10
        }
        
        // let indefiniteBulletMove = SKAction.repeatForever(moveBullet)
        
        //        else if (self.arrowTouched == "") {
        //            self.player.position = self.player.position
        //        }
        //self.player.texture = SKTexture(imageNamed: "up")
        
    }
    func removeBullet(){
        //remove bullet after it hits screen edges / Enemy
        //if (self.frame.contains(self.playerBullet.accessibilityFrame) == false){
        if (self.playerBullet.position.x < 1)||(self.playerBullet.position.y > self.size.height)||(self.playerBullet.position.x > self.size.width)||(self.playerBullet.position.y < 0 ) {
            if(self.bulletsArray.count != 0){
                print("x of removed bullet: \(self.playerBullet.position.x)")
                self.bulletsArray.removeAll()
                self.playerBullet.removeFromParent()
            print("No.of bullets: \(self.bulletsArray.count)")
            }
        }
    }
    func moveBulletToTarget() {
        // move the zombie towards the mouse
        // @TODO: Get the android code for moving bullet towards enemey
        // Implement the algorithm in Swift
        // 1. calculate disatnce between mouse and zombie
        
        let movement1 = CGVector(
            dx: (self.mouseX - self.playerBullet.position.x)*5,
            dy: (self.mouseY - self.playerBullet.position.y)*5
        )
        
        let actionTransaction = SKAction.move(by: movement1, duration: 3)
        let repeatAction = SKAction.repeat(actionTransaction, count: 3)
        self.playerBullet.run(repeatAction)
        
//        let a = (self.mouseX - self.playerBullet.position.x);
//        let b = (self.mouseY - self.playerBullet.position.y);
//        let distance = sqrt((a * a) + (b * b))
//
//        // 2. calculate the "rate" to move
//        let xn = (a / distance)
//        let yn = (b / distance)
//
//        // 3. move the bullet
//        let moveBullet = SKAction.moveBy(x: xn*10, y: yn*10, duration: 0.5)
//        //let moveBullet = SKAction.move(to: CGPoint(x: a , y: b ), duration: 0.5)
//        let indefiniteBulletMove = SKAction.repeatForever(moveBullet)
//        playerBullet.run(indefiniteBulletMove)
//        //self.playerBullet.position.x = self.playerBullet.position.x + (xn * 10);
//        //self.playerBullet.position.y = self.playerBullet.position.y + (yn * 10);
//
        
    }

    override
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view?.isMultipleTouchEnabled = true
        //self.touch = touches.first!
        let touch = touches.first!
        self.mouseX = touch.location(in: self).x
        self.mouseY = touch.location(in: self).y
    
        self.player.size.height = self.player.size.height - self.player.size.height/3
        
        if self.upArrow.contains(touch.location(in: self)) {
            print("up touched")
            self.arrowTouched = "up"
            
        }
        else if self.downArrow.contains(touch.location(in: self)) {
            print("down touched")
            self.arrowTouched = "down"

        }
        else if self.leftArrow.contains(touch.location(in: self)) {
            print("left touched")
            self.arrowTouched = "left"
        }
        else if self.rightArrow.contains(touch.location(in: self)) {
            print("right touched")
            self.arrowTouched = "right"
        }
        else if self.upRightArrow.contains(touch.location(in: self)) {
            print("UpRight touched")
            self.arrowTouched = "upRight"
        }
        else if self.downRightArrow.contains(touch.location(in: self)) {
            print("downRight touched")
            self.arrowTouched = "downRight"
        }
        else if self.upLeftArrow.contains(touch.location(in: self)) {
            print("upLeft touched")
            self.arrowTouched = "upLeft"
        }
        else if self.downLeftArrow.contains(touch.location(in: self)) {
            print("downLeft touched")
            self.arrowTouched = "downLeft"
        }
        else{
            self.spawnPlayerBullet()
            
        }
        
        //self.movePlayer()
        self.callback()
        
        guard let mousePosition = touches.first?.location(in: self) else {
            return
        }
        
        print(mousePosition)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.isMultipleTouchEnabled = true
        //self.touch = touches.first!
        let touch = touches.first!
        if self.upArrow.contains(touch.location(in: self)) {
            print("up touched")
            self.arrowTouched = "up"
        }
        else if self.downArrow.contains(touch.location(in: self)) {
            print("down touched")
            self.arrowTouched = "down"
            
        }
        else if self.leftArrow.contains(touch.location(in: self)) {
            print("left touched")
            self.arrowTouched = "left"

        }
        else if self.rightArrow.contains(touch.location(in: self)) {
            print("right touched")
            self.arrowTouched = "right"
        }
        else if self.upRightArrow.contains(touch.location(in: self)) {
            print("UpRight touched")
            self.arrowTouched = "upRight"
        }
        else if self.downRightArrow.contains(touch.location(in: self)) {
            print("downRight touched")
            self.arrowTouched = "downRight"
        }
        else if self.upLeftArrow.contains(touch.location(in: self)) {
            print("upLeft touched")
            self.arrowTouched = "upLeft"
        }
        else if self.downLeftArrow.contains(touch.location(in: self)) {
            print("downLeft touched")
            self.arrowTouched = "downLeft"
        }

        self.moveBulletToTarget()
        self.movePlayer()
        //self.callback()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.arrowTouched = ""
        self.player.size.height = self.size.height/10
        //self.player.texture = SKTexture(imageNamed: "player")
    }
    
    @objc func callback() {
        self.movePlayer()
        // loop in a non blocking way after 0.1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if (self.arrowTouched != "") {
                self.callback()
            }
        }
    }
    
}


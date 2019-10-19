//
//  GameScene.swift
//  ChippyGame
//
//  Created by AJAY BAJWA on 2019-10-05.
//  Copyright © 2019 AJAY BAJWA. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var player:Player = Player(imageNamed: "player")
    var playerHealthNode:SKShapeNode!
    var enemyHealthNode:SKShapeNode!
    var enemy:SKSpriteNode!
    var enemyCore:SKSpriteNode!
    var enemyPartsCount = 0
    var enemyPartPercentage:Double = 0
    //var playerBullet: SKSpriteNode!
    var playerBullet:Bullet = Bullet(imageNamed: "player_bullet")
    var enemyBullet:Bullet = Bullet(imageNamed: "enemyBullet")
    //var screenBorder:SKSpriteNode!
    var bulletsArray:[SKSpriteNode] = []
    var enemyBulletsArray:[SKSpriteNode] = []
    var upArrow:SKSpriteNode!
    var downArrow:SKSpriteNode!
    var leftArrow:SKSpriteNode!
    var rightArrow:SKSpriteNode!
    var upLeftArrow:SKSpriteNode!
    var downLeftArrow:SKSpriteNode!
    var upRightArrow:SKSpriteNode!
    var downRightArrow:SKSpriteNode!
    var reloadBtn:SKSpriteNode!
    var healthUp:SKSpriteNode!
    var shield:SKSpriteNode!
    var shieldBubble:SKSpriteNode!
    var obstacle:SKSpriteNode!
    var arrowTouched:String = ""
    var touch:UITouch!
    var mouseX:CGFloat! = 100
    var mouseY:CGFloat! = 100
    var arrowButtonTouched = false
    var shootBullet = false
    var arrowButtonsRect:CGRect!
    var burstType = 2
    var healthMilliCount = 0
    var shieldMilliCount = 60
    var shieldTimer = 1
    
    override func didMove(to view: SKView) {
        // Set the background color of the app
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = SKColor.black;
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        print("screen: \(self.size.width), \(self.size.height)")
        
        self.player = Player(imageNamed: "player")
        self.player.size.width = self.size.width/15
        self.player.size.height = self.size.height/12
        self.player.position = CGPoint(x: self.size.width*0.2, y: self.size.height / 2)
        addChild(self.player)
        
        self.playerHealthNode = self.scene?.childNode(withName: "playerHealth") as! SKShapeNode
        
        let circle = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 30, height: 50), cornerRadius: 30)
        
        let followCircle = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: false, duration: 5.0)
        let circleAnimation = followCircle.reversed()
        
        self.enemyCore = self.scene?.childNode(withName: "core") as! SKSpriteNode
        
        let image1 = SKTexture(imageNamed: "core1")
        let image2 = SKTexture(imageNamed: "core2")
        let image3 = SKTexture(imageNamed: "core3")
        
        let coreTextures = [image1, image2, image3, image1]
        
        let coreAnimation = SKAction.animate(
            with: coreTextures,
            timePerFrame: 0.4)
        
        let coreAnimationGroup = SKAction.group([circleAnimation.reversed(),coreAnimation])
        self.enemyCore.run(SKAction.repeatForever(coreAnimationGroup))
        
        self.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            self.enemy = node as? SKSpriteNode
            self.enemy.run(SKAction.repeatForever(circleAnimation.reversed()))
            self.enemyPartsCount = self.enemyPartsCount + 1
        }
        self.enemyPartPercentage = Double(100/self.enemyPartsCount)
        print("Total Enemy Parts: \(self.enemyPartsCount)")
        
        self.enemyHealthNode = self.scene?.childNode(withName: "enemyHealth") as! SKShapeNode
        
        self.leftArrow = SKSpriteNode(imageNamed: "left")
        self.leftArrow.size = CGSize(width: self.size.width/25, height: self.size.height/20)
        self.leftArrow.position = CGPoint(x: 100, y: 250)
        addChild(self.leftArrow)
        
        self.downArrow = SKSpriteNode(imageNamed: "down")
        self.downArrow.size = CGSize(width: self.size.height/20 , height: self.size.width/30)
        self.downArrow.position = CGPoint(x: self.leftArrow.position.x + self.leftArrow.size.width*1.5, y: self.leftArrow.position.y - self.leftArrow.size.height*1.5)
        addChild(self.downArrow)
        
        self.rightArrow = SKSpriteNode(imageNamed: "right")
        self.rightArrow.size = CGSize(width: self.size.width/25, height: self.size.height/20)
        self.rightArrow.position = CGPoint(x: self.downArrow.position.x + self.leftArrow.size.width*1.5, y: self.leftArrow.position.y)
        print("righ : \(self.rightArrow.position.x)")
        addChild(self.rightArrow)
        
        self.upArrow = SKSpriteNode(imageNamed: "up")
        self.upArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.upArrow.position = CGPoint(x: self.downArrow.position.x, y: self.leftArrow.position.y + self.leftArrow.size.height*1.5)
        addChild(self.upArrow)
        
        self.upLeftArrow = SKSpriteNode(imageNamed: "upLeft")
        self.upLeftArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.upLeftArrow.position = CGPoint(x: self.leftArrow.position.x + self.leftArrow.size.width*0.7, y: self.upArrow.position.y - self.upArrow.size.height*0.7)
        addChild(self.upLeftArrow)
        
        self.downLeftArrow = SKSpriteNode(imageNamed: "downLeft")
        self.downLeftArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.downLeftArrow.position = CGPoint(x: self.upLeftArrow.position.x, y: self.downArrow.position.y + self.downArrow.size.height*0.7)
        addChild(self.downLeftArrow)
        
        self.downRightArrow = SKSpriteNode(imageNamed: "downRight")
        self.downRightArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.downRightArrow.position = CGPoint(x: self.rightArrow.position.x - self.rightArrow.size.width*0.7, y: self.downLeftArrow.position.y)
        addChild(self.downRightArrow)
        
        self.upRightArrow = SKSpriteNode(imageNamed: "upRight")
        self.upRightArrow.size = CGSize(width: self.size.height/20, height: self.size.width/30)
        self.upRightArrow.position = CGPoint(x: self.downRightArrow.position.x, y: self.upLeftArrow.position.y)
        addChild(self.upRightArrow)
        
        self.reloadBtn = self.scene?.childNode(withName: "reload") as! SKSpriteNode
        
        self.arrowButtonsRect = CGRect(x: 0, y: 0, width: self.rightArrow.position.x + self.rightArrow.size.width/2, height: self.upArrow.position.y + self.upArrow.size.height/2)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.arrowButtonTouched == true {
            self.movePlayer()
        }
        if self.shootBullet == true{
            self.spawnPlayerBullet()
            self.moveBulletToTarget()
        }
        
        self.removeBullet()
        self.bulletHitsEnemy()
        self.spawnEnemyBullet()
        self.removeEnemyBullets()
        
        self.healthMilliCount = self.healthMilliCount + 1
        self.shieldMilliCount = self.shieldMilliCount + 1
        if (self.shieldMilliCount % 240 == 0){
            self.spawnShield()
        }
        if (self.healthMilliCount % 240 == 0){
            self.spawnHealthUp()
        }
        if (self.shieldMilliCount % 200 == 0){
            self.spawnObstacle()
        }
        self.removePowerUp()
        self.playerGetsShield()
        if (self.shieldTimer > 0){
            self.shieldTimer = self.shieldTimer - 1
        }
        if (self.shieldTimer) == 0 {
            self.removePlayerShield()
        }
        self.endGame()
        print("Shield Timer: \(self.shieldTimer)")
    }
    
    
    func spawnPlayerBullet() {
        // 1. Make a bullet
        
        if(self.bulletsArray.count <= 1){
            self.playerBullet = Bullet(imageNamed: "player_bullet")
                        self.playerBullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "player_bullet"), size: self.playerBullet.size)
                        self.playerBullet.physicsBody?.affectedByGravity = false
                        self.playerBullet.physicsBody?.categoryBitMask = 16
                        self.playerBullet.physicsBody?.collisionBitMask = 0
            //self.playerBullet.physicsBody?.contactTestBitMask = 2
            self.playerBullet.size.width = self.player.size.width/2
            self.playerBullet.size.height = self.player.size.height/2
            self.playerBullet.position = CGPoint(x: self.player.position.x - 30, y: self.player.position.y)
            addChild(self.playerBullet)
            self.bulletsArray.append(self.playerBullet)
        }
        print("No. of bullets: \(self.bulletsArray.count)")
    }
    func spawnEnemyBullet(){
        
        
        if (self.enemyBulletsArray.count <= 0){
            self.enemyBullet.zPosition = 4
            if (self.burstType == 1){
                // Shoot enemy Bullets in a cicular burst
                for i in stride(from: 0.1, to: 2*CFloat.pi, by: 0.3){
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)
                    let x = 50*cos(i) + 1480
                    let y = 50*sin(i) + 767
                    let enemyBulletAction = SKAction.applyImpulse(
                        CGVector(dx: CDouble(x - 1480), dy: CDouble(y - 767)),duration: 10)
                    self.enemyBullet.run(enemyBulletAction)
                    
                }
                
            }
            if(self.burstType == 2){
                var duration = 50
                for i in stride(from: 1, to: 4, by: 1){
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet2")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    
                    self.enemyBulletsArray.append(self.enemyBullet)
                    let x =  Float(self.player.position.x)
                    let y =  Float(self.player.position.y)
                    let enemyBulletAction = SKAction.applyImpulse(
                        CGVector(dx: CDouble(x - 1480), dy: CDouble(y - 767)),duration: TimeInterval(duration))
                    self.enemyBullet.run(enemyBulletAction)
                    duration = duration + 20
                    
                }
            }
            //}
            //if (self.enemyBulletsArray.count <= 9){
            if(self.burstType == 3){
                //for i in stride(from: 0, to: 1, by: 1){
                //move up right
                var duration = 20
                for i in 0...3{
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)

                    
                    let circle = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2000, height: 2000), cornerRadius: 1000)
                    let followCircle = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: true, duration: TimeInterval(duration))
                    
                    let circleAnimation = followCircle
                    self.enemyBullet.run((circleAnimation.reversed()))
                    print("enemy bullet position x: \(self.enemyBullet.position.x)")
                    print("enemy bullet position y: \(self.enemyBullet.position.y)")
                    
                    
                    //move down left
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet3")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)
                    
                    let circle2 = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: -2000, height: -2000), cornerRadius: 1000)
                    
                    let followCircle2 = SKAction.follow(circle2.cgPath, asOffset: true, orientToPath: true, duration:  TimeInterval(duration))
                    let circleAnimation2 = followCircle2.reversed()
                    
                    self.enemyBullet.run((circleAnimation2.reversed()))
                    
                    
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet3")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)
                    
                    self.enemyBullet.run((circleAnimation2))
                    
                    self.enemyBullet = Bullet(imageNamed: "enemyBullet")
                    self.enemyBullet.name = "enemyBullet"
                    self.enemyBullet.position = self.enemyCore.position
                    self.enemyBullet.physicsBody = SKPhysicsBody(circleOfRadius: self.enemyBullet.size.width/2)
                    self.enemyBullet.physicsBody?.categoryBitMask = 4
                    self.enemyBullet.physicsBody?.collisionBitMask = 0
                    addChild(self.enemyBullet)
                    self.enemyBulletsArray.append(self.enemyBullet)
                    
                    let circle3 = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2000, height: 2000), cornerRadius: 1000)
                    
                    let followCircle3 = SKAction.follow(circle3.cgPath, asOffset: true, orientToPath: true, duration:  TimeInterval(duration))
                    let circleAnimation3 = followCircle3.reversed()
                    
                    self.enemyBullet.run((circleAnimation3.reversed()))
                    
                    
                    duration = duration + 5
                }
            }
            
            
            
        }
    }
    
    func removeEnemyBullets(){
        //Remove enemy bullets after they hit the borders
        self.enemyBullet.name = "enemyBullet"
        self.enumerateChildNodes(withName: "enemyBullet") {
            node, stop in
            if(self.enemyBulletsArray.count != 0){
                if (node is SKSpriteNode) {
                    let sprite = node as! SKSpriteNode
                    //for i in stride(from: 0.1, to: 2*CFloat.pi, by: 0.3){
                    if (sprite.position.x < 10 || sprite.position.x > self.size.width - 10 || sprite.position.y < 10 || sprite.position.y > self.size.height - 10) {
                        sprite.removeFromParent()
                        self.enemyBulletsArray.removeFirst()
                        print("no.of enemy bullets: \(self.enemyBulletsArray.count)")
                        //}
                    }
                    //remove enemy bullets and decrease player health after they hit player
                    if(sprite.intersects(self.player)){
                        if (self.shieldTimer < 1)&&(self.playerHealthNode.xScale >= 0){
                        sprite.removeFromParent()
                        self.enemyBulletsArray.removeFirst()
                        self.playerHealthNode.xScale = self.playerHealthNode.xScale - (10*5)/100
                        print("no.of enemy bullets: \(self.enemyBulletsArray.count)")
                        }
                    }
                    if(self.enemyBulletsArray.count == 0){
                        
                        if (self.burstType == 1){
                            self.burstType = 2
                        }
                            
                        else if (self.burstType == 2){
                            self.burstType = 3
                        }
                        else if (self.burstType == 3){
                            self.burstType = 1
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    func spawnHealthUp(){
        if(children.contains(where: { $0.name?.contains("healthUp") ?? false }) == false){
            self.healthUp = SKSpriteNode(imageNamed: "healthUp")
            self.healthUp.name = "healthUp"
            self.healthUp.position.x = self.size.width/2
            self.healthUp.position.y = 50
            self.healthUp.physicsBody = SKPhysicsBody(rectangleOf: self.healthUp.size)
            self.healthUp.physicsBody?.categoryBitMask = 1
            self.healthUp.physicsBody?.collisionBitMask = 0
            addChild(self.healthUp)
            
            let healthMove = SKAction.applyImpulse(CGVector(dx: CGFloat.random(in: -(self.size.width)...self.size.width), dy: CGFloat.random(in: self.size.height/2...self.size.height)), duration: 50)
            self.healthUp.run(SKAction.repeatForever(healthMove))
        }
    }
    func spawnShield(){
        if(children.contains(where: { $0.name?.contains("shield") ?? false }) == false){
            self.shield = SKSpriteNode(imageNamed: "shield")
            self.shield.name = "shield"
            self.shield.position.x = self.size.width/2
            self.shield.position.y = 50
            self.shield.physicsBody = SKPhysicsBody(rectangleOf: self.shield.size)
            self.shield.physicsBody?.categoryBitMask = 2
            self.shield.physicsBody?.collisionBitMask = 0
            addChild(self.shield)
            
            let shieldMove = SKAction.applyImpulse(CGVector(dx: CGFloat.random(in: -(self.size.width)...self.size.width), dy: CGFloat.random(in: self.size.height/2...self.size.height)), duration: 50)
            self.shield.run(shieldMove)
        }
    }
    
    func spawnObstacle(){
        if(children.contains(where: { $0.name?.contains("obstacle") ?? false }) == false){
            self.obstacle = SKSpriteNode(imageNamed: "obstacle")
            self.obstacle.name = "obstacle"
            self.obstacle.position.x = CGFloat.random(in: 200...self.size.width)
            self.obstacle.position.y = 50
            self.obstacle.physicsBody = SKPhysicsBody(circleOfRadius: self.obstacle.size.width/2)
            self.obstacle.physicsBody?.categoryBitMask = 32
            self.obstacle.physicsBody?.collisionBitMask = 0
            addChild(self.obstacle)
            
            let obstacleMove = SKAction.applyImpulse(CGVector(dx: CGFloat.random(in: -(self.size.width*0.3)...self.size.width), dy: CGFloat.random(in: (self.size.height/3)...self.size.height)), duration: 50)
            self.obstacle.run(obstacleMove)
            
            
            let image1 = SKTexture(imageNamed: "obstacle1")
            let image2 = SKTexture(imageNamed: "obstacle2")
            let image3 = SKTexture(imageNamed: "obstacle3")
            let image4 = SKTexture(imageNamed: "obstacle4")
            
            let obstacleTextures = [image1, image2, image3, image4, image1]
            
            let obstacleAnimation = SKAction.animate(
                with: obstacleTextures,
                timePerFrame: 0.1)
            self.obstacle.run(SKAction.repeatForever(obstacleAnimation))

            
        }
    }
    func removePowerUp(){
        self.enumerateChildNodes(withName: "shield") {
            node, stop in
            if (node is SKSpriteNode) {
                let shieldSprite = node as! SKSpriteNode
                // Check if the node is not in the scene
                if (shieldSprite.position.x < 40 || shieldSprite.position.x > self.size.width - 40 || shieldSprite.position.y < 40 || shieldSprite.position.y > self.size.height - 40) {
                    shieldSprite.removeFromParent()
                    }
                }
                
            }
        
        self.enumerateChildNodes(withName: "healthUp") {
            node, stop in
            if (node is SKSpriteNode) {
                let healthUpSprite = node as! SKSpriteNode
                // Check if the node is not in the scene
                if (healthUpSprite.position.x < 40 || healthUpSprite.position.x > self.size.width - 40 || healthUpSprite.position.y < 40 || healthUpSprite.position.y > self.size.height - 40) {
                    healthUpSprite.removeFromParent()
                }
                if (healthUpSprite.intersects(self.player)){
                    healthUpSprite.removeFromParent()
                    if self.playerHealthNode.xScale > 0{
                    if (self.playerHealthNode.xScale < (70*5)/100){
                    self.playerHealthNode.xScale = self.playerHealthNode.xScale + (30*5)/100
                    }
                    else {
                       self.playerHealthNode.xScale = 5
                    }
                    }
                }
            }
            
        }
        self.enumerateChildNodes(withName: "obstacle") {
            node, stop in
            if (node is SKSpriteNode) {
                let obstacleSprite = node as! SKSpriteNode
                // Check if the node is not in the scene
                if (obstacleSprite.position.x < 40 || obstacleSprite.position.x > self.size.width - 40 || obstacleSprite.position.y < 40 || obstacleSprite.position.y > self.size.height - 40) {
                    obstacleSprite.removeFromParent()
                }
            }
            
        }
        }
        
        func playerGetsShield(){
            //self.shieldTimer = 1
            self.enumerateChildNodes(withName: "shield") {
                node, stop in
                if (node is SKSpriteNode) {
                    let shieldSprite = node as! SKSpriteNode
                    // Check if the node is not in the scene
                    if(shieldSprite.intersects(self.player))
                    {
                        self.shieldTimer = 120
                        shieldSprite.removeFromParent()
                        self.player.texture = SKTexture(imageNamed: "bubblePlayer")

                    }
                }
        }

    }
    
    func removePlayerShield(){
        self.player.texture = SKTexture(imageNamed: "player")
    }
    
    func endGame(){
        if (self.enemyHealthNode.xScale <= 0.5){
            let congratsMessage = SKLabelNode(text: "Congratulations, You Won!")
            congratsMessage.fontSize = 150
            congratsMessage.fontName = "Avenir"
            congratsMessage.fontColor = UIColor.red
            congratsMessage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            addChild(congratsMessage)
            
            scene!.view?.isPaused = true
            self.enemyHealthNode.removeFromParent()
            
            self.reloadBtn.texture = SKTexture(imageNamed: "playAgain")
            self.reloadBtn.size = CGSize(width: (self.reloadBtn.texture?.size().width)!, height: (self.reloadBtn.texture?.size().height)!)
            self.reloadBtn.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
        }
        if (self.playerHealthNode.xScale <= 0.5){
            let lostMessage = SKLabelNode(text: "You lose!")
            lostMessage.fontSize = 150
            lostMessage.fontName = "Avenir"
            lostMessage.fontColor = UIColor.red
            lostMessage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            addChild(lostMessage)
            
            scene!.view?.isPaused = true
            self.playerHealthNode.removeFromParent()
            
            self.reloadBtn.texture = SKTexture(imageNamed: "playAgain")
            self.reloadBtn.size = CGSize(width: (self.reloadBtn.texture?.size().width)!, height: (self.reloadBtn.texture?.size().height)!)
            self.reloadBtn.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
        }
    }
    
    func movePlayer(){
        
        if (self.arrowTouched == "up"){
            self.player.zRotation = .pi / 2
            if(self.player.position.y < self.size.height - self.player.size.height){
            let playerMove = SKAction.moveBy(x: 0, y: 30, duration: 0.01)
            self.player.run(playerMove)
            }
        }
        else if (self.arrowTouched == "down"){
            self.player.zRotation = .pi / -2
            if(self.player.position.y > 0 + self.player.size.height){
            let playerMove = SKAction.moveBy(x: 0, y: -30, duration: 0.01)
            self.player.run(playerMove)
            }
        }
        else if (self.arrowTouched == "left"){
            self.player.zRotation = .pi
            if(self.player.position.x > 0 + self.player.size.width){
            let playerMove = SKAction.moveBy(x: -30, y: 0, duration: 0.01)
            self.player.run(playerMove)
            }
        }
        else if (self.arrowTouched == "right"){
            self.player.zRotation = 0
            if(self.player.position.x < self.size.width - self.player.size.width){
            let playerMove = SKAction.moveBy(x: 30, y: 0, duration: 0.01)
            self.player.run(playerMove)
            }
        }
        else if (self.arrowTouched == "upRight"){
            self.player.zRotation = .pi / 4
            if(self.player.position.x < self.size.width - self.player.size.width)&&(self.player.position.y < self.size.height - self.player.size.height){
            let playerMove = SKAction.moveBy(x: 30, y: 30, duration: 0.01)
            self.player.run(playerMove)
            }
        }
        else if (self.arrowTouched == "downRight"){
              self.player.zRotation = .pi / -4
            if(self.player.position.x < self.size.width - self.player.size.width)&&(self.player.position.y > self.player.size.height){
            let playerMove = SKAction.moveBy(x: 30, y: -30, duration: 0.01)
            self.player.run(playerMove)
            }
        }
            
        else if (self.arrowTouched == "downLeft"){
             self.player.zRotation = .pi / -1.5
            if(self.player.position.x > 0 + self.player.size.width)&&(self.player.position.y > 0 + self.player.size.height){
            let playerMove = SKAction.moveBy(x: -30, y: -30, duration: 0.01)
            self.player.run(playerMove)
            }
        }
            
        else if (self.arrowTouched == "upLeft"){
            self.player.zRotation = .pi / 1.5
            if(self.player.position.x > 0 + self.player.size.width)&&(self.player.position.y < self.size.height - self.player.size.height){
            let playerMove = SKAction.moveBy(x: -30, y: 30, duration: 0.01)
            self.player.run(playerMove)
            }
        }
        
        
    }
    func removeBullet(){
        
        self.playerBullet.name = "playerBullet"
        self.enumerateChildNodes(withName: "playerBullet") {
            node, stop in
            if(self.bulletsArray.count != 0){
                if (node is SKSpriteNode) {
                    let sprite = node as! SKSpriteNode
                    // Check if the node is not in the scene
                    if (sprite.position.x < 100 || sprite.position.x > self.size.width - 100 || sprite.position.y < 100 || sprite.position.y > self.size.height - 100) {
                        // Remove the Sprite first from Parent then, from Array. else it does not completely removes the sprite and creates memory problems.
                        sprite.removeFromParent()
                        self.bulletsArray.removeFirst()
                        //print("no.of bullets(after crossing screen): \(self.bulletsArray.count)")
                    }
                    if sprite.intersects(self.enemy) {
                        //self.enemy.physicsBody = nil
                        sprite.removeFromParent()
                        self.bulletsArray.removeFirst()
                        print("no. of bullets after hitting: \(self.bulletsArray.count)")
                    }
                    
                }
            }
        }
    }
    func moveBulletToTarget() {
        
        let a = (self.mouseX - self.player.position.x);
        let b = (self.mouseY - self.player.position.y);
        //Caculating angle between a and b
        let angle = atan2(b, a)
        let angleDegrees = angle * (180 / CGFloat.pi);
        //print("Angle: \(angleDegrees)")
        // turning the bullet to destination direction
        self.playerBullet.zRotation = angle
        
        var destination1 = CGPoint.zero
        if b > 0 {
            // move bullet to the top of screen
            destination1.y = self.size.height + self.enemy.size.height*2
        } else {
            // move bullet to the bottom of screen
            destination1.y = -self.enemy.size.height*2
        }
        // X position of destination in proportion to the the Y Position
        destination1.x = self.player.position.x +
            ((destination1.y - self.player.position.y) / b * a)
        
        var destination2 = CGPoint.zero
        if a > 0 {
            // move the bullet to the right of screen
            destination2.x = self.size.width + self.enemy.size.width*2
        } else {
            //move the bullet to the left of screen
            destination2.x = -self.enemy.size.width*2
        }
        destination2.y = self.player.position.y +
            ((destination2.x - self.player.position.x) / a * b)
        
        var destination:CGPoint!
        //comparing the absolute Coordinate values of destination
        if abs(destination1.x) < abs(destination2.x) || abs(destination1.y) < abs(destination2.y) {
            destination = destination1
        }
        else {
            destination = destination2
        }
        
        if (((self.player.position.y - 30)...(self.player.position.y)).contains(self.mouseY)){
            let bulletAction = SKAction.applyImpulse(CGVector(dx: mouseX - self.player.position.x , dy: mouseY - self.player.position.y), duration: 0.5)
            self.playerBullet.run(bulletAction)
        }
        else {
            let bulletVector = CGVector(dx: destination.x - self.player.position.x, dy: destination.y - self.player.position.y)
            // Shoot the bullet to destination
            self.playerBullet.physicsBody?.velocity = bulletVector
        }
    }
    
    
    func bulletHitsEnemy(){
        self.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            self.enemy = node as? SKSpriteNode
            if self.playerBullet.intersects(self.enemy){
                self.enemy.removeFromParent()
                self.removeBullet()
                print("enemy removed")
                self.enemyPartsCount = self.enemyPartsCount - 1
                self.enemyHealthNode.xScale = self.enemyHealthNode.xScale - CGFloat((self.enemyPartPercentage * 5)/100)
            }
        }
    }
    //    func bulletHitsPlayer(){
    //        self.enumerateChildNodes(withName: "enemybullet") {
    //            (node, stop) in
    //            let bulletSprite = node as? SKSpriteNode
    //            if bulletSprite!.intersects(self.player){
    //                self.enemy.removeFromParent()
    //                self.removeBullet()
    //                print("enemy removed")
    //                self.enemyPartsCount = self.enemyPartsCount - 1
    //                self.enemyHealthNode.xScale = self.enemyHealthNode.xScale - CGFloat((self.enemyPartPercentage * 5)/100)
    //            }
    //        }
    //    }
    
    func checkArrowTouched(){
        
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
    }
    
    override
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view?.isMultipleTouchEnabled = true
        self.touch = touches.first!
        //let touch = touches.first!
        self.mouseX = touch.location(in: self).x
        self.mouseY = touch.location(in: self).y
        
        self.player.size.height = self.player.size.height - self.player.size.height/3
        
        if (self.arrowButtonsRect.contains(touch.location(in: self))){
            self.arrowButtonTouched = true
            self.checkArrowTouched()
        }
        else {
            self.shootBullet = true
            //self.spawnBulletsCallBack()
        }
        if (self.reloadBtn.contains(touch.location(in: self))){
            //Remove the Scene Children
            self.removeAllChildren()
            self.removeAllActions()
            
            print("Restarted")
            //Present the scene again
            let scene = SKScene(fileNamed: "GameScene")
            scene!.scaleMode = .aspectFill
            view!.presentScene(scene)
            
            
        }
        
        
        guard let mousePosition = touches.first?.location(in: self) else {
            return
        }
        
        print(mousePosition)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.isMultipleTouchEnabled = true
        self.touch = touches.first!
        //let touch = touches.first!
        
        self.mouseX = touch.location(in: self).x
        self.mouseY = touch.location(in: self).y
        
        if (self.arrowButtonsRect.contains(touch.location(in: self))){
            self.arrowButtonTouched = true
            self.checkArrowTouched()
        }
        else{
            self.shootBullet = false
            self.spawnPlayerBullet()
            self.moveBulletToTarget()
        }
        
        //self.callback()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.arrowTouched = ""
        self.shootBullet = false
        self.arrowButtonTouched = false
        self.shootBullet = false
        self.player.size.height = self.size.height/12
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
    @objc func spawnBulletsCallBack(){
        self.spawnPlayerBullet()
        self.moveBulletToTarget()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if (self.shootBullet == true){
                self.spawnBulletsCallBack()
            }
        }
    }
    @objc func spawnEnemyBulletsCallBack(){
        self.spawnEnemyBullet()
        //self.moveBulletToTarget()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if (self.enemyBulletsArray.count == 0){
                self.spawnEnemyBulletsCallBack()
            }
        }
    }
    
}


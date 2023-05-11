import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    enum ButtonAssociation {
        case movementAnalog
        case combosAnalog
    }
    
    /// struct constants vai ter todos os valores constantes ao longo do jogo, cores e etc
    var constants: Constants {
        return Constants(frame: frame)
    }
    
    // lista de plataformas existentes na cena. todas sao desenhadas no começo do jogo
    var platforms: [SKSpriteNode] = []
    var player: Player = Player(sprite: "")
    var spiders: [EnemySpider] = []
    var toDie: Int = 3
    
    var background = SKSpriteNode(texture: SKTexture(imageNamed: "MainScene"))
    
    private var touches: [(UITouch, ButtonAssociation)] = []
    
    private var movementInput = SKShapeNode()
    private var movementInputThreshold = SKShapeNode()
    
    private var combosInput = SKShapeNode()
    private var numberEnemies = Int.random(in: 1..<5)
    private var combosInputThreshold = SKShapeNode()
    
    private var combosStartPosition: CGPoint?
    private var directionsCombos: [Directions] = []
    private var movementStartPosition: CGPoint?
    
    private var analogicInputMinThreshold: CGFloat = 20 // quanto maior o valor, maior o movimento para registrar input
    private var analogicInputMaxThreshold: CGFloat = 150 // quanto maior o valor, maior o movimento para registrar input
    
    private var directionsToMove: [Directions] = []
    private var jumpCounter = 0
    private var jumped = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let camera = camera else { return }
        
        for t in touches {
            let pos = t.location(in: camera)
            
            if movementInput.contains(pos) {
                movementStartPosition = pos
                self.touches.append((t, .movementAnalog))
            }
            
            if combosInput.contains(pos) {
                combosStartPosition = pos
                self.touches.append((t, .combosAnalog))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let camera = camera else { return }
        
        for t in self.touches {
            let pos = t.0.location(in: camera)
            
            if t.1 == .movementAnalog {
                guard let start = movementStartPosition else { return }
                
                handleMovement(start: start, pos: pos)
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let camera = camera else { return }
    
        self.touches = self.touches.filter({ (t, i) in
            guard touches.contains(t) else { return true }
            
            switch i {
                
            case .movementAnalog:
                directionsToMove = []
                movementStartPosition = nil
                
            case .combosAnalog:
                let pos = t.location(in: camera)
                guard let start = combosStartPosition else { return true }
                
                handleCombo(start: start, pos: pos)
            }
            
            return false
        })
    }
    
    private func handleMovement(start: CGPoint, pos: CGPoint) {
        let vector = pos - start
        
        directionsToMove = Directions.calculateDirections(vector).filter { dir in
            dir != .down
        }
    }
    
    private func handleCombo(start: CGPoint, pos: CGPoint) {
        let vector = pos - start
        let directions = Directions.calculateDirections(vector)
        
        if directionsCombos.count == 2 {
            let normalizedVector = vector.normalized()
            let magic = Magics.magic(primary: directionsCombos[0], secondary: directionsCombos[1])
            
            // MARK: call combo with vector and magic
        } else {
            directionsCombos.append(directions[0])
        }
        
        combosStartPosition = nil
    }
    
    /// quando a view chamar a cena, esta funçao é a primeira a ser executada.
    ///  é a preparaçao da cena.
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        background.zPosition = -10
        background.size = CGSize(width: frame.width * 2, height: frame.height * 2)
        addChild(background)
        
        // ------------------------------------------------------------------------
        setupGround()
        // ------------------------------------------------------------------------
        setupPlayer()
        // ------------------------------------------------------------------------
        setupCamera()
        // ------------------------------------------------------------------------
        for i in 1...2{
            delayWithSeconds(5.0 * Double(i)) { [self] in
                self.setupSpawn(position: CGPoint(x: frame.midX, y: frame.midY - 20), spriteName: "VillainFinal2")
            }
        }
        //         ------------------------------------------------------------------------
        setupButtons()
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func didBegin(_ contact:SKPhysicsContact){
        if (contact.bodyA.node?.name == "platform" && contact.bodyB.node?.name == "Player") || (contact.bodyA.node?.name == "Player" && contact.bodyB.node?.name == "platform") {
            self.jumpCounter = 0
            player.transition(to: .landing)
            player.transition(to: .idle)
        }
        else if (contact.bodyA.node?.name == "platform" && contact.bodyB.node?.name == "Spider") || (contact.bodyA.node?.name == "Spider" && contact.bodyB.node?.name == "platform"){
            for spider in spiders{
                if spider.physicsBody === contact.bodyA || spider.physicsBody === contact.bodyB{
                    if spider.currentState == .attack{
                        var copy = spider
                        copy.transition(to: .walking)
                        copy.attributes.velocity.maxYSpeed /= 100
                        copy.attributes.velocity.maxXSpeed /= 100
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        camera?.position = player.position
        for spider in spiders{
            spider.moveAI(player: player.sprite)
        }
        updtatePlayerState()
        updtateSpidersState()
        
        guard !directionsToMove.isEmpty else { return }
        if player.currentState == .jump || (player.currentState == .airborne && jumpCounter >= 3) {
            directionsToMove.removeAll { dir in
                dir == .up
            }
        }
        
        if directionsToMove.contains(.up) {
            player.transition(to: .jump)
            jumpCounter += 1
        }
        
        player.move(direction: directionsToMove)
        
        if player.sprite.physicsBody!.velocity.dx < 0{
            player.sprite.xScale = -1
        }
        else{
            player.sprite.xScale = 1
        }
    }
    
    func updtatePlayerState(){
        if player.currentState == .jump {
            if player.physicsBody.velocity.dy < 0{
                player.transition(to: .airborne)
                
            }
            player.physicsBody.collisionBitMask = player.physicsBody.collisionBitMask & (1111111111 - Constants.groundMask)
            player.physicsBody.contactTestBitMask = player.physicsBody.contactTestBitMask & (1111111111 - Constants.groundMask)
        }
        if player.currentState == .airborne{
            if player.sprite.physicsBody!.collisionBitMask & Constants.groundMask == 0 {
                var hasCollided = false
                for platform in platforms {
                    if platform.intersects(player.sprite){
                        hasCollided = true
                    }
                }
                if !hasCollided {
                    player.physicsBody.collisionBitMask = player.physicsBody.collisionBitMask + Constants.groundMask
                    player.physicsBody.contactTestBitMask = player.physicsBody.contactTestBitMask + Constants.groundMask
                }
            }
        }
        if player.currentState == .idle {
            if player.physicsBody.velocity.dx != 0 {
                player.transition(to: .walking)
            }
        }
        else if player.currentState == .walking {
            if player.physicsBody.velocity.dx == 0 {
                player.transition(to: .idle)
            }
        }
    }
    
    
    func updtateSpidersState(){
        for spider in spiders{
            if spider.currentState == .attack{
                if spider.sprite.physicsBody!.collisionBitMask & Constants.groundMask == 0 {
                    var hasCollided = false
                    let fakeNode = SKSpriteNode(color: .black, size: CGSize.zero)
                    fakeNode.anchorPoint = CGPoint(x: 0.5, y: -1)
                    fakeNode.physicsBody = SKPhysicsBody(rectangleOf: Constants.spiderSize, center: spider.position)
                    for platform in platforms {
                        if platform.intersects(fakeNode){
                            hasCollided = true
                        }
                    }
                    if !hasCollided {
                        spider.physicsBody.collisionBitMask = spider.physicsBody.collisionBitMask | Constants.groundMask
                        spider.physicsBody.contactTestBitMask = spider.physicsBody.contactTestBitMask | Constants.groundMask
                    }
                }
            }
            print(spider.currentState)
        }
    }
    
    func setupButtons() {
        let sqrSize: CGFloat = 200
        let sqrPos: CGFloat = 250
        
        movementInput = SKShapeNode(rectOf: CGSize(width: sqrSize, height: sqrSize))
        movementInputThreshold = SKShapeNode(rectOf: CGSize(width: sqrSize * 2, height: sqrSize * 2))
        
        movementInput.position = CGPoint(x: frame.minX + sqrPos, y: frame.minY + sqrPos)
        movementInputThreshold.position = CGPoint(x: frame.minX + sqrPos, y: frame.minY + sqrPos)
        
        movementInput.strokeColor = .red
        movementInputThreshold.strokeColor = .red // set to clear
    
        // ------------------------------------------------------------------------------------------
        
        combosInput = SKShapeNode(rectOf: CGSize(width: sqrSize, height: sqrSize))
        combosInputThreshold = SKShapeNode(rectOf: CGSize(width: sqrSize * 2, height: sqrSize * 2))

        combosInput.position = CGPoint(x: frame.maxX - sqrPos, y: frame.minY + sqrPos)
        combosInputThreshold.position = CGPoint(x: frame.maxX - sqrPos, y: frame.minY + sqrPos)
        
        combosInput.strokeColor = .blue
        combosInputThreshold.strokeColor = .blue // set to clear
        
        // ------------------------------------------------------------------------------------------
        
        camera?.addChild(movementInput)
        camera?.addChild(movementInputThreshold)
        
        camera?.addChild(combosInput)
        camera?.addChild(combosInputThreshold)
    }
    //Constants.spiderIdleTexture
    func setupSpawn(position: CGPoint, spriteName: String){
        if(spriteName == "VillainFinal2"){
            let enemy = setupSpider(spriteName: "VillainFinal2")
            enemy.sprite.position = position
            spiders.append(enemy)
            addChild(enemy.sprite)
        }
    }

    func setupCamera() {
        let camera = SKCameraNode()
        camera.setScale(0.7)
        self.camera = camera
        addChild(camera)
    }
    
    func createPlatform(size: CGSize, position: CGPoint, sprite: String){
        let platform = SKSpriteNode(imageNamed: sprite)
        platform.size = size
        // settando o anchor point para ser no meio horizontal e no baixo na vertical
        platform.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // posicao do platform é zero no x e o mais baixo no y
        platform.position = position
        // criando o physicsbody e settando que nao é dinamico p nenhuma força poder ser aplicada contra ele
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height * 0.9))
        platform.physicsBody?.isDynamic = false
        platform.name = "platform"
        platform.zPosition = -5
        platform.physicsBody?.categoryBitMask = Constants.groundMask
        platforms.append(platform)
        platform.physicsBody?.friction = 0.7
        addChild(platform)
    }
    
    func setupGround(){
        //cria o chao
        createPlatform(size: CGSize(width: frame.width, height: frame.height/4), position: CGPoint(x: 0, y: frame.minY), sprite: "Plataform1")
        // ------------------------------------------------------------------------
        //cria plataforma esquerda
        createPlatform(size: CGSize(width: frame.width/3, height: constants.platformsHeight), position: CGPoint(x: frame.minX + frame.width/6, y: frame.midY), sprite: "Plataform3")
        // ------------------------------------------------------------------------
        //cria plataforma direita
        createPlatform(size: CGSize(width: frame.width/3, height: constants.platformsHeight), position: CGPoint(x: frame.maxX - frame.width/6, y: frame.midY), sprite: "Plataform2")
        // ------------------------------------------------------------------------
    }
    
    func setupPlayer(){
        //Creates player and adds it to the scene
        player = Player(sprite: "MagoFrente")
        player.sprite.position.y += frame.maxY
        addChild(player.sprite)
    }
    
    func setupSpider(spriteName: String) -> EnemySpider{
        let spider = EnemySpider(sprite: spriteName, attributes: AttributesInfo(health: 10, defense: 20, weakness: [], velocity: VelocityInfo(xSpeed: 50, ySpeed: 10, maxXSpeed: 200, maxYSpeed: 5000), attackRange: frame.width * 0.3), player: player)
        return spider
    }
}

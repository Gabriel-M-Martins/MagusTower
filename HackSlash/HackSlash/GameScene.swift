import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
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
    
    private var movementInput = SKShapeNode()
    private var combosInput = SKShapeNode()
    
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        let tappedNode = atPoint(convertPoint(fromView: recognizer.location(in: view)))
        
        guard let nodeName = tappedNode.name else { return }
        
        if nodeName == "movementInput" {
            print(player.currentState)
            player.move(direction: [.up])
            player.transition(to: .jump)
            print(player.currentState)
            return
        }
        
        if nodeName == "combosInput" {
            // implement attack stuff
            return
        }
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
        setupSpider(spriteName: "VillainFinal2", position: CGPoint(x: frame.midX, y: frame.midY - 200))

        setupButtons()
        // ------------------------------------------------------------------------
        setupGestures()

    }
    
    
    func didBegin(_ contact:SKPhysicsContact){
        if (contact.bodyA.node?.name == "Spider" && contact.bodyB.node?.name == "Player") || (contact.bodyA.node?.name == "Player" && contact.bodyB.node?.name == "Spider"){
            toDie -= 1
            if toDie == 0{
                for idx in 0..<spiders.count{
                    var spider = spiders[idx]
                    if spider.physicsBody === contact.bodyA || spider.physicsBody === contact.bodyB{
                        spider.transition(to: .charging)
                    }
                    spiders[idx] = spider
                }
            }
            player.transition(to: .idle)
            print("foi")
        }
        
        if (contact.bodyA.node?.name == "platform" && contact.bodyB.node?.name == "Player") || (contact.bodyA.node?.name == "Player" && contact.bodyB.node?.name == "platform") {
            print(player.currentState)
            player.transition(to: .idle)
            print(player.currentState)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        camera?.position = player.position
        for spider in spiders{
            spider.moveAI(player: player.sprite)
        }
        updtatePlayerState()
        updtateSpidersState()
    }
    
    func updtatePlayerState(){
        if player.currentState == .jump {
            if player.physicsBody.velocity.dy < 0{
                player.currentState = .airborne
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
    }
    
    
    func updtateSpidersState(){
        for spider in spiders{
            if spider.currentState == .goingUp{
                if spider.physicsBody.velocity.dy < 0{
                    spider.currentState = .attack
                }
                spider.physicsBody.collisionBitMask = spider.physicsBody.collisionBitMask & (1111111111 - Constants.groundMask)
                spider.physicsBody.contactTestBitMask = spider.physicsBody.contactTestBitMask & (1111111111 - Constants.groundMask)
            }
            if spider.currentState == .attack{
                if spider.sprite.physicsBody!.collisionBitMask & Constants.groundMask == 0 {
                    var hasCollided = false
                    for platform in platforms {
                        if platform.intersects(spider.sprite){
                            hasCollided = true
                        }
                    }
                    if !hasCollided {
                        spider.physicsBody.collisionBitMask = spider.physicsBody.collisionBitMask + Constants.groundMask
                        spider.physicsBody.contactTestBitMask = spider.physicsBody.contactTestBitMask + Constants.groundMask
                    }
                }
            }
        }
    }
    
    func setupButtons() {
        movementInput = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
        movementInput.name = "movementInput"
        movementInput.position = CGPoint(x: frame.minX + 250, y: frame.minY + 250)
        movementInput.strokeColor = .red

        combosInput = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
        combosInput.name = "combosInput"
        combosInput.position = CGPoint(x: frame.maxX - 250, y: frame.minY + 250)
        combosInput.strokeColor = .blue
        
        camera?.addChild(movementInput)
        camera?.addChild(combosInput)
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        view?.addGestureRecognizer(tap)
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
        platform.anchorPoint = CGPoint(x: 0.5, y: 0)
        // posicao do platform é zero no x e o mais baixo no y
        platform.position = position
        // criando o physicsbody e settando que nao é dinamico p nenhuma força poder ser aplicada contra ele
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height * 2))
        platform.physicsBody?.isDynamic = false
        platform.name = "platform"
        platform.zPosition = -1
        platform.physicsBody?.contactTestBitMask = Constants.groundMask
        platform.physicsBody?.collisionBitMask = Constants.groundMask
        platform.physicsBody?.categoryBitMask = Constants.groundMask
        platforms.append(platform)
        addChild(platform)
    }
    
    func setupGround(){
        //cria o chao
        createPlatform(size: CGSize(width: frame.width, height: frame.height/4), position: CGPoint(x: 0, y: frame.minY), sprite: "UnderGroundReal")
        // ------------------------------------------------------------------------
        //cria plataforma esquerda
        createPlatform(size: CGSize(width: frame.width/3, height: constants.platformsHeight), position: CGPoint(x: frame.minX + frame.width/6, y: frame.midY), sprite: "UnderGroundReal")
        // ------------------------------------------------------------------------
        //cria plataforma direita
        createPlatform(size: CGSize(width: frame.width/3, height: constants.platformsHeight), position: CGPoint(x: frame.maxX - frame.width/6, y: frame.midY), sprite: "UnderGroundReal")
        // ------------------------------------------------------------------------
    }
    
    func setupPlayer(){
        //Creates player and adds it to the scene
        player = Player(sprite: "MagoFrente")
        player.sprite.position.y += frame.maxY
        addChild(player.sprite)
    }
    
    func setupSpider(spriteName: String, position: CGPoint){
        var spider = EnemySpider(sprite: spriteName, attributes: AttributesInfo(health: 10, defense: 20, weakness: [], velocity: VelocityInfo(xSpeed: 150, ySpeed: 10, maxXSpeed: 150, maxYSpeed: 10), attackRange: frame.width * 0.3))
        spider.sprite.position = position
        spiders.append(spider)
        addChild(spider.sprite)
    }
}

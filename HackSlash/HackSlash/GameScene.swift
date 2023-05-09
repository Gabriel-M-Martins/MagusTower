import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    /// struct constants vai ter todos os valores constantes ao longo do jogo, cores e etc
    var constants: Constants {
        return Constants(frame: frame)
    }

    var player: Player = Player(sprite: "")
    var spider: EnemySpider = EnemySpider(sprite: "", attributes: AttributesInfo(health: 10, defense: 1, weakness: [], velocity: VelocityInfo(xSpeed: 0, ySpeed: 0, maxXSpeed: 0, maxYSpeed: 0)))
    var toDie: Int = 3
    
    var background = SKSpriteNode(texture: SKTexture(imageNamed: "MainScene"))
    
    private var movementInput = SKShapeNode()
    private var combosInput = SKShapeNode()
    
    private var frameMultiplier: CGFloat = 4
    
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        let tappedNode = atPoint(convertPoint(fromView: recognizer.location(in: view)))
        
        guard let nodeName = tappedNode.name else { return }
        
        if nodeName == "movementInput" {
            player.move(direction: [.up])
            player.transition(to: .jump)
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
        
        self.setScale(4)
        
        background.zPosition = -10
        background.size = CGSize(width: frame.width, height: frame.height)
//        background.size = CGSize(width: frame.width * frameMultiplier, height: frame.height * frameMultiplier)
        addChild(background)
        
        // ------------------------------------------------------------------------
//        setupGround()
        setupGround2()
        // ------------------------------------------------------------------------
//        setupPlayer()
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
                spider.transition(to: .charging)
            }
            player.transition(to: .idle)
        }
        
        if (contact.bodyA.node?.name == "platform" && contact.bodyB.node?.name == "Player") || (contact.bodyA.node?.name == "Player" && contact.bodyB.node?.name == "platform") {
            player.transition(to: .idle)
        }
    }
    
    
    func setupGround2() {
        guard let mapInterpreter = MapInterpreter(map: frame, platformHeight: frame.height/10) else { return }
        
        for i in mapInterpreter.rects {
            self.createPlatform(size: i.size, position: i.position, sprite: "UnderGroundReal")
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        camera?.position = player.position
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
        camera.setScale(2)
//        camera.setScale(0.7)
        self.camera = camera
        addChild(camera)
    }
    
    func createPlatform(size: CGSize, position: CGPoint, sprite: String){
        let platform = SKSpriteNode(imageNamed: sprite)
        platform.size = size
        // settando o anchor point para ser no meio horizontal e no baixo na vertical
        platform.anchorPoint = CGPoint(x: 0, y: 0)
//        platform.anchorPoint = CGPoint(x: 0.5, y: 0)
        // posicao do platform é zero no x e o mais baixo no y
        platform.position = position
        // criando o physicsbody e settando que nao é dinamico p nenhuma força poder ser aplicada contra ele
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height * 2))
        platform.physicsBody?.isDynamic = false
        platform.name = "platform"
        platform.physicsBody?.contactTestBitMask = Constants.groundMask
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
        spider = EnemySpider(sprite: spriteName, attributes: AttributesInfo(health: 10, defense: 20, weakness: [], velocity: VelocityInfo(xSpeed: -5, ySpeed: 10, maxXSpeed: 5, maxYSpeed: 10)))
        spider.sprite.position = position
        addChild(spider.sprite)
    }
}


extension CGRect {
    mutating func scale(by value: Float) {
        self.size = CGSize(width: size.width * CGFloat(value), height: size.height * CGFloat(value))
    }
}

//
//  ViewController.swift
//  VideoRioPoker
//
//  Created by Alessandra Nishikawa on 17-10-25.
//  Copyright © 2017 Alessandra Nishikawa. All rights reserved.
//

//----------------------//----------------------
import UIKit
//----------------------//----------------------
class ViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel! //Connexion et déclaration de la Label "BONNE CHANCE".
    //---
    //Connexion et déclaration des Slots views. Chaque Slot view qui va contenir la imageview de la carte, le bouton pour executer la action de guarder, et le label "guarder".
    @IBOutlet weak var slot_1: UIImageView!
    @IBOutlet weak var slot_2: UIImageView!
    @IBOutlet weak var slot_3: UIImageView!
    @IBOutlet weak var slot_4: UIImageView!
    @IBOutlet weak var slot_5: UIImageView!
    //---
    
    //Déclaration des cartes blur, qui vont apparaissent quand la exection du bouton Distribuer.
    var card_blur_1: UIImage!
    var card_blur_2: UIImage!
    var card_blur_3: UIImage!
    var card_blur_4: UIImage!
    var card_blur_5: UIImage!
    //---
    
    //Connexion et déclaration des cartes, backgrounds et cartes dans le jeu.
    @IBOutlet weak var bg_1: UIView!
    @IBOutlet weak var bg_2: UIView!
    @IBOutlet weak var bg_3: UIView!
    @IBOutlet weak var bg_4: UIView!
    @IBOutlet weak var bg_5: UIView!
    //---
    
    //Connexion et déclaration des labels "Guarder" de chaque carte.
    @IBOutlet weak var keep_1: UILabel!
    @IBOutlet weak var keep_2: UILabel!
    @IBOutlet weak var keep_3: UILabel!
    @IBOutlet weak var keep_4: UILabel!
    @IBOutlet weak var keep_5: UILabel!
    //---
    @IBOutlet weak var dealButton: UIButton!  //Connexion et déclaration du bouton "DISTRIBUER".
    @IBOutlet weak var creditsLabel: UILabel! //Connexion et déclaration de la label "CRÉDITS".
    @IBOutlet weak var betLabel: UILabel! //Connexion et déclaration de la label "MISE".
    //---
    var arrOfCardImages: [UIImage]! //Déclaration du tableau  Cards Images.
    //---
    var arrOfSlotImageViews: [UIImageView]! //Déclaration du tableau  Slot Imagem View.
    //---
    var deckOfCards = [(Int, String)]() //Déclaration de la variable Deck of Cards qui va contenir un nombre et un nom.
    //---
    var arrOfBackgrounds: [UIView]! //Déclaration du tableau de background de chaque carte.
    //---
    var arrOfKeepLabels: [UILabel]! //Déclaration de la label "GARDER".
    //---
    let saveScore = UserDefaultsManager() //Déclaration de la classe saveScore qui va recevoir le resultat de objet dans la fonction userDefaultManager.
    //---
    var permissionToSelectCards = false
    var bet = 0
    var credits = 2000
    //---
    var chances = 2
    //---
    let pokerHands = PokerHands() //Déclaration de la classe pokerhands qui va recevoir le resultat de tout méthodes dans la fonction PokerHands.
    //---
    
    //Déclaration de tableau pour guarder et représenter un paquet des cartes.
    var handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
    //---
    
    // Déclaration global de la variable qui va recevoir les cartes au hasard.
    var theHand = [(Int, String)]()
    //----------------------//----------------------
    
     //Exécution et démarrage du jeu.
    override func viewDidLoad() {
        //---
        super.viewDidLoad()
        //---
        //User Default Manager pour garder les credits.
        if !saveScore.doesKeyExist(theKey: "Crédits:"){
            saveScore.setKey(theValue: 2000 as AnyObject, theKey: "Crédits:")
        } else {
            credits = saveScore.getValue(theKey: "Crédits:") as! Int
        }
        //----
        
        //Créer les objets a partir des images.
        createCardObjectsFromImages()
        //---
        
        //Va ramplir tous les tableaux.
        fillUpArrays()
        //---
        
        //Méthode pour dire la animation comme on va fait.
        prepareAnimations(duration: 0.5,
                          repeating: 5,
                          cards: arrOfCardImages)
        //---
        //Visuel des cartes.
        stylizeSlotImageViews(radius: 10,
                              borderWidth: 0.5,
                              borderColor: UIColor.black.cgColor,
                              bgColor: UIColor.yellow.cgColor)
        //---
        
        //Méthode responsable pour contrôler les cartes qui apparaissent et disparaissent.
        stylizeBackgroundViews(radius: 10,
                               borderWidth: nil,
                               borderColor: UIColor.black.cgColor,
                               bgColor: nil)
        //---
        
        //Méthode qui va créer le joue de cartes.
        createDeckOfCards()
        //---
    }
    //----------------------//----------------------
    
    //Organisation des 52 cartes dans le tableau des cartes "DeckOfCards".
    func createDeckOfCards() {
        deckOfCards = [(Int, String)]()
        for a in 0...3 {
            let suits = ["d", "h", "c", "s"]
            for b in 1...13 {
                deckOfCards.append((b, suits[a]))
            }
        }
    }
    //----------------------//----------------------
    
    //Méthode pour les styles des imageviews Slots.
    func stylizeSlotImageViews(radius r: CGFloat,
                               borderWidth w: CGFloat,
                               borderColor c: CGColor,
                               bgColor g: CGColor!) {
        for slotImageView in arrOfSlotImageViews {
            slotImageView.clipsToBounds = true
            slotImageView.layer.cornerRadius = r
            slotImageView.layer.borderWidth = w
            slotImageView.layer.borderColor = c
            slotImageView.layer.backgroundColor = g
        }
    }
    //----------------------//----------------------
    
    //Méthode pour les cartes de background.
    func stylizeBackgroundViews(radius r: CGFloat,
                                borderWidth w: CGFloat?,
                                borderColor c: CGColor,
                                bgColor g: CGColor?) {
        for bgView in arrOfBackgrounds {
            bgView.clipsToBounds = true
            bgView.layer.cornerRadius = r
            bgView.layer.borderWidth = w ?? 0
            bgView.layer.borderColor = c
            bgView.layer.backgroundColor = g
        }
    }
    //----------------------//----------------------
    
    //Méthode qui va gargariser toutes les tables avec les cartes blur, cartes background e la information de labels guarder.
    func fillUpArrays() {
        arrOfCardImages = [card_blur_1, card_blur_2, card_blur_3, card_blur_4,
                           card_blur_5]
        arrOfSlotImageViews = [slot_1, slot_2, slot_3, slot_4, slot_5]
        arrOfBackgrounds = [bg_1, bg_2, bg_3, bg_4, bg_5]
        arrOfKeepLabels = [keep_1, keep_2, keep_3, keep_4, keep_5]
    }
    //----------------------//----------------------
    
    //Méthode qui va créer les objets dans les cartes blur.
    func createCardObjectsFromImages() {
        card_blur_1 = UIImage(named: "blur_1.png")
        card_blur_2 = UIImage(named: "blur_2.png")
        card_blur_3 = UIImage(named: "blur_3.png")
        card_blur_4 = UIImage(named: "blur_4.png")
        card_blur_5 = UIImage(named: "blur_4.png")
    }
    //----------------------//----------------------
    
    //Fonction qui fait la animation des cartes.
    func prepareAnimations(duration d: Double,
                           repeating r: Int,
                           cards c: [UIImage]) {
        for slotAnimation in arrOfSlotImageViews {
            slotAnimation.animationDuration = d
            slotAnimation.animationRepeatCount = r
            slotAnimation.animationImages = returnRandomBlurCards(arrBlurCards: c)
        }
    }
    //----------------------//----------------------
    
    //Fonction qui va faire le melange pour le tableaux de cartes blur avec 5 animations.
    func returnRandomBlurCards(arrBlurCards: [UIImage]) -> [UIImage] {
        var arrToReturn = [UIImage]()
        var arrOriginal = arrBlurCards
        for _ in 0..<arrBlurCards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(arrOriginal.count)))
            arrToReturn.append(arrOriginal[randomIndex])
            arrOriginal.remove(at: randomIndex)
        }
        return arrToReturn
    }
    //----------------------//----------------------
    
    //Connexion avec le  bouton "DISTRIBUER", qui executa le méthode "play" pour juer.
    @IBAction func play(_ sender: UIButton) {
        //---
        if chances == 0 || dealButton.alpha == 0.5 {
            return
        } else {
            chances = chances - 1
        }
        //---
        
        // Déclaration de variable allselected pour initialment, suppose que tous sont séelectionnées.
        var allSelected = true
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                allSelected = false
                break
            }
        }
        if allSelected {
            displayRandomCards()
            return
        }
        //---
        
        //À ce moment commence faire tous les cartes de l'animation.
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                slotAnimation.startAnimating()
            }
        }
        //---
        Timer.scheduledTimer(timeInterval: 2.75,
                             target: self,
                             selector: #selector(displayRandomCards),
                             userInfo: nil,
                             repeats: false)
    }
    //----------------------//----------------------
    
    //Méethode qui faire afficher les cartes au hasard.
    @objc func displayRandomCards() {
        //---
        theHand = returnRandomHand()
        //---
        let arrOfCards = createCards(theHand: theHand)
        //---
        displayCards(arrOfCards: arrOfCards)
        //---
        
        //Quand cliquez sur le bouton distribuer la premiere fois faire la animation.
        permissionToSelectCards = true
        //---
        prepareForNextHand()
        //---
    }
    //----------------------//----------------------
    
    //Préparation de la prochaine main de cartes.
    func prepareForNextHand() {
        //---
        //Le méethode createDeckOfCards va recréer tous les paquet de cartes de la même précédent.
        if chances == 0 {
            permissionToSelectCards = false
            dealButton.alpha = 0.5
            resetCards()
            createDeckOfCards()
            handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
            chances = 2
            bet = 0
            betLabel.text = "MISE : 0"
        }
        //---
    }
    //----------------------//----------------------
    func displayCards(arrOfCards: [String]) {
        //---
        var counter = 0
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1 {
                if chances == 0 {
                    handToAnalyse = removeEmptySlotsAndReturnArray()
                    handToAnalyse.append(theHand[counter])
                }
                //---
                slotAnimation.image = UIImage(named: arrOfCards[counter])
            }
            counter = counter + 1
        }
        //---
        if chances == 0 {
            verifyHand(hand: handToAnalyse)
        }
        //---
    }
    //----------------------//----------------------
    
    //Méthode qui reçoit les cartes vides.
    func removeEmptySlotsAndReturnArray() -> [(Int, String)] {
        var arrToReturn = [(Int, String)]()
        for card in handToAnalyse {
            if card != (0, "") {
                arrToReturn.append(card)
            }
        }
        return arrToReturn
    }
    //----------------------//----------------------
    
    ////Méthode qui reçoit les 5 avec la nouvelle main de jeu.
    func createCards(theHand: [(Int, String)]) -> [String] {
        //---
        let card_1 = "\(theHand[0].0)\(theHand[0].1).png"
        let card_2 = "\(theHand[1].0)\(theHand[1].1).png"
        let card_3 = "\(theHand[2].0)\(theHand[2].1).png"
        let card_4 = "\(theHand[3].0)\(theHand[3].1).png"
        let card_5 = "\(theHand[4].0)\(theHand[4].1).png"
        return [card_1, card_2, card_3, card_4, card_5]
        //---
    }
    //----------------------//----------------------
    func returnRandomHand() -> [(Int, String)] {
        //---
        var arrToReturn = [(Int, String)]()
        //---
        for _ in 1...5 {
            let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
            arrToReturn.append(deckOfCards[randomIndex])
            deckOfCards.remove(at: randomIndex)
        }
        //---
        return arrToReturn
        //---
    }
    //----------------------//----------------------
    
    //Fonction qui identifie quel mouvement a été réussi.
    func verifyHand(hand: [(Int, String)]) {
        if pokerHands.royalFlush(hand: hand) {
            calculateHand(times: 250, handToDisplay: "QUINTE FLUSH ROYALE")
        } else if pokerHands.straightFlush(hand: hand) {
            calculateHand(times: 50, handToDisplay: "QUINTE FLUSH")
        } else if pokerHands.fourKind(hand: hand) {
            calculateHand(times: 25, handToDisplay: "CARRÉ")
        } else if pokerHands.fullHouse(hand: hand) {
            calculateHand(times: 9, handToDisplay: "FULL")
        } else if pokerHands.flush(hand: hand) {
            calculateHand(times: 6, handToDisplay: "COULEUR")
        } else if pokerHands.straight(hand: hand) {
            calculateHand(times: 4, handToDisplay: "QUINTE")
        } else if pokerHands.threeKind(hand: hand) {
            calculateHand(times: 3, handToDisplay: "BRELAN")
        } else if pokerHands.twoPairs(hand: hand) {
            calculateHand(times: 2, handToDisplay: "DEUX PAIRES")
        } else if pokerHands.onePair(hand: hand) {
            calculateHand(times: 1, handToDisplay: "PAIRE")
        } else {
            calculateHand(times: 0, handToDisplay: "RIEN...")
        }
    }
    //----------------------//----------------------
    
    //Fonction que calcule le nombre de fois dans le jeu.
    func calculateHand(times: Int, handToDisplay: String) {
        credits += (times * bet)
        tempLabel.text = handToDisplay
        creditsLabel.text = "CRÉDITS: \(credits)"
    }
    //----------------------//----------------------
    
    //Connexion avec les boutons de chaque Slot View, qui executa le méthode "Guarder" de chaque carte.
    @IBAction func cardsToHold(_ sender: UIButton) {
        //---
        if !permissionToSelectCards {
            return
        }
        //---
        if arrOfBackgrounds[sender.tag].layer.borderWidth == 0.5 {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.0
            arrOfBackgrounds[sender.tag].layer.backgroundColor = nil
            arrOfKeepLabels[sender.tag].isHidden = true
            //---
            manageSelectedCards(theTag: sender.tag, shouldAdd: false)
        } else {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 1.0
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderColor = UIColor.blue.cgColor
            arrOfBackgrounds[sender.tag].layer.backgroundColor = UIColor(red: 0.0,
                                                                         green: 0.0, blue: 1.0, alpha: 0.5).cgColor
            arrOfKeepLabels[sender.tag].isHidden = false
            //---
            
            //Ajoute la carte sélectionnée pour la liste des cartes pour analyser
            manageSelectedCards(theTag: sender.tag, shouldAdd: true)
        }
    }
    //----------------------//----------------------
    
    // Fonction qui ajoute la carte sélectionnée pour la liste des cartes pour analyser
    func manageSelectedCards(theTag: Int, shouldAdd: Bool) {
        if shouldAdd {
            handToAnalyse[theTag] = theHand[theTag]
        } else {
            handToAnalyse[theTag] = (0, "")
        }
    }
    //----------------------//----------------------
   
    //Connexion avec les boutons "MISER 25", "MISER 100", "MISER tout", pour executer le méthode de MISER avant de jouer.
    @IBAction func betButtons(_ sender: UIButton) {
        //---
        if chances <= 1 {
            return
        }
        //---
        tempLabel.text = ""
        //---
        
        // Si cliquez sur le bouton "MISER tout"
        if sender.tag == 1000 {
            bet = credits
            betLabel.text = "MISE : \(bet)"
            credits = 0
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
            resetBackOfCards()
            return
        }
        //---
        
        // Le variable thebet va recevoir 25 ou 100, MISER 25 ou MISER 100
        let theBet = sender.tag
        //---
        if credits >= theBet {
            bet += theBet
            credits -= theBet
            betLabel.text = "MISE : \(bet)"
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
        }
        //---
        
        // Exécute la fonction qui redémarre et présente le "back" des cartes qui ne sont pas "guarder"
        resetBackOfCards()
        //---
    }
    //----------------------//----------------------
    
    //Fonction qui redémarre et présente le "back" des cartes qui ne sont pas "guarder"
    func resetBackOfCards() {
        for back in arrOfSlotImageViews {
            back.image = UIImage(named: "back.png")
        }
    }
    //----------------------//---------------------
   
    //Connexion avec le bouton "RECOMMENCER" pour exécuter le méthode pour redémarrer le jeu.
    @IBAction func recommencer(_ sender: UIButton) {
        if sender.tag == 10 {
            bet = 0
            betLabel.text = "MISE: \(bet)"
            credits = 2000
            creditsLabel.text = "CRÉDITS: \(credits)"
            dealButton.alpha = 1.0
            tempLabel.text = "BONNE CHANCE..."
            resetBackOfCards()
            return
        }
        
    }
    //----------------------//----------------------
    
    // Fonction pour exécuter le méthode qui redémarre les cartes lorsqu'il exécute la méthode prepareForNextHand()
    func resetCards() {
        //---
        for index in 0...4 {
            arrOfSlotImageViews[index].layer.borderWidth = 0.5
            arrOfBackgrounds[index].layer.borderWidth = 0.0
            arrOfBackgrounds[index].layer.backgroundColor = nil
            arrOfKeepLabels[index].isHidden = true
        }
        //---
        chances = 2
        //---
    }
    //----------------------//----------------------
}
//----------------------//----------------------

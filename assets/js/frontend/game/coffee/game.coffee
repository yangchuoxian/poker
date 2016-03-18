constants = require './constants.js'
globalVariables = require './globalVariables.js'
toolbox = require './toolbox.js'
communications = require './communications.js'
actions = require './actions.js'

preload = () ->
    game.load.image 'avatar', 'images/defaultAvatar.jpg'
    game.load.image 'background', 'images/background.png'
    game.load.image 'stageBackground', 'images/stageBackground.png'
    game.load.spritesheet 'playButton', 'images/playButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT
    game.load.spritesheet 'prepareButton', 'images/prepareButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT
    game.load.spritesheet 'leaveButton', 'images/leaveButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT
    game.load.spritesheet 'raiseScoreButton', 'images/raiseScoreButton.png', constants.ROUND_BUTTON_SIZE, constants.ROUND_BUTTON_SIZE
    game.load.spritesheet 'lowerScoreButton', 'images/lowerScoreButton.png', constants.ROUND_BUTTON_SIZE, constants.ROUND_BUTTON_SIZE
    game.load.spritesheet 'setScoreButton', 'images/setScoreButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT
    game.load.spritesheet 'passButton', 'images/passButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT
    game.load.spritesheet 'surrenderButton', 'images/surrenderButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT
    game.load.spritesheet 'selectSuitButton', 'images/selectSuitButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT
    game.load.spritesheet 'settleCoveredCardsButton', 'images/settleCoveredCardsButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT
    game.load.image 'back', 'images/back.png'
    game.load.image 'bigJoker', 'images/bigJoker.png'
    game.load.image 'smallJoker', 'images/smallJoker.png'
    game.load.image 'sevenOfSpades', 'images/sevenOfSpades.png'
    game.load.image 'sevenOfHearts', 'images/sevenOfHearts.png'
    game.load.image 'sevenOfClubs', 'images/sevenOfClubs.png'
    game.load.image 'sevenOfDiamonds', 'images/sevenOfDiamonds.png'
    game.load.image 'twoOfSpades', 'images/twoOfSpades.png'
    game.load.image 'twoOfHearts', 'images/twoOfHearts.png'
    game.load.image 'twoOfClubs', 'images/twoOfClubs.png'
    game.load.image 'twoOfDiamonds', 'images/twoOfDiamonds.png'
    game.load.image 'aceOfSpades', 'images/aceOfSpades.png'
    game.load.image 'kingOfSpades', 'images/kingOfSpades.png'
    game.load.image 'queenOfSpades', 'images/queenOfSpades.png'
    game.load.image 'jackOfSpades', 'images/jackOfSpades.png'
    game.load.image 'tenOfSpades', 'images/tenOfSpades.png'
    game.load.image 'nineOfSpades', 'images/nineOfSpades.png'
    game.load.image 'eightOfSpades', 'images/eightOfSpades.png'
    game.load.image 'sixOfSpades', 'images/sixOfSpades.png'
    game.load.image 'fiveOfSpades', 'images/fiveOfSpades.png'
    game.load.image 'aceOfHearts', 'images/aceOfHearts.png'
    game.load.image 'kingOfHearts', 'images/kingOfHearts.png'
    game.load.image 'queenOfHearts', 'images/queenOfHearts.png'
    game.load.image 'jackOfHearts', 'images/jackOfHearts.png'
    game.load.image 'tenOfHearts', 'images/tenOfHearts.png'
    game.load.image 'nineOfHearts', 'images/nineOfHearts.png'
    game.load.image 'eightOfHearts', 'images/eightOfHearts.png'
    game.load.image 'sixOfHearts', 'images/sixOfHearts.png'
    game.load.image 'fiveOfHearts', 'images/fiveOfHearts.png'
    game.load.image 'aceOfClubs', 'images/aceOfClubs.png'
    game.load.image 'kingOfClubs', 'images/kingOfClubs.png'
    game.load.image 'queenOfClubs', 'images/queenOfClubs.png'
    game.load.image 'jackOfClubs', 'images/jackOfClubs.png'
    game.load.image 'tenOfClubs', 'images/tenOfClubs.png'
    game.load.image 'nineOfClubs', 'images/nineOfClubs.png'
    game.load.image 'eightOfClubs', 'images/eightOfClubs.png'
    game.load.image 'sixOfClubs', 'images/sixOfClubs.png'
    game.load.image 'fiveOfClubs', 'images/fiveOfClubs.png'
    game.load.image 'aceOfDiamonds', 'images/aceOfDiamonds.png'
    game.load.image 'kingOfDiamonds', 'images/kingOfDiamonds.png'
    game.load.image 'queenOfDiamonds', 'images/queenOfDiamonds.png'
    game.load.image 'jackOfDiamonds', 'images/jackOfDiamonds.png'
    game.load.image 'tenOfDiamonds', 'images/tenOfDiamonds.png'
    game.load.image 'nineOfDiamonds', 'images/nineOfDiamonds.png'
    game.load.image 'eightOfDiamonds', 'images/eightOfDiamonds.png'
    game.load.image 'sixOfDiamonds', 'images/sixOfDiamonds.png'
    game.load.image 'fiveOfDiamonds', 'images/fiveOfDiamonds.png'

    game.load.image 'spade', 'images/spade.png'
    game.load.image 'heart', 'images/heart.png'
    game.load.image 'club', 'images/club.png'
    game.load.image 'diamond', 'images/diamond.png'

    game.load.spritesheet 'suites', 'images/suites.png', constants.MAIN_SUIT_ICON_SIZE, constants.MAIN_SUIT_ICON_SIZE
    game.load.image 'rectangle', 'images/rectangle.png'
    game.load.image 'makerIcon', 'images/makerIcon.png'

create = () ->
    globalVariables.background = game.add.sprite 0, 0, 'background'
    globalVariables.background.inputEnabled = true
    globalVariables.background.events.onInputDown.add actions.backgroundTapped, this
    globalVariables.background.scale.setTo globalVariables.screenWidth / constants.BACKGROUND_IMAGE_SIZE, globalVariables.screenHeight / constants.BACKGROUND_IMAGE_SIZE

    globalVariables.scaledCardWidth = Math.floor((globalVariables.screenWidth - constants.MARGIN * 2) / 8)
    globalVariables.scaleWidthRatio = globalVariables.scaledCardWidth / constants.CARD_WIDTH

    globalVariables.scaledCardHeight = globalVariables.screenHeight / 5
    globalVariables.scaleHeightRatio = globalVariables.scaledCardHeight / constants.CARD_HEIGHT

    globalVariables.scaledCardWidth = constants.CARD_WIDTH * globalVariables.scaleWidthRatio
    globalVariables.scaledCardHeight = constants.CARD_HEIGHT * globalVariables.scaleHeightRatio

    globalVariables.cardsAtHand = game.add.group()
    globalVariables.coveredCards = game.add.group()
    globalVariables.selectSuitStage = game.add.group()

    globalVariables.playCardsButton = game.add.button game.world.centerX - constants.BUTTON_WIDTH / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'playButton', actions.playSelectedCards, this, 1, 0, 1
    globalVariables.playCardsButton.visible = false

    globalVariables.prepareButton = game.add.button game.world.centerX - constants.BUTTON_WIDTH - constants.MARGIN / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'prepareButton', actions.sendGetReadyMessage, this, 1, 0, 1

    globalVariables.leaveButton = game.add.button game.world.centerX + constants.MARGIN / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'leaveButton', actions.leaveRoom, this, 1, 0, 1

    globalVariables.surrenderButton = game.add.button game.world.centerX - constants.BUTTON_WIDTH - constants.MARGIN / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'surrenderButton', actions.surrender, this, 1, 0, 1
    globalVariables.surrenderButton.visible = false

    globalVariables.settleCoveredCardsButton = game.add.button game.world.centerX + constants.MARGIN / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'settleCoveredCardsButton', actions.settleCoveredCards, this, 1, 0, 1
    globalVariables.settleCoveredCardsButton.setFrames 2, 2, 2
    globalVariables.settleCoveredCardsButton.inputEnabled = false
    globalVariables.settleCoveredCardsButton.visible = false

    globalVariables.selectSuitButton = game.add.button game.world.centerX + constants.MARGIN / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'selectSuitButton', actions.selectSuit, this, 2, 2, 2
    globalVariables.selectSuitButton.inputEnabled = false
    globalVariables.selectSuitButton.visible = false

    globalVariables.currentUserPlayedCards = game.add.group()
    globalVariables.user1PlayedCards = game.add.group()
    globalVariables.user2PlayedCards = game.add.group()
    globalVariables.user3PlayedCards = game.add.group()

    titleOfMainSuit = game.add.text globalVariables.screenWidth - 350, constants.MARGIN, '主牌', constants.TEXT_STYLE
    titleOfMainSuit.setTextBounds 0, 0, 70, 30
    globalVariables.iconOfMainSuit = game.add.sprite globalVariables.screenWidth - 350 + 20, 2 * constants.MARGIN + 30, 'suites'
    globalVariables.iconOfMainSuit.scale.setTo 30 / constants.MAIN_SUIT_ICON_SIZE, 30 / constants.MAIN_SUIT_ICON_SIZE
    globalVariables.iconOfMainSuit.frame = 0

    titleOfAimedScores = game.add.text globalVariables.screenWidth - 280, constants.MARGIN, '叫分', constants.TEXT_STYLE
    titleOfAimedScores.setTextBounds 0, 0, 70, 30
    globalVariables.textOfAimedScores = game.add.text globalVariables.screenWidth - 280, 2 * constants.MARGIN + 30, '80', constants.TEXT_STYLE
    globalVariables.textOfAimedScores.setTextBounds 0, 0, 70, 30
    titleOfCurrentScores = game.add.text globalVariables.screenWidth - 210, constants.MARGIN, '得分', constants.TEXT_STYLE
    titleOfCurrentScores.setTextBounds 0, 0, 70, 30
    globalVariables.textOfCurrentScores = game.add.text globalVariables.screenWidth - 210, 2 * constants.MARGIN + 30, '0', constants.TEXT_STYLE
    globalVariables.textOfCurrentScores.setTextBounds 0, 0, 70, 30

    titleOfChipsWon = game.add.text globalVariables.screenWidth - 140, constants.MARGIN, '输赢', constants.TEXT_STYLE
    titleOfChipsWon.setTextBounds 0, 0, 70, 30
    globalVariables.textOfChipsWon = game.add.text globalVariables.screenWidth - 140, 2 * constants.MARGIN + 30, '0', constants.TEXT_STYLE
    globalVariables.textOfChipsWon.setTextBounds 0, 0, 70, 30
    titleOfRoomName = game.add.text globalVariables.screenWidth - 70, constants.MARGIN, '房间', constants.TEXT_STYLE
    titleOfRoomName.setTextBounds 0, 0, 70, 30
    globalVariables.textOfRoomName = game.add.text globalVariables.screenWidth - 70, 2 * constants.MARGIN + 30, '', constants.TEXT_STYLE
    globalVariables.textOfRoomName.setTextBounds 0, 0, 70, 30
    globalVariables.meStatusText = game.add.text game.world.centerX - constants.MARGIN, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 3 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET - constants.BUTTON_HEIGHT, '', constants.TEXT_STYLE
    globalVariables.player1StatusText = game.add.text globalVariables.screenWidth - 2 * constants.AVATAR_SIZE - 3 * constants.MARGIN, game.world.centerY, '', constants.TEXT_STYLE
    globalVariables.player2StatusText = game.add.text game.world.centerX - constants.MARGIN, constants.AVATAR_SIZE + 4 * constants.MARGIN, '', constants.TEXT_STYLE
    globalVariables.player3StatusText = game.add.text constants.AVATAR_SIZE + 2 * constants.MARGIN, game.world.centerY, '', constants.TEXT_STYLE

    communications.getRoomInfo game

    communications.socketEventHandler game

update = () ->

game = new Phaser.Game globalVariables.screenWidth, globalVariables.screenHeight, Phaser.AUTO, '',
    preload: preload
    create: create
    update: update
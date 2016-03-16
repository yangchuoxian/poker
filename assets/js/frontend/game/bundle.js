/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var constants = __webpack_require__(1);
	var globalVariables = __webpack_require__(2);
	var toolbox = __webpack_require__(3);
	var actions = __webpack_require__(4);
	var game = new Phaser.Game(globalVariables.screenWidth, globalVariables.screenHeight, Phaser.AUTO, '', { preload: preload, create: create, update: update });
	function preload() {
	    game.load.image('avatar', 'images/defaultAvatar.jpg');

	    game.load.image('background', 'images/background.png');
	    game.load.image('stageBackground', 'images/stageBackground.png');

	    game.load.spritesheet('playButton', 'images/playButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT);
	    game.load.spritesheet('prepareButton', 'images/prepareButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT);
	    game.load.spritesheet('leaveButton', 'images/leaveButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT);
	    game.load.spritesheet('raiseScoreButton', 'images/raiseScoreButton.png', constants.ROUND_BUTTON_SIZE, constants.ROUND_BUTTON_SIZE);
	    game.load.spritesheet('lowerScoreButton', 'images/lowerScoreButton.png', constants.ROUND_BUTTON_SIZE, constants.ROUND_BUTTON_SIZE);
	    game.load.spritesheet('setScoreButton', 'images/setScoreButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT);
	    game.load.spritesheet('passButton', 'images/passButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT);
	    game.load.spritesheet('surrenderButton', 'images/surrenderButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT);
	    game.load.spritesheet('settleCoveredCardsButton', 'images/settleCoveredCardsButton.png', constants.BUTTON_WIDTH, constants.BUTTON_HEIGHT);

	    game.load.image('back', 'images/back.png');

	    game.load.image('bigJoker', 'images/bigJoker.png');
	    game.load.image('smallJoker', 'images/smallJoker.png');

	    game.load.image('sevenOfSpades', 'images/sevenOfSpades.png');
	    game.load.image('sevenOfHearts', 'images/sevenOfHearts.png');
	    game.load.image('sevenOfClubs', 'images/sevenOfClubs.png');
	    game.load.image('sevenOfDiamonds', 'images/sevenOfDiamonds.png');

	    game.load.image('twoOfSpades', 'images/twoOfSpades.png');
	    game.load.image('twoOfHearts', 'images/twoOfHearts.png');
	    game.load.image('twoOfClubs', 'images/twoOfClubs.png');
	    game.load.image('twoOfDiamonds', 'images/twoOfDiamonds.png');

	    game.load.image('aceOfSpades', 'images/aceOfSpades.png');
	    game.load.image('kingOfSpades', 'images/kingOfSpades.png');
	    game.load.image('queenOfSpades', 'images/queenOfSpades.png');
	    game.load.image('jackOfSpades', 'images/jackOfSpades.png');
	    game.load.image('tenOfSpades', 'images/tenOfSpades.png');
	    game.load.image('nineOfSpades', 'images/nineOfSpades.png');
	    game.load.image('eightOfSpades', 'images/eightOfSpades.png');
	    game.load.image('sixOfSpades', 'images/sixOfSpades.png');
	    game.load.image('fiveOfSpades', 'images/fiveOfSpades.png');

	    game.load.image('aceOfHearts', 'images/aceOfHearts.png');
	    game.load.image('kingOfHearts', 'images/kingOfHearts.png');
	    game.load.image('queenOfHearts', 'images/queenOfHearts.png');
	    game.load.image('jackOfHearts', 'images/jackOfHearts.png');
	    game.load.image('tenOfHearts', 'images/tenOfHearts.png');
	    game.load.image('nineOfHearts', 'images/nineOfHearts.png');
	    game.load.image('eightOfHearts', 'images/eightOfHearts.png');
	    game.load.image('sixOfHearts', 'images/sixOfHearts.png');
	    game.load.image('fiveOfHearts', 'images/fiveOfHearts.png');

	    game.load.image('aceOfClubs', 'images/aceOfClubs.png');
	    game.load.image('kingOfClubs', 'images/kingOfClubs.png');
	    game.load.image('queenOfClubs', 'images/queenOfClubs.png');
	    game.load.image('jackOfClubs', 'images/jackOfClubs.png');
	    game.load.image('tenOfClubs', 'images/tenOfClubs.png');
	    game.load.image('nineOfClubs', 'images/nineOfClubs.png');
	    game.load.image('eightOfClubs', 'images/eightOfClubs.png');
	    game.load.image('sixOfClubs', 'images/sixOfClubs.png');
	    game.load.image('fiveOfClubs', 'images/fiveOfClubs.png');

	    game.load.image('aceOfDiamonds', 'images/aceOfDiamonds.png');
	    game.load.image('kingOfDiamonds', 'images/kingOfDiamonds.png');
	    game.load.image('queenOfDiamonds', 'images/queenOfDiamonds.png');
	    game.load.image('jackOfDiamonds', 'images/jackOfDiamonds.png');
	    game.load.image('tenOfDiamonds', 'images/tenOfDiamonds.png');
	    game.load.image('nineOfDiamonds', 'images/nineOfDiamonds.png');
	    game.load.image('eightOfDiamonds', 'images/eightOfDiamonds.png');
	    game.load.image('sixOfDiamonds', 'images/sixOfDiamonds.png');
	    game.load.image('fiveOfDiamonds', 'images/fiveOfDiamonds.png');
	}

	function create() {
	    globalVariables.background = game.add.sprite(0, 0, 'background');
	    globalVariables.background.inputEnabled = true;
	    globalVariables.background.events.onInputDown.add(actions.backgroundTapped, this);
	    globalVariables.background.scale.setTo(globalVariables.screenWidth / constants.BACKGROUND_IMAGE_SIZE, globalVariables.screenHeight / constants.BACKGROUND_IMAGE_SIZE);

	    globalVariables.scaledCardWidth = Math.floor((globalVariables.screenWidth - constants.MARGIN * 2) / 8);
	    globalVariables.scaleWidthRatio = globalVariables.scaledCardWidth / constants.CARD_WIDTH;

	    globalVariables.scaledCardHeight = globalVariables.screenHeight / 5;
	    globalVariables.scaleHeightRatio = globalVariables.scaledCardHeight / constants.CARD_HEIGHT;

	    globalVariables.scaledCardWidth = constants.CARD_WIDTH * globalVariables.scaleWidthRatio;
	    globalVariables.scaledCardHeight = constants.CARD_HEIGHT * globalVariables.scaleHeightRatio;

	    globalVariables.cardsAtHand = game.add.group();
	    globalVariables.coveredCards = game.add.group();

	    globalVariables.playCardsButton = game.add.button(game.world.centerX - constants.BUTTON_WIDTH / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'playButton', actions.playSelectedCards, this, 0, 0, 1, 0);
	    globalVariables.playCardsButton.visible = false;

	    globalVariables.prepareButton = game.add.button(game.world.centerX - constants.BUTTON_WIDTH - constants.MARGIN / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'prepareButton', actions.sendGetReadyMessage, this, 1, 0, 1, 0);

	    globalVariables.leaveButton = game.add.button(game.world.centerX + constants.MARGIN / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'leaveButton', actions.leaveRoom, this, 1, 0, 1, 0);

	    globalVariables.surrenderButton = game.add.button(game.world.centerX - constants.BUTTON_WIDTH - constants.MARGIN / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'surrenderButton', actions.surrender, this, 1, 0, 1, 0);
	    globalVariables.surrenderButton.visible = false;

	    globalVariables.settleCoveredCardsButton = game.add.button(game.world.centerX + constants.MARGIN / 2, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'settleCoveredCardsButton', actions.settleCoveredCards, this, 1, 0, 1, 0);
	    globalVariables.settleCoveredCardsButton.visible = false;

	    /*
	    var shuffledCards = toolbox.shuffleCards();
	    var firstDeckOfCards = toolbox.sortCards(shuffledCards.slice(0, constants.INITIAL_NUM_CARDS_AT_HAND));
	    var secondDeckOfCards = toolbox.sortCards(shuffledCards.slice(constants.INITIAL_NUM_CARDS_AT_HAND, constants.INITIAL_NUM_CARDS_AT_HAND * 2));
	    var thirdDeckOfCards = toolbox.sortCards(shuffledCards.slice(constants.INITIAL_NUM_CARDS_AT_HAND * 2, constants.INITIAL_NUM_CARDS_AT_HAND * 3));
	    var fourthDeckOfCards = toolbox.sortCards(shuffledCards.slice(constants.INITIAL_NUM_CARDS_AT_HAND * 3, constants.INITIAL_NUM_CARDS_AT_HAND * 4));
	    var coveredCardIndexes = shuffledCards.slice(constants.INITIAL_NUM_CARDS_AT_HAND * 4, constants.INITIAL_NUM_CARDS_AT_HAND * 4 + constants.NUM_OF_COVERED_CARDS);

	    actions.displayCards(firstDeckOfCards);

	    globalVariables.coveredCards.indexes = coveredCardIndexes;

	    var coveredCardsIcon = globalVariables.coveredCards.create(constants.MARGIN, constants.MARGIN, 'back');
	    coveredCardsIcon.scale.setTo(globalVariables.scaleWidthRatio, globalVariables.scaleHeightRatio);
	    coveredCardsIcon.inputEnabled = true;
	    coveredCardsIcon.events.onInputDown.add(actions.showCoveredCards, this);
	    */

	    globalVariables.currentUserPlayedCards = game.add.group();  
	    globalVariables.user1PlayedCards = game.add.group();
	    globalVariables.user2PlayedCards = game.add.group();
	    globalVariables.user3PlayedCards = game.add.group();

	    var titleOfAimedScores = game.add.text(globalVariables.screenWidth - 280, constants.MARGIN, '叫分', constants.TEXT_STYLE);
	    titleOfAimedScores.setTextBounds(0, 0, 70, 30);
	    globalVariables.textOfAimedScores = game.add.text(globalVariables.screenWidth - 280, 2 * constants.MARGIN + 30, '80', constants.TEXT_STYLE);
	    globalVariables.textOfAimedScores.setTextBounds(0, 0, 70, 30);

	    var titleOfCurrentScores = game.add.text(globalVariables.screenWidth - 210, constants.MARGIN, '得分', constants.TEXT_STYLE);
	    titleOfCurrentScores.setTextBounds(0, 0, 70, 30);

	    globalVariables.textOfCurrentScores = game.add.text(globalVariables.screenWidth - 210, 2 * constants.MARGIN + 30, '0', constants.TEXT_STYLE);
	    globalVariables.textOfCurrentScores.setTextBounds(0, 0, 70, 30);

	    var titleOfChipsWon = game.add.text(globalVariables.screenWidth - 140, constants.MARGIN, '输赢', constants.TEXT_STYLE);
	    titleOfChipsWon.setTextBounds(0, 0, 70, 30);

	    globalVariables.textOfChipsWon = game.add.text(globalVariables.screenWidth - 140, 2 * constants.MARGIN + 30, '0', constants.TEXT_STYLE);
	    globalVariables.textOfChipsWon.setTextBounds(0, 0, 70, 30);

	    var titleOfRoomName = game.add.text(globalVariables.screenWidth - 70, constants.MARGIN, '房间', constants.TEXT_STYLE);
	    titleOfRoomName.setTextBounds(0, 0, 70, 30);

	    globalVariables.textOfRoomName = game.add.text(globalVariables.screenWidth - 70, 2 * constants.MARGIN + 30, '', constants.TEXT_STYLE);
	    globalVariables.textOfRoomName.setTextBounds(0, 0, 70, 30);

	    globalVariables.meStatusText = game.add.text(game.world.centerX - constants.MARGIN, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, '', constants.TEXT_STYLE);
	    globalVariables.player1StatusText = game.add.text(globalVariables.screenWidth - 2 * constants.AVATAR_SIZE - 3 * constants.MARGIN, game.world.centerY, '', constants.TEXT_STYLE);
	    globalVariables.player2StatusText = game.add.text(game.world.centerX - constants.MARGIN, constants.AVATAR_SIZE + 4 * constants.MARGIN, '', constants.TEXT_STYLE);
	    globalVariables.player3StatusText = game.add.text(constants.AVATAR_SIZE + 2 * constants.MARGIN, game.world.centerY, '', constants.TEXT_STYLE);

	    socketCommunication();
	}

	function update() {
	}

	function socketCommunication() {
	    io.socket.get('/get_room_info', {
	        userId: globalVariables.userId,
	        loginToken: globalVariables.loginToken
	    }, function (resData, jwres) {
	        if (jwres.statusCode == 200) {
	            globalVariables.textOfRoomName.text = resData.roomName;
	            var usernames = resData.usernames;
	            switch (usernames.length) {
	                case 2:
	                actions.showPlayer3Info(game, usernames[0]);
	                break;
	                case 3:
	                actions.showPlayer3Info(game, usernames[1]);
	                actions.showPlayer2Info(game, usernames[0]);
	                break;
	                case 4:
	                actions.showPlayer3Info(game, usernames[2]);
	                actions.showPlayer2Info(game, usernames[1]);
	                actions.showPlayer1Info(game, usernames[0]);
	                break;
	                default:
	                break;
	            }
	            var readyPlayers = resData.readyPlayers;
	            for (var i = 0; i < readyPlayers.length; i ++) {
	                if (globalVariables.player1Username) {
	                    if (readyPlayers[i] == globalVariables.player1Username.text) {
	                        globalVariables.player1StatusText.text = 'Ready';
	                    }
	                }
	                if (globalVariables.player2Username) {
	                    if (readyPlayers[i] == globalVariables.player2Username.text) {
	                        globalVariables.player2StatusText.text = 'Ready';
	                    }
	                }
	                if (globalVariables.player3Username) {
	                    if (readyPlayers[i] == globalVariables.player3Username.text) {
	                        globalVariables.player3StatusText.text = 'Ready';
	                    }
	                }
	            }
	        }
	    });
	    io.socket.on('newPlayerJoined', function (data) {
	        globalVariables.numberOfPlayersInRoom += 1;
	        switch (globalVariables.numberOfPlayersInRoom) {
	            case 2:
	            actions.showPlayer1Info(game, data.newPlayer);
	            break;
	            case 3:
	            actions.showPlayer2Info(game, data.newPlayer);
	            break;
	            case 4:
	            actions.showPlayer3Info(game, data.newPlayer);
	            break;
	            default:
	            break;
	        }
	    });
	    io.socket.on('playerLeavedRoom', function (data) {
	        globalVariables.numberOfPlayersInRoom -= 1;
	        var leftUsername = data.username;
	        actions.hideLeftPlayer(leftUsername);
	    });
	    io.socket.on('playerReady', function (data) {
	        var readyUsername = data.username;
	        if (globalVariables.player1Username) {
	            if (readyUsername == globalVariables.player1Username.text) {
	                globalVariables.player1StatusText.text = 'Ready';
	            }
	        }
	        if (globalVariables.player2Username) {
	            if (readyUsername == globalVariables.player2Username.text) {
	                globalVariables.player2StatusText.text = 'Ready';
	            }
	        }
	        if (globalVariables.player3Username) {
	            if (readyUsername == globalVariables.player3Username.text) {
	                globalVariables.player3StatusText.text = 'Ready';
	            }
	        }
	    });
	    io.socket.on('cardsSent', function (data) {
	        globalVariables.cardsAtHand.indexes = data.cards;
	        globalVariables.cardsAtHand.indexes = data.cards;
	        var usernameToCallScore = data.usernameToCallScore;
	        globalVariables.cardsAtHand.indexes = toolbox.sortCards(globalVariables.cardsAtHand.indexes);
	        actions.displayCards(globalVariables.cardsAtHand.indexes);
	        globalVariables.meStatusText.text = '';
	        globalVariables.player1StatusText.text = '';
	        globalVariables.player2StatusText.text = '';
	        globalVariables.player3StatusText.text = '';

	        globalVariables.textOfAimedScores.text = '80';
	        globalVariables.textOfCurrentScores.text = '80';
	        if (usernameToCallScore == globalVariables.username) {
	            actions.showCallScorePanel(game, 80);
	        } else {
	            if (usernameToCallScore == globalVariables.player1Username.text) {
	                globalVariables.player1StatusText.text = '叫分中...';
	            } else if (usernameToCallScore == globalVariables.player2Username.text) {
	                globalVariables.player2StatusText.text = '叫分中...';
	            } else if (usernameToCallScore == globalVariables.player3Username.text) {
	                globalVariables.player3StatusText.text = '叫分中...';
	            }
	        }
	    });
	    io.socket.on('userCalledScore', function (data) {
	        var currentAimedScore = data.currentAimedScore;
	        var usernameCalledScore = data.usernameCalledScore;
	        var usernameToCallScore = data.usernameToCallScore;

	        globalVariables.textOfAimedScores.text = '' + currentAimedScore;

	        if (usernameToCallScore == globalVariables.username) {
	            globalVariables.meStatusText.text = '叫分中...';
	            if (globalVariables.player1StatusText.text == '叫分中...') {
	                globalVariables.player1StatusText.text = '';
	            }
	            if (globalVariables.player2StatusText.text == '叫分中...') {
	                globalVariables.player2StatusText.text = '';
	            }
	            if (globalVariables.player3StatusText.text == '叫分中...') {
	                globalVariables.player3StatusText.text = '';
	            }
	            actions.showCallScorePanel(game, currentAimedScore);
	        } else {
	            if (usernameToCallScore == globalVariables.player1Username.text) {
	                globalVariables.player1StatusText.text = '叫分中...';
	                if (globalVariables.player2StatusText.text == '叫分中...') {
	                    globalVariables.player2StatusText.text = '';
	                }
	                if (globalVariables.player3StatusText.text == '叫分中...') {
	                    globalVariables.player3StatusText.text = '';
	                }
	            } else if (usernameToCallScore == globalVariables.player2Username.text) {
	                if (globalVariables.player1StatusText.text == '叫分中...') {
	                    globalVariables.player1StatusText.text = '';
	                }
	                globalVariables.player2StatusText.text = '叫分中...';
	                if (globalVariables.player3StatusText.text == '叫分中...') {
	                    globalVariables.player3StatusText.text = '';
	                }
	            } else if (usernameToCallScore == globalVariables.player3Username.text) {
	                if (globalVariables.player1StatusText.text == '叫分中...') {
	                    globalVariables.player1StatusText.text = '';
	                }
	                if (globalVariables.player2StatusText.text == '叫分中...') {
	                    globalVariables.player2StatusText.text = '';
	                } 
	                globalVariables.player3StatusText.text = '叫分中...';
	            }

	            if (usernameCalledScore == globalVariables.player1Username.text) {
	                globalVariables.player1StatusText.text = currentAimedScore + '分';
	            } else if (usernameCalledScore == globalVariables.player2Username.text) {
	                globalVariables.player2StatusText.text = currentAimedScore + '分';
	            } else if (usernameCalledScore == globalVariables.player3Username.text) {
	                globalVariables.player3StatusText.text = currentAimedScore + '分';
	            }
	        }
	    });
	    io.socket.on('userPassed', function (data) {
	        var passedUser = data.passedUser;
	        var usernameToCallScore = data.usernameToCallScore;
	        var currentAimedScore = data.aimedScore;
	        if (passedUser == globalVariables.player1Username.text) {
	            globalVariables.player1StatusText.text = '不要';
	        } else if (passedUser == globalVariables.player2Username.text) {
	            globalVariables.player2StatusText.text = '不要';
	        } else if (passedUser == globalVariables.player3Username.text) {
	            globalVariables.player3StatusText.text = '不要';
	        }
	        if (usernameToCallScore == globalVariables.username) {
	            actions.showCallScorePanel(game, currentAimedScore);
	        }
	    });
	    io.socket.on('makerSettled', function (data) {
	        var aimedScore = data.aimedScore;
	        var makerUsername = data.makerUsername;
	        globalVariables.textOfAimedScores.text = aimedScore + '分';
	        if (makerUsername == globalVariables.player1Username.text) {
	            globalVariables.player1IsMakerText.text = '庄';
	        } else if (makerUsername == globalVariables.player2Username.text) {
	            globalVariables.player2IsMakerText.text = '庄';
	        } else if (makerUsername == globalVariables.player3Username.text) {
	            globalVariables.player3IsMakerText.text = '庄';
	        }
	        if (makerUsername == globalVariables.username) {
	            var coveredCards = data.coveredCards;
	            globalVariables.cardsAtHand.indexes = globalVariables.cardsAtHand.indexes.concat(coveredCards);
	            globalVariables.cardsAtHand.indexes = toolbox.sortCards(globalVariables.cardsAtHand.indexes);
	            actions.displayCards(globalVariables.cardsAtHand.indexes);
	            globalVariables.surrenderButton.visible = true;
	            globalVariables.settleCoveredCardsButton.visible = true;
	        }
	    });
	}



/***/ },
/* 1 */
/***/ function(module, exports) {

	module.exports = {
		BACKGROUND_IMAGE_SIZE: 200,
		CARD_WIDTH: 180,
		CARD_HEIGHT: 251,
		SELECTED_CARD_Y_OFFSET: 40,
		BUTTON_WIDTH: 150,
		BUTTON_HEIGHT: 40,
		ROUND_BUTTON_SIZE: 70,
		AVATAR_SIZE: 75,
		INITIAL_NUM_CARDS_AT_HAND: 21,
		NUM_OF_COVERED_CARDS: 8,
		MARGIN: 20,
		WHITE_COLOR: '#ffffff',
		LARGE_TEXT_STYLE: { font: "bold 32px Arial", fill: "#fff", boundsAlignH: "center", boundsAlignV: "middle" },
		TEXT_STYLE: { font: "bold 20px Arial", fill: "#fff", boundsAlignH: "center", boundsAlignV: "middle" },
		RED_TEXT_STYLE: { font: "bold 20px Arial", fill: "#fa6161" }
	};

/***/ },
/* 2 */
/***/ function(module, exports) {

	module.exports = {
		screenWidth: Math.max(document.documentElement.clientWidth, window.innerWidth || 0),
		screenHeight: Math.max(document.documentElement.clientHeight, window.innerHeight || 0),
		userId: document.getElementById('userId').innerText,
		username: document.getElementById('username').innerText,
		loginToken: document.getElementById('loginToken').innerText,
		roomName: document.getElementById('roomName').innerText,
		scaledCardWidth: null, 
		scaledCardHeight: null, 
		scaleWidthRatio: null, 
		scaleHeightRatio: null, 
		currentUserPlayedCards: null, 
		user1PlayedCards: null, 
		user2PlayedCards: null, 
		user3PlayedCards: null,
		isShowingCoveredCards: false,
		cardsAtHand: null,
		coveredCards: null,
		background: null, 
		playCardsButton: null, 
		prepareButton: null,
		leaveButton: null,
		surrenderButton: null,
		settleCoveredCardsButton: null,
		startSwipeCardIndex: null, 
		endSwipeCardIndex: null,
		textOfCurrentScores: null,
		textOfAimedScores: null,
		textOfChipsWon: null,
		textOfRoomName: null,
		numberOfPlayersInRoom: 1,
		player1Username: null,
		player2Username: null,
		player3Username: null,
		user1Avatar: null,
		user2Avatar: null,
		user3Avatar: null,
		meStatusText: null,
		player1IsMakerText: null,
		player2IsMakerText: null,
		player3IsMakerText: null,
		player1StatusText: null,
		player2StatusText: null,
		player3StatusText: null,
		callScoreStage: null
	};

/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	var constants = __webpack_require__(1);
	var globalVariables = __webpack_require__(2);

	module.exports = {
		shuffleCards: function() {
		    var array = [];
		    var i, j;
		    for (j = 0; j < 2; j ++) {
		        for (i = 1; i <= 46; i ++) {
		            array.push(i);
		        }
		    }
		    var copy = [], n = array.length;
		    while (n) {
		        i = Math.floor(Math.random() * array.length);
		        if (i in array) {
		            copy.push(array[i]);
		            delete array[i];
		            n --;
		        }
		    }
		    return copy;
		},

		sortCards: function(array) {
		    var sortNumber = function(a, b) {
		        return a - b;
		    };
		    return array.sort(sortNumber);
		},

		getCardName: function(n) {
		    var cardName = '';
		    switch (n) {
		        case 1:
		        cardName = 'bigJoker';
		        break;
		        case 2:
		        cardName = 'smallJoker';
		        break;
		        case 3:
		        cardName = 'sevenOfSpades';
		        break;
		        case 4:
		        cardName = 'sevenOfHearts';
		        break;
		        case 5:
		        cardName = 'sevenOfClubs';
		        break;
		        case 6:
		        cardName = 'sevenOfDiamonds';
		        break;
		        case 7:
		        cardName = 'twoOfSpades';
		        break;
		        case 8:
		        cardName = 'twoOfHearts';
		        break;
		        case 9:
		        cardName = 'twoOfClubs';
		        break;
		        case 10:
		        cardName = 'twoOfDiamonds';
		        break;
		        case 11:
		        cardName = 'aceOfSpades';
		        break;
		        case 12: 
		        cardName = 'kingOfSpades';
		        break;
		        case 13:
		        cardName = 'queenOfSpades';
		        break;
		        case 14:
		        cardName = 'jackOfSpades';
		        break;
		        case 15:
		        cardName = 'tenOfSpades';
		        break;
		        case 16:
		        cardName = 'nineOfSpades';
		        break;
		        case 17:
		        cardName = 'eightOfSpades';
		        break;
		        case 18:
		        cardName = 'sixOfSpades';
		        break;
		        case 19:
		        cardName = 'fiveOfSpades';
		        break;
		        case 20:
		        cardName = 'aceOfHearts';
		        break;
		        case 21:
		        cardName = 'kingOfHearts';
		        break;
		        case 22:
		        cardName = 'queenOfHearts';
		        break;
		        case 23:
		        cardName = 'jackOfHearts';
		        break;
		        case 24:
		        cardName = 'tenOfHearts';
		        break;
		        case 25:
		        cardName = 'nineOfHearts';
		        break;
		        case 26:
		        cardName = 'eightOfHearts';
		        break;
		        case 27:
		        cardName = 'sixOfHearts';
		        break;
		        case 28:
		        cardName = 'fiveOfHearts';
		        break;
		        case 29:
		        cardName = 'aceOfClubs';
		        break;
		        case 30:
		        cardName = 'kingOfClubs';
		        break;
		        case 31:
		        cardName = 'queenOfClubs';
		        break;
		        case 32:
		        cardName = 'jackOfClubs';
		        break;
		        case 33:
		        cardName = 'tenOfClubs';
		        break;
		        case 34:
		        cardName = 'nineOfClubs';
		        break;
		        case 35:
		        cardName = 'eightOfClubs';
		        break;
		        case 36:
		        cardName = 'sixOfClubs';
		        break;
		        case 37:
		        cardName = 'fiveOfClubs';
		        break;
		        case 38:
		        cardName = 'aceOfDiamonds';
		        break;
		        case 39:
		        cardName = 'kingOfDiamonds';
		        break;
		        case 40:
		        cardName = 'queenOfDiamonds';
		        break;
		        case 41:
		        cardName = 'jackOfDiamonds';
		        break;
		        case 42:
		        cardName = 'tenOfDiamonds';
		        break;
		        case 43:
		        cardName = 'nineOfDiamonds';
		        break;
		        case 44:
		        cardName = 'eightOfDiamonds';
		        break;
		        case 45:
		        cardName = 'sixOfDiamonds';
		        break;
		        case 46:
		        cardName = 'fiveOfDiamonds';
		        break;
		        default:
		        break;
		    }
		    return cardName;
		},


		toggleCardSelection: function(sprite) {
		    if (!sprite.isSelected) {
		        sprite.y = sprite.y - constants.SELECTED_CARD_Y_OFFSET;
		    } else {
		        sprite.y = sprite.y + constants.SELECTED_CARD_Y_OFFSET;
		    }
		    sprite.isSelected = !sprite.isSelected;
		},

		showPlayedCardsForUser: function(n, valuesOfPlayedCards) {
		    var startX, startY, userPlayedCards;
		    switch (n) {
		        case 0:         // current user
		        startX = globalVariables.screenWidth / 2 - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 8;
		        startY = globalVariables.screenHeight - 2 * globalVariables.scaledCardHeight - 2 * constants.MARGIN;
		        userPlayedCards = globalVariables.currentUserPlayedCards;
		        break;
		        case 1:         // the 1st user
		        startX = globalVariables.screenWidth - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 4 - constants.MARGIN;
		        startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2;
		        userPlayedCards = globalVariables.user1PlayedCards;
		        break;
		        case 2:         // the 2nd user
		        startX = globalVariables.screenWidth / 2 - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 8;
		        startY = constants.MARGIN;
		        userPlayedCards = globalVariables.user2PlayedCards;
		        break;
		        case 3:         // the 3rd user
		        startX = constants.MARGIN;
		        startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2;
		        userPlayedCards = globalVariables.user3PlayedCards;
		        break;
		        default:
		        break;
		    }
		    // remove played cards
		    var cardsToRemove = [];
		    for (var i = 0; i < userPlayedCards.children.length; i ++) {
		        cardsToRemove.push(userPlayedCards.children[i]);
		    }
		    for (i = 0; i < cardsToRemove.length; i ++) {
		        userPlayedCards.remove(cardsToRemove[i]);
		    }

		    for (i = 0; i < valuesOfPlayedCards.length; i ++) {
		        var playedCard = userPlayedCards.create(startX + i * globalVariables.scaledCardWidth / 4, startY, this.getCardName(valuesOfPlayedCards[i]));
		        playedCard.width = globalVariables.scaledCardWidth;
		        playedCard.height = globalVariables.scaledCardHeight;
		    }
		},
	};

/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	var constants = __webpack_require__(1);
	var globalVariables = __webpack_require__(2);
	var toolbox = __webpack_require__(3);

	module.exports = {
	    showCoveredCards: function() {
	        var stageWidth = 11 * globalVariables.scaledCardWidth / 4 + 2 * constants.MARGIN;
	        var stageHeight = globalVariables.scaledCardHeight + 2 * constants.MARGIN;

	        var coveredCardsStage = globalVariables.coveredCards.create(globalVariables.screenWidth / 2 - stageWidth / 2, globalVariables.screenHeight / 2 - stageHeight / 2, 'stageBackground');
	        coveredCardsStage.alpha = 0.3;
	        coveredCardsStage.width = stageWidth;
	        coveredCardsStage.height = stageHeight;
	        for (var i = 0; i < globalVariables.coveredCards.indexes.length; i ++) {
	            var cardName = toolbox.getCardName(globalVariables.coveredCards.indexes[i]);
	            var coveredCard = globalVariables.coveredCards.create(coveredCardsStage.x + constants.MARGIN + i * globalVariables.scaledCardWidth / 4, coveredCardsStage.y + constants.MARGIN, cardName);
	            coveredCard.scale.setTo(globalVariables.scaleWidthRatio, globalVariables.scaleHeightRatio);
	        }
	        globalVariables.isShowingCoveredCards = true;
	    },

	    backgroundTapped: function() {
	        var i;
	        if (globalVariables.isShowingCoveredCards) {
	            // cancel showing covered cards
	            var spritesShouldBeRemoved = [];
	            for (i = 1; i <= 9; i ++) {
	                spritesShouldBeRemoved.push(globalVariables.coveredCards.children[i]);
	            }
	            for (i = 0; i < spritesShouldBeRemoved.length; i ++) {
	                globalVariables.coveredCards.remove(spritesShouldBeRemoved[i]);
	            }
	            globalVariables.isShowingCoveredCards = false;
	        } else {
	            // cancel card selections
	            for (i = 0; i < globalVariables.cardsAtHand.children.length; i ++) {
	                if (globalVariables.cardsAtHand.children[i].isSelected) {
	                    toolbox.toggleCardSelection(globalVariables.cardsAtHand.children[i]);
	                }
	            }
	        }
	    },

	    displayCards: function(array) {
	        var leftMargin = (globalVariables.screenWidth - (Math.floor(globalVariables.scaledCardWidth / 4) * array.length + Math.floor(3 * globalVariables.scaledCardWidth / 4))) / 2;
	        var i;
	        var spritesShouldBeRemoved = [];
	        if (globalVariables.cardsAtHand.children.length > 0) {
	            for (i = 0; i < globalVariables.cardsAtHand.children.length; i ++) {
	                spritesShouldBeRemoved.push(globalVariables.cardsAtHand.children[i]);
	            } 
	            for (i = 0; i < spritesShouldBeRemoved.length; i ++) {
	                globalVariables.cardsAtHand.remove(spritesShouldBeRemoved[i]); 
	            }
	        }
	        for (i = 0; i < array.length; i ++) {
	            var cardName = toolbox.getCardName(array[i]);
	            var cardSprite = globalVariables.cardsAtHand.create(leftMargin + i * Math.floor(globalVariables.scaledCardWidth / 4), globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.MARGIN, cardName);
	            cardSprite.scale.setTo(globalVariables.scaleWidthRatio, globalVariables.scaleHeightRatio);
	            cardSprite.isSelected = false;
	            cardSprite.inputEnabled = true;
	            cardSprite.index = i;
	            cardSprite.value = array[i];
	            cardSprite.input.useHandCursor = true;
	            cardSprite.events.onInputDown.add(this.tapDownOnSprite, this);
	            cardSprite.events.onInputUp.add(this.tapUp, this);
	        }
	    },

	    tapUp: function(sprite, pointer) {
	        if (pointer.x >= globalVariables.cardsAtHand.children[0].x && 
	            pointer.x <= (globalVariables.cardsAtHand.children[globalVariables.cardsAtHand.children.length - 1].x + globalVariables.cardsAtHand.children[globalVariables.cardsAtHand.children.length - 1].width) && 
	            pointer.y >= globalVariables.cardsAtHand.children[0].y && 
	            pointer.y <= (globalVariables.cardsAtHand.children[0].y + globalVariables.cardsAtHand.children[0].height)) {
	            globalVariables.endSwipeCardIndex = -1;
	            for (var i = 0; i < globalVariables.cardsAtHand.children.length - 1; i ++) {
	                if (pointer.x >= globalVariables.cardsAtHand.children[i].x &&
	                    pointer.x <= globalVariables.cardsAtHand.children[i + 1].x) {
	                    globalVariables.endSwipeCardIndex = i;
	                    break;
	                }
	            }
	            if (globalVariables.endSwipeCardIndex == -1) {
	                globalVariables.endSwipeCardIndex = globalVariables.cardsAtHand.children.length - 1;
	            }
	            if (globalVariables.startSwipeCardIndex <= globalVariables.endSwipeCardIndex) {
	                for (i = globalVariables.startSwipeCardIndex; i <= globalVariables.endSwipeCardIndex; i ++) {
	                    toolbox.toggleCardSelection(globalVariables.cardsAtHand.children[i]);
	                }
	            } else {
	                for (i = globalVariables.startSwipeCardIndex; i >= globalVariables.endSwipeCardIndex; i --) {
	                    toolbox.toggleCardSelection(globalVariables.cardsAtHand.children[i]);
	                }
	            }
	        }
	    },

	    tapDownOnSprite: function(sprite, pointer) {
	        globalVariables.startSwipeCardIndex = sprite.index;
	    },

	    playSelectedCards: function() {
	        var selectedCards = [];
	        var valuesOfCurrentUserPlayedCards = [];
	        for (var i = 0; i < globalVariables.cardsAtHand.children.length; i ++) {
	            if (globalVariables.cardsAtHand.children[i].isSelected) {
	                selectedCards.push(globalVariables.cardsAtHand.children[i]);
	                valuesOfCurrentUserPlayedCards.push(globalVariables.cardsAtHand.children[i].value);
	            }
	        }
	        if (selectedCards.length === 0) {
	            return;
	        }
	        for (i = 0; i < selectedCards.length; i ++) {
	            globalVariables.cardsAtHand.remove(selectedCards[i]);
	        }
	        // reposition the remaining cards
	        var numOfCardsLeft = globalVariables.cardsAtHand.children.length;
	        var leftMargin = (globalVariables.screenWidth - (Math.floor(globalVariables.scaledCardWidth / 4) * numOfCardsLeft + Math.floor(3 * globalVariables.scaledCardWidth / 4))) / 2;
	        for (i = 0; i < globalVariables.cardsAtHand.children.length; i ++) {
	            globalVariables.cardsAtHand.children[i].x = leftMargin + i * Math.floor(globalVariables.scaledCardWidth / 4);
	            globalVariables.cardsAtHand.children[i].index = i;
	        }

	        toolbox.showPlayedCardsForUser(0, valuesOfCurrentUserPlayedCards);
	    },

	    showPlayer1Info: function(game, username) {
	        globalVariables.user1Avatar = game.add.sprite(globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'avatar');
	        globalVariables.user1Avatar.width /= 2;
	        globalVariables.user1Avatar.height /= 2;
	        globalVariables.player1IsMakerText = game.add.text(globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, '', constants.RED_TEXT_STYLE);
	        globalVariables.player1Username = game.add.text(globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY + constants.AVATAR_SIZE / 2 + constants.MARGIN, username, constants.TEXT_STYLE);
	        globalVariables.player1Username.setTextBounds(0, 0, constants.AVATAR_SIZE, 25);
	    },

	    showPlayer2Info: function(game, username) {
	        globalVariables.user2Avatar = game.add.sprite(game.world.centerX - constants.AVATAR_SIZE / 2, constants.MARGIN, 'avatar');
	        globalVariables.user2Avatar.width /= 2;
	        globalVariables.player2IsMakerText = game.add.text(game.world.centerX - constants.AVATAR_SIZE / 2, constants.MARGIN, '', constants.RED_TEXT_STYLE);
	        globalVariables.user2Avatar.height /= 2;
	        globalVariables.player2Username = game.add.text(game.world.centerX - constants.AVATAR_SIZE / 2, constants.AVATAR_SIZE + 2 * constants.MARGIN, username, constants.TEXT_STYLE);
	        globalVariables.player2Username.setTextBounds(0, 0, constants.AVATAR_SIZE, 25);
	    },

	    showPlayer3Info: function(game, username) {
	        globalVariables.user3Avatar = game.add.sprite(constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'avatar');
	        globalVariables.user3Avatar.width /= 2;
	        globalVariables.user3Avatar.height /= 2;
	        globalVariables.player3IsMakerText = game.add.text(constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, '', constants.RED_TEXT_STYLE);
	        globalVariables.player3Username = game.add.text(constants.MARGIN, game.world.centerY + constants.AVATAR_SIZE / 2 + constants.MARGIN, username, constants.TEXT_STYLE);
	        globalVariables.player3Username.setTextBounds(0, 0, constants.AVATAR_SIZE, 25);
	    },

	    hideLeftPlayer: function(username) {
	        if (username == globalVariables.player1Username.text) {
	            globalVariables.user1Avatar.destroy();
	            globalVariables.player1Username.destroy();
	            globalVariables.player1IsMakerText.destroy();
	        } else if (username == globalVariables.player2Username.text) {
	            globalVariables.user2Avatar.destroy();
	            globalVariables.player2Username.destroy();
	            globalVariables.player2IsMakerText.destroy();
	        } else if (username == globalVariables.player3Username.text) {
	            globalVariables.user3Avatar.destroy();
	            globalVariables.player3Username.destroy();
	            globalVariables.player3IsMakerText.destroy();
	        }
	    },

	    sendGetReadyMessage: function() {
	        var csrfToken = document.getElementsByName('csrf-token')[0].content;
	        io.socket.post('/get_ready', {
	            _csrf: csrfToken,
	            userId: globalVariables.userId,
	            loginToken: globalVariables.loginToken
	        }, function (resData, jwres) {
	            if (jwres.statusCode == 200) {
	                globalVariables.prepareButton.visible = false;
	                globalVariables.leaveButton.visible = false;
	                globalVariables.meStatusText.text = 'Ready';
	            } else {
	                console.log(jwres);
	            }
	        });
	    },

	    leaveRoom: function() {
	        var csrfToken = document.getElementsByName('csrf-token')[0].content;
	        io.socket.post('/leave_room', {
	            _csrf: csrfToken,
	            userId: globalVariables.userId,
	            loginToken: globalVariables.loginToken
	        }, function (resData, jwres) {
	            if (jwres.statusCode == 200) {
	                window.location.href = '/';
	            }
	        });
	    },

	    showCallScorePanel: function(game, currentScore) {
	        globalVariables.callScoreStage = game.add.group();
	        var stageWidth = 11 * globalVariables.scaledCardWidth / 4 + 2 * constants.MARGIN;
	        var stageHeight = globalVariables.scaledCardHeight + 2 * constants.MARGIN;

	        var background = globalVariables.callScoreStage.create(globalVariables.screenWidth / 2 - stageWidth / 2, globalVariables.screenHeight / 2 - stageHeight / 2, 'stageBackground');
	        background.alpha = 0.3;
	        background.width = stageWidth;
	        background.height = stageHeight;

	        var raiseScoreButton = game.add.button(game.world.centerX - constants.ROUND_BUTTON_SIZE / 2 - constants.ROUND_BUTTON_SIZE - constants.MARGIN, game.world.centerY - stageHeight / 2 + constants.MARGIN, 'raiseScoreButton', this.raiseScore, this, 1, 0, 1, 0);
	        globalVariables.callScoreStage.add(raiseScoreButton);

	        var currentScoreText = game.add.text(game.world.centerX - constants.ROUND_BUTTON_SIZE / 2, game.world.centerY - stageHeight / 2 + constants.MARGIN, '' + currentScore - 5, constants.LARGE_TEXT_STYLE);
	        currentScoreText.setTextBounds(0, 0, constants.ROUND_BUTTON_SIZE, constants.ROUND_BUTTON_SIZE);
	        globalVariables.callScoreStage.add(currentScoreText);

	        var lowerScoreButton = game.add.button(game.world.centerX + constants.ROUND_BUTTON_SIZE / 2 + constants.MARGIN, game.world.centerY - stageHeight / 2 + constants.MARGIN, 'lowerScoreButton', this.lowerScore, this, 1, 0, 1, 0);
	        globalVariables.callScoreStage.add(lowerScoreButton);

	        var setScoreButton = game.add.button(game.world.centerX - constants.BUTTON_WIDTH - constants.MARGIN / 2, game.world.centerY + constants.ROUND_BUTTON_SIZE / 2, 'setScoreButton', this.setScore, this, 1, 0, 1, 0);
	        globalVariables.callScoreStage.add(setScoreButton);

	        var passButton = game.add.button(game.world.centerX + constants.MARGIN / 2, game.world.centerY + constants.ROUND_BUTTON_SIZE / 2, 'passButton', this.pass, this, 1, 0, 1, 0);
	        globalVariables.callScoreStage.add(passButton);
	    },

	    raiseScore: function() {
	        var aimedScores = parseInt(globalVariables.textOfAimedScores.text);
	        var currentSetScores = parseInt(globalVariables.callScoreStage.children[2].text);
	        if (currentSetScores < (aimedScores - 5)) {
	            currentSetScores += 5;
	            globalVariables.callScoreStage.children[2].text = '' + currentSetScores;
	        }
	    },

	    lowerScore: function() {
	        var aimedScores = parseInt(globalVariables.textOfAimedScores.text);
	        var currentSetScores = parseInt(globalVariables.callScoreStage.children[2].text);
	        if (currentSetScores > 5) {
	            currentSetScores -= 5;
	            globalVariables.callScoreStage.children[2].text = '' + currentSetScores;
	        }
	    },

	    setScore: function() {
	        var csrfToken = document.getElementsByName('csrf-token')[0].content;
	        var aimedScore = parseInt(globalVariables.callScoreStage.children[2].text);
	        io.socket.post('/set_score', {
	            score: aimedScore,
	            roomName: globalVariables.roomName,
	            _csrf: csrfToken,
	            userId: globalVariables.userId,
	            loginToken: globalVariables.loginToken
	        }, function (resData, jwres) {
	            if (jwres.statusCode == 200) {
	                globalVariables.callScoreStage.destroy(true, false);
	                globalVariables.meStatusText.text = '' + aimedScore;
	            }
	        });
	    },

	    pass: function() {
	        var csrfToken = document.getElementsByName('csrf-token')[0].content;
	        io.socket.post('/pass', {
	            _csrf: csrfToken,
	            userId: globalVariables.userId,
	            loginToken: globalVariables.loginToken,
	            username: globalVariables.username,
	            roomName: globalVariables.roomName
	        }, function (resData, jwres) {
	            if (jwres.statusCode == 200) {
	                globalVariables.callScoreStage.destroy(true, false);
	                globalVariables.meStatusText.text = '不要';
	            }
	        });
	    },

	    surrender: function() {
	        var csrfToken = document.getElementsByName('csrf-token')[0].content;
	        globalVariables.prepareButton.visible = true;
	        globalVariables.leaveButton.visible = true;
	        globalVariables.meStatusText.text = '你输了';
	        globalVariables.surrenderButton.visible = false;
	        globalVariables.settleCoveredCardsButton.visible = false;
	    },

	    settleCoveredCards: function() {

	    }

	};


/***/ }
/******/ ]);
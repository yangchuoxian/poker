var constants = require('./constants.js');
var globalVariables = require('./globalVariables.js');
var toolbox = require('./toolbox.js');

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

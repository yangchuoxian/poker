// Generated by CoffeeScript 1.10.0
(function() {
  var backgroundTapped, constants, displayCards, globalVariables, hideHistoricalRecordStage, hideLeftPlayer, leaveRoom, lowerScore, pass, playSelectedCards, raiseScore, selectSuit, sendGetReadyMessage, setScore, settleCoveredCards, showBigStampForTheLargestPlayedCardsCurrentRound, showCallScorePanel, showCoveredCards, showEarnedScoreTextWithFadeOutEffect, showHistoricallyPlayedCards, showLastRoundPlayedCards, showNextRoundPlayedCards, showPlayedCardsForUser, showPlayer1Info, showPlayer2Info, showPlayer3Info, showSelectSuitPanel, suitTapEffect, surrender, tapDownOnSprite, tapUp, toggleCardSelection, toggleLastAndNextRoundButton, toolbox;

  constants = require('./constants.js');

  globalVariables = require('./globalVariables.js');

  toolbox = require('./toolbox.js');

  toggleCardSelection = function(sprite) {
    if (!sprite.isSelected) {
      sprite.y = sprite.y - constants.SELECTED_CARD_Y_OFFSET;
    } else {
      sprite.y = sprite.y + constants.SELECTED_CARD_Y_OFFSET;
    }
    return sprite.isSelected = !sprite.isSelected;
  };

  displayCards = function(array) {
    var cardName, cardSprite, i, j, k, l, leftMargin, ref, ref1, ref2, results, spritesShouldBeRemoved;
    leftMargin = (globalVariables.screenWidth - (Math.floor(globalVariables.scaledCardWidth / 4) * array.length + Math.floor(3 * globalVariables.scaledCardWidth / 4))) / 2;
    spritesShouldBeRemoved = [];
    if (globalVariables.cardsAtHand.children.length > 0) {
      for (i = j = 0, ref = globalVariables.cardsAtHand.children.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        spritesShouldBeRemoved.push(globalVariables.cardsAtHand.children[i]);
      }
      for (i = k = 0, ref1 = spritesShouldBeRemoved.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
        globalVariables.cardsAtHand.remove(spritesShouldBeRemoved[i]);
      }
    }
    results = [];
    for (i = l = 0, ref2 = array.length; 0 <= ref2 ? l < ref2 : l > ref2; i = 0 <= ref2 ? ++l : --l) {
      cardName = toolbox.getCardName(array[i]);
      cardSprite = globalVariables.cardsAtHand.create(leftMargin + i * Math.floor(globalVariables.scaledCardWidth / 4), globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.MARGIN, cardName);
      cardSprite.scale.setTo(globalVariables.scaleWidthRatio, globalVariables.scaleHeightRatio);
      cardSprite.isSelected = false;
      cardSprite.inputEnabled = true;
      cardSprite.index = i;
      cardSprite.value = array[i];
      cardSprite.input.useHandCursor = true;
      cardSprite.events.onInputDown.add(tapDownOnSprite, this);
      results.push(cardSprite.events.onInputUp.add(tapUp, this));
    }
    return results;
  };

  showEarnedScoreTextWithFadeOutEffect = function(numOfScoresEarnedCurrentRound, game) {
    globalVariables.textOfEarnedScores.text = '+ ' + numOfScoresEarnedCurrentRound;
    globalVariables.textOfEarnedScores.alpha = 1;
    return game.add.tween(globalVariables.textOfEarnedScores).to({
      alpha: 0
    }, 2000, Phaser.Easing.Linear.None, true);
  };

  showBigStampForTheLargestPlayedCardsCurrentRound = function(numOfCardsPlayed, usernameWithLargestCardsForCurrentRound, game) {
    var startX, startY;
    startX = null;
    startY = null;
    if (usernameWithLargestCardsForCurrentRound === globalVariables.username) {
      startX = globalVariables.screenWidth / 2 + (numOfCardsPlayed + 3) * globalVariables.scaledCardWidth / 8 - constants.MAKER_ICON_SIZE / 2;
      startY = globalVariables.screenHeight - 2 * globalVariables.scaledCardHeight - 2 * constants.MARGIN - constants.MAKER_ICON_SIZE / 2;
    } else if (usernameWithLargestCardsForCurrentRound === globalVariables.player1Username.text) {
      startX = globalVariables.screenWidth - 2 * constants.MARGIN - constants.AVATAR_SIZE - constants.MAKER_ICON_SIZE / 2;
      startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2 - constants.MAKER_ICON_SIZE / 2;
    } else if (usernameWithLargestCardsForCurrentRound === globalVariables.player2Username.text) {
      startX = globalVariables.screenWidth / 2 + (numOfCardsPlayed + 3) * globalVariables.scaledCardWidth / 8 - constants.MAKER_ICON_SIZE / 2;
      startY = 2 * constants.MARGIN + constants.AVATAR_SIZE - constants.MAKER_ICON_SIZE / 2;
    } else if (usernameWithLargestCardsForCurrentRound === globalVariables.player3Username.text) {
      startX = (numOfCardsPlayed + 3) * globalVariables.scaledCardWidth / 4 + 2 * constants.MARGIN + constants.AVATAR_SIZE - constants.MAKER_ICON_SIZE / 2;
      startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2 - constants.MAKER_ICON_SIZE / 2;
    }
    globalVariables.bigSign = game.add.sprite(startX, startY, 'big');
    globalVariables.bigSign.width = constants.MAKER_ICON_SIZE;
    return globalVariables.bigSign.height = constants.MAKER_ICON_SIZE;
  };


  /*
  Show played cards or historically played cards as sprites for specific player
  @param: n                               player index
  @param: valuesOfPlayedCards             values of played cards or historically played cards
  @param: isCurrentRound                  boolean value:
                                          - true: the played cards is for current round
                                          - false: the played cards is for historical round
   */

  showPlayedCardsForUser = function(n, valuesOfPlayedCards, isCurrentRound) {
    var i, j, playedCard, ref, results, startX, startY, userPlayedCards;
    startX = null;
    startY = null;
    userPlayedCards = null;
    switch (n) {
      case 0:
        startX = globalVariables.screenWidth / 2 - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 8;
        startY = globalVariables.screenHeight - 2 * globalVariables.scaledCardHeight - 2 * constants.MARGIN;
        if (isCurrentRound) {
          userPlayedCards = globalVariables.currentUserPlayedCards;
        } else {
          userPlayedCards = globalVariables.meHistoricalPlayedCardGroupForOneRound;
        }
        break;
      case 1:
        startX = globalVariables.screenWidth - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 4 - 2 * constants.MARGIN - constants.AVATAR_SIZE;
        startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2;
        if (isCurrentRound) {
          userPlayedCards = globalVariables.user1PlayedCards;
        } else {
          userPlayedCards = globalVariables.player1HistoricalPlayedCardGroupForOneRound;
        }
        break;
      case 2:
        startX = globalVariables.screenWidth / 2 - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 8;
        startY = 2 * constants.MARGIN + constants.AVATAR_SIZE;
        if (isCurrentRound) {
          userPlayedCards = globalVariables.user2PlayedCards;
        } else {
          userPlayedCards = globalVariables.player2HistoricalPlayedCardGroupForOneRound;
        }
        break;
      case 3:
        startX = 2 * constants.MARGIN + constants.AVATAR_SIZE;
        startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2;
        if (isCurrentRound) {
          userPlayedCards = globalVariables.user3PlayedCards;
        } else {
          userPlayedCards = globalVariables.player3HistoricalPlayedCardGroupForOneRound;
        }
    }
    userPlayedCards.removeAll();
    results = [];
    for (i = j = 0, ref = valuesOfPlayedCards.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      playedCard = userPlayedCards.create(startX + i * globalVariables.scaledCardWidth / 4, startY, toolbox.getCardName(valuesOfPlayedCards[i]));
      playedCard.width = globalVariables.scaledCardWidth;
      results.push(playedCard.height = globalVariables.scaledCardHeight);
    }
    return results;
  };

  sendGetReadyMessage = function() {
    var csrfToken;
    csrfToken = document.getElementsByName('csrf-token')[0].content;
    globalVariables.meStatusText.text = 'Ready';
    return io.socket.post('/get_ready', {
      _csrf: csrfToken,
      userId: globalVariables.userId,
      loginToken: globalVariables.loginToken
    }, function(resData, jwres) {
      if (jwres.statusCode === 200) {
        globalVariables.prepareButton.visible = false;
        return globalVariables.leaveButton.visible = false;
      } else {
        return alert(resData);
      }
    });
  };

  showCoveredCards = function() {
    var cardName, coveredCard, coveredCardsStage, i, j, ref, stageHeight, stageWidth;
    if (!globalVariables.isShowingCoveredCards) {
      stageWidth = 11 * globalVariables.scaledCardWidth / 4 + 2 * constants.MARGIN;
      stageHeight = globalVariables.scaledCardHeight + 2 * constants.MARGIN;
      coveredCardsStage = globalVariables.coveredCards.create(globalVariables.screenWidth / 2 - stageWidth / 2, globalVariables.screenHeight / 2 - stageHeight / 2, 'stageBackground');
      coveredCardsStage.alpha = 0.3;
      coveredCardsStage.width = stageWidth;
      coveredCardsStage.height = stageHeight;
      for (i = j = 0, ref = globalVariables.coveredCards.indexes.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        cardName = toolbox.getCardName(globalVariables.coveredCards.indexes[i]);
        coveredCard = globalVariables.coveredCards.create(coveredCardsStage.x + constants.MARGIN + i * globalVariables.scaledCardWidth / 4, coveredCardsStage.y + constants.MARGIN, cardName);
        coveredCard.scale.setTo(globalVariables.scaleWidthRatio, globalVariables.scaleHeightRatio);
      }
      return globalVariables.isShowingCoveredCards = true;
    }
  };

  tapUp = function(sprite, pointer) {
    var i, j, k, l, m, ref, ref1, ref2, ref3, ref4, ref5, selectedCardValues;
    if (pointer.x >= globalVariables.cardsAtHand.children[0].x && pointer.x <= (globalVariables.cardsAtHand.children[globalVariables.cardsAtHand.children.length - 1].x + globalVariables.cardsAtHand.children[globalVariables.cardsAtHand.children.length - 1].width) && pointer.y >= globalVariables.cardsAtHand.children[0].y && pointer.y <= (globalVariables.cardsAtHand.children[0].y + globalVariables.cardsAtHand.children[0].height)) {
      globalVariables.endSwipeCardIndex = -1;
      for (i = j = 0, ref = globalVariables.cardsAtHand.children.length - 1; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        if (pointer.x >= globalVariables.cardsAtHand.children[i].x && pointer.x <= globalVariables.cardsAtHand.children[i + 1].x) {
          globalVariables.endSwipeCardIndex = i;
          break;
        }
      }
      if (globalVariables.endSwipeCardIndex === -1) {
        globalVariables.endSwipeCardIndex = globalVariables.cardsAtHand.children.length - 1;
      }
      if (globalVariables.startSwipeCardIndex <= globalVariables.endSwipeCardIndex) {
        for (i = k = ref1 = globalVariables.startSwipeCardIndex, ref2 = globalVariables.endSwipeCardIndex + 1; ref1 <= ref2 ? k < ref2 : k > ref2; i = ref1 <= ref2 ? ++k : --k) {
          toggleCardSelection(globalVariables.cardsAtHand.children[i]);
        }
      } else {
        for (i = l = ref3 = globalVariables.endSwipeCardIndex, ref4 = globalVariables.startSwipeCardIndex + 1; ref3 <= ref4 ? l < ref4 : l > ref4; i = ref3 <= ref4 ? ++l : --l) {
          toggleCardSelection(globalVariables.cardsAtHand.children[i]);
        }
      }
      selectedCardValues = [];
      for (i = m = 0, ref5 = globalVariables.cardsAtHand.children.length; 0 <= ref5 ? m < ref5 : m > ref5; i = 0 <= ref5 ? ++m : --m) {
        if (globalVariables.cardsAtHand.children[i].isSelected) {
          selectedCardValues.push(globalVariables.cardsAtHand.children[i].value);
        }
      }
      if (globalVariables.gameStatus === constants.GAME_STATUS_SETTLING_COVERED_CARDS) {
        if (selectedCardValues.length === 8) {
          globalVariables.settleCoveredCardsButton.inputEnabled = true;
          return globalVariables.settleCoveredCardsButton.setFrames(1, 0, 1);
        } else {
          globalVariables.settleCoveredCardsButton.inputEnabled = false;
          return globalVariables.settleCoveredCardsButton.setFrames(2, 2, 2);
        }
      } else if (globalVariables.gameStatus === constants.GAME_STATUS_PLAYING) {
        if (toolbox.validateSelectedCardsForPlay(selectedCardValues, globalVariables.firstlyPlayedCardValuesForCurrentRound, globalVariables.cardsAtHand.values, globalVariables.mainSuit, globalVariables.cardValueRanks)) {
          globalVariables.playCardsButton.inputEnabled = true;
          return globalVariables.playCardsButton.setFrames(1, 0, 1);
        } else {
          globalVariables.playCardsButton.inputEnabled = false;
          return globalVariables.playCardsButton.setFrames(2, 2, 2);
        }
      }
    }
  };

  tapDownOnSprite = function(sprite, pointer) {
    return globalVariables.startSwipeCardIndex = sprite.index;
  };

  hideLeftPlayer = function(username) {
    if (globalVariables.player1Username) {
      if (username === globalVariables.player1Username.text) {
        globalVariables.user1Avatar.destroy();
        globalVariables.player1Username.destroy();
        globalVariables.player1IsMakerIcon.destroy();
        globalVariables.player1StatusText.destroy();
      }
    }
    if (globalVariables.player2Username) {
      if (username === globalVariables.player2Username.text) {
        globalVariables.user2Avatar.destroy();
        globalVariables.player2Username.destroy();
        globalVariables.player2IsMakerIcon.destroy();
        globalVariables.player2StatusText.destroy();
      }
    }
    if (globalVariables.player3Username) {
      if (username === globalVariables.player3Username.text) {
        globalVariables.user3Avatar.destroy();
        globalVariables.player3Username.destroy();
        globalVariables.player3IsMakerIcon.destroy();
        return globalVariables.player3StatusText.destroy();
      }
    }
  };

  backgroundTapped = function() {
    var i, j, k, l, ref, ref1, spritesShouldBeRemoved;
    if (globalVariables.isShowingCoveredCards) {
      spritesShouldBeRemoved = [];
      for (i = j = 1; j < 10; i = ++j) {
        spritesShouldBeRemoved.push(globalVariables.coveredCards.children[i]);
      }
      for (i = k = 0, ref = spritesShouldBeRemoved.length; 0 <= ref ? k < ref : k > ref; i = 0 <= ref ? ++k : --k) {
        globalVariables.coveredCards.remove(spritesShouldBeRemoved[i]);
      }
      globalVariables.isShowingCoveredCards = false;
    } else {
      for (i = l = 0, ref1 = globalVariables.cardsAtHand.children.length; 0 <= ref1 ? l < ref1 : l > ref1; i = 0 <= ref1 ? ++l : --l) {
        if (globalVariables.cardsAtHand.children[i].isSelected) {
          toggleCardSelection(globalVariables.cardsAtHand.children[i]);
        }
      }
    }
    if (globalVariables.gameStatus === constants.GAME_STATUS_PLAYING) {
      globalVariables.playCardsButton.inputEnabled = false;
      globalVariables.playCardsButton.setFrames(2, 2, 2);
    }
    if (globalVariables.gameStatus === constants.GAME_STATUS_SETTLING_COVERED_CARDS) {
      globalVariables.settleCoveredCardsButton.inputEnabled = false;
      return globalVariables.settleCoveredCardsButton.setFrames(2, 2, 2);
    }
  };

  playSelectedCards = function() {
    var csrfToken, i, j, ref, selectedCards, valuesOfCurrentUserPlayedCards;
    selectedCards = [];
    valuesOfCurrentUserPlayedCards = [];
    globalVariables.playCardsButton.inputEnabled = false;
    globalVariables.playCardsButton.setFrames(2, 2, 2);
    globalVariables.playCardsButton.visible = false;
    for (i = j = 0, ref = globalVariables.cardsAtHand.children.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      if (globalVariables.cardsAtHand.children[i].isSelected) {
        selectedCards.push(globalVariables.cardsAtHand.children[i]);
        valuesOfCurrentUserPlayedCards.push(globalVariables.cardsAtHand.children[i].value);
      }
    }
    csrfToken = document.getElementsByName('csrf-token')[0].content;
    return io.socket.post('/play_cards', {
      playedCardValues: valuesOfCurrentUserPlayedCards,
      roomName: globalVariables.roomName,
      _csrf: csrfToken,
      userId: globalVariables.userId,
      loginToken: globalVariables.loginToken
    }, function(resData, jwres) {
      var index, k, l, leftMargin, numOfCardsLeft, ref1, ref2;
      if (jwres.statusCode === 200) {
        for (i = k = 0, ref1 = selectedCards.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
          globalVariables.cardsAtHand.remove(selectedCards[i]);
          index = globalVariables.cardsAtHand.values.indexOf(selectedCards[i].value);
          globalVariables.cardsAtHand.values.splice(index, 1);
        }
        numOfCardsLeft = globalVariables.cardsAtHand.children.length;
        leftMargin = (globalVariables.screenWidth - (Math.floor(globalVariables.scaledCardWidth / 4) * numOfCardsLeft + Math.floor(3 * globalVariables.scaledCardWidth / 4))) / 2;
        for (i = l = 0, ref2 = globalVariables.cardsAtHand.children.length; 0 <= ref2 ? l < ref2 : l > ref2; i = 0 <= ref2 ? ++l : --l) {
          globalVariables.cardsAtHand.children[i].x = leftMargin + i * Math.floor(globalVariables.scaledCardWidth / 4);
          globalVariables.cardsAtHand.children[i].index = i;
        }
        return showPlayedCardsForUser(0, valuesOfCurrentUserPlayedCards, true);
      } else {
        return console.log(resData);
      }
    });
  };

  showPlayer1Info = function(game, username) {
    globalVariables.user1Avatar = game.add.sprite(globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'avatar');
    globalVariables.user1Avatar.width /= 2;
    globalVariables.user1Avatar.height /= 2;
    globalVariables.player1IsMakerIcon = game.add.sprite(globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'makerIcon');
    globalVariables.player1IsMakerIcon.width = constants.MAKER_ICON_SIZE;
    globalVariables.player1IsMakerIcon.height = constants.MAKER_ICON_SIZE;
    globalVariables.player1IsMakerIcon.visible = false;
    globalVariables.player1Username = game.add.text(globalVariables.screenWidth - constants.AVATAR_SIZE - constants.MARGIN, game.world.centerY + constants.AVATAR_SIZE / 2 + constants.MARGIN, username, constants.TEXT_STYLE);
    return globalVariables.player1Username.setTextBounds(0, 0, constants.AVATAR_SIZE, 25);
  };

  showPlayer2Info = function(game, username) {
    globalVariables.user2Avatar = game.add.sprite(game.world.centerX - constants.AVATAR_SIZE / 2, constants.MARGIN, 'avatar');
    globalVariables.user2Avatar.width /= 2;
    globalVariables.user2Avatar.height /= 2;
    globalVariables.player2IsMakerIcon = game.add.sprite(game.world.centerX - constants.AVATAR_SIZE / 2, constants.MARGIN, 'makerIcon');
    globalVariables.player2IsMakerIcon.width = constants.MAKER_ICON_SIZE;
    globalVariables.player2IsMakerIcon.height = constants.MAKER_ICON_SIZE;
    globalVariables.player2IsMakerIcon.visible = false;
    globalVariables.player2Username = game.add.text(game.world.centerX - constants.AVATAR_SIZE / 2, constants.AVATAR_SIZE + 2 * constants.MARGIN, username, constants.TEXT_STYLE);
    return globalVariables.player2Username.setTextBounds(0, 0, constants.AVATAR_SIZE, 25);
  };

  showPlayer3Info = function(game, username) {
    globalVariables.user3Avatar = game.add.sprite(constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'avatar');
    globalVariables.user3Avatar.width /= 2;
    globalVariables.user3Avatar.height /= 2;
    globalVariables.player3IsMakerIcon = game.add.sprite(constants.MARGIN, game.world.centerY - constants.AVATAR_SIZE / 2, 'makerIcon');
    globalVariables.player3IsMakerIcon.width = constants.MAKER_ICON_SIZE;
    globalVariables.player3IsMakerIcon.height = constants.MAKER_ICON_SIZE;
    globalVariables.player3IsMakerIcon.visible = false;
    globalVariables.player3Username = game.add.text(constants.MARGIN, game.world.centerY + constants.AVATAR_SIZE / 2 + constants.MARGIN, username, constants.TEXT_STYLE);
    return globalVariables.player3Username.setTextBounds(0, 0, constants.AVATAR_SIZE, 25);
  };

  raiseScore = function() {
    var aimedScores, currentSetScores;
    aimedScores = parseInt(globalVariables.textOfAimedScores.text);
    currentSetScores = parseInt(globalVariables.callScoreStage.children[2].text);
    if (currentSetScores < (aimedScores - 5)) {
      currentSetScores += 5;
      return globalVariables.callScoreStage.children[2].text = '' + currentSetScores;
    }
  };

  showCallScorePanel = function(game, currentScore) {
    var background, currentScoreText, lowerScoreButton, passButton, raiseScoreButton, setScoreButton, stageHeight, stageWidth;
    globalVariables.callScoreStage = game.add.group();
    stageWidth = 11 * globalVariables.scaledCardWidth / 4 + 2 * constants.MARGIN;
    stageHeight = globalVariables.scaledCardHeight + 2 * constants.MARGIN;
    background = globalVariables.callScoreStage.create(globalVariables.screenWidth / 2 - stageWidth / 2, globalVariables.screenHeight / 2 - stageHeight / 2, 'stageBackground');
    background.alpha = 0.3;
    background.width = stageWidth;
    background.height = stageHeight;
    raiseScoreButton = game.add.button(game.world.centerX - constants.ROUND_BUTTON_SIZE / 2 - constants.ROUND_BUTTON_SIZE - constants.MARGIN, game.world.centerY - stageHeight / 2 + constants.MARGIN, 'raiseScoreButton', raiseScore, this, 1, 0, 1, 0);
    globalVariables.callScoreStage.add(raiseScoreButton);
    currentScoreText = game.add.text(game.world.centerX - constants.ROUND_BUTTON_SIZE / 2, game.world.centerY - stageHeight / 2 + constants.MARGIN, '' + currentScore - 5, constants.LARGE_TEXT_STYLE);
    currentScoreText.setTextBounds(0, 0, constants.ROUND_BUTTON_SIZE, constants.ROUND_BUTTON_SIZE);
    globalVariables.callScoreStage.add(currentScoreText);
    lowerScoreButton = game.add.button(game.world.centerX + constants.ROUND_BUTTON_SIZE / 2 + constants.MARGIN, game.world.centerY - stageHeight / 2 + constants.MARGIN, 'lowerScoreButton', lowerScore, this, 1, 0, 1);
    globalVariables.callScoreStage.add(lowerScoreButton);
    setScoreButton = game.add.button(game.world.centerX - constants.BUTTON_WIDTH - constants.MARGIN / 2, game.world.centerY + constants.ROUND_BUTTON_SIZE / 2, 'setScoreButton', setScore, this, 1, 0, 1);
    globalVariables.callScoreStage.add(setScoreButton);
    passButton = game.add.button(game.world.centerX + constants.MARGIN / 2, game.world.centerY + constants.ROUND_BUTTON_SIZE / 2, 'passButton', pass, this, 1, 0, 1, 0);
    return globalVariables.callScoreStage.add(passButton);
  };

  setScore = function() {
    var aimedScore, csrfToken;
    csrfToken = document.getElementsByName('csrf-token')[0].content;
    aimedScore = parseInt(globalVariables.callScoreStage.children[2].text);
    return io.socket.post('/set_score', {
      score: aimedScore,
      roomName: globalVariables.roomName,
      _csrf: csrfToken,
      userId: globalVariables.userId,
      loginToken: globalVariables.loginToken
    }, function(resData, jwres) {
      if (jwres.statusCode === 200) {
        globalVariables.callScoreStage.destroy(true, false);
        return globalVariables.meStatusText.text = '' + aimedScore;
      } else {
        return alert(resData);
      }
    });
  };

  lowerScore = function() {
    var aimedScores, currentSetScores;
    aimedScores = parseInt(globalVariables.textOfAimedScores.text);
    currentSetScores = parseInt(globalVariables.callScoreStage.children[2].text);
    if (currentSetScores > 5) {
      currentSetScores -= 5;
      return globalVariables.callScoreStage.children[2].text = '' + currentSetScores;
    }
  };

  pass = function() {
    var csrfToken;
    csrfToken = document.getElementsByName('csrf-token')[0].content;
    globalVariables.meStatusText.text = '不要';
    return io.socket.post('/pass', {
      _csrf: csrfToken,
      userId: globalVariables.userId,
      loginToken: globalVariables.loginToken,
      username: globalVariables.username,
      roomName: globalVariables.roomName
    }, function(resData, jwres) {
      if (jwres.statusCode === 200) {
        return globalVariables.callScoreStage.destroy(true, false);
      } else {
        return alert(resData);
      }
    });
  };

  surrender = function() {
    var csrfToken;
    csrfToken = document.getElementsByName('csrf-token')[0].content;
    globalVariables.prepareButton.visible = true;
    globalVariables.leaveButton.visible = true;
    globalVariables.meStatusText.text = '你输了';
    globalVariables.surrenderButton.visible = false;
    return globalVariables.settleCoveredCardsButton.visible = false;
  };

  settleCoveredCards = function() {
    var coveredCardsIcon, csrfToken, i, index, j, k, ref, ref1, valuesOfSelectedCoveredCards;
    valuesOfSelectedCoveredCards = [];
    for (i = j = 0, ref = globalVariables.cardsAtHand.children.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      if (globalVariables.cardsAtHand.children[i].isSelected) {
        valuesOfSelectedCoveredCards.push(globalVariables.cardsAtHand.children[i].value);
      }
    }
    if (valuesOfSelectedCoveredCards.length !== 8) {
      return;
    }
    for (i = k = 0, ref1 = valuesOfSelectedCoveredCards.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
      index = globalVariables.cardsAtHand.values.indexOf(valuesOfSelectedCoveredCards[i]);
      globalVariables.cardsAtHand.values.splice(index, 1);
    }
    displayCards(globalVariables.cardsAtHand.values);
    coveredCardsIcon = globalVariables.coveredCards.create(constants.MARGIN, constants.MARGIN, 'back');
    coveredCardsIcon.scale.setTo(globalVariables.scaleWidthRatio, globalVariables.scaleHeightRatio);
    coveredCardsIcon.inputEnabled = true;
    globalVariables.coveredCards.indexes = valuesOfSelectedCoveredCards;
    coveredCardsIcon.events.onInputDown.add(showCoveredCards, this);
    globalVariables.settleCoveredCardsButton.visible = false;
    globalVariables.settleCoveredCardsButton.inputEnabled = false;
    globalVariables.settleCoveredCardsButton.setFrames(2, 2, 2);
    csrfToken = document.getElementsByName('csrf-token')[0].content;
    return io.socket.post('/settleCoveredCards', {
      _csrf: csrfToken,
      userId: globalVariables.userId,
      loginToken: globalVariables.loginToken,
      roomName: globalVariables.roomName,
      coveredCards: globalVariables.coveredCards.indexes,
      maker: globalVariables.username,
      cardsAtHand: globalVariables.cardsAtHand.values
    }, function(resData, jwres) {
      if (jwres.statusCode === 200) {
        return showSelectSuitPanel();
      } else {
        return alert(resData);
      }
    });
  };

  showSelectSuitPanel = function() {
    var background, clubIcon, diamondIcon, heartIcon, rectangle, spadeIcon, stageHeight, stageWidth;
    globalVariables.gameStatus = constants.GAME_STATUS_DECIDING_SUIT;
    globalVariables.selectSuitButton.visible = true;
    globalVariables.selectSuitButton.inputEnabled = false;
    globalVariables.selectSuitButton.setFrames(2, 2, 2);
    stageWidth = 4 * constants.SUIT_ICON_SIZE + 8 * constants.MARGIN;
    stageHeight = 2 * constants.MARGIN + constants.SUIT_ICON_SIZE;
    background = globalVariables.selectSuitStage.create(globalVariables.screenWidth / 2 - stageWidth / 2, globalVariables.screenHeight / 2 - stageHeight / 2, 'stageBackground');
    background.alpha = 0.3;
    background.width = stageWidth;
    background.height = stageHeight;
    globalVariables.selectSuitStage.add(background);
    spadeIcon = globalVariables.selectSuitStage.create(background.x + (1 + 2 * 0) * constants.MARGIN + 0 * constants.SUIT_ICON_SIZE, background.y + constants.MARGIN, 'spade');
    spadeIcon.width = constants.SUIT_ICON_SIZE;
    spadeIcon.height = constants.SUIT_ICON_SIZE;
    spadeIcon.inputEnabled = true;
    spadeIcon.input.useHandCursor = true;
    spadeIcon.events.onInputDown.add(function() {
      return suitTapEffect(1);
    }, this);
    globalVariables.selectSuitStage.add(spadeIcon);
    heartIcon = globalVariables.selectSuitStage.create(background.x + (1 + 2 * 1) * constants.MARGIN + 1 * constants.SUIT_ICON_SIZE, background.y + constants.MARGIN, 'heart');
    heartIcon.width = constants.SUIT_ICON_SIZE;
    heartIcon.height = constants.SUIT_ICON_SIZE;
    heartIcon.inputEnabled = true;
    heartIcon.input.useHandCursor = true;
    heartIcon.events.onInputDown.add(function() {
      return suitTapEffect(2);
    }, this);
    globalVariables.selectSuitStage.add(heartIcon);
    clubIcon = globalVariables.selectSuitStage.create(background.x + (1 + 2 * 2) * constants.MARGIN + 2 * constants.SUIT_ICON_SIZE, background.y + constants.MARGIN, 'club');
    clubIcon.width = constants.SUIT_ICON_SIZE;
    clubIcon.height = constants.SUIT_ICON_SIZE;
    clubIcon.inputEnabled = true;
    clubIcon.input.useHandCursor = true;
    clubIcon.events.onInputDown.add(function() {
      return suitTapEffect(3);
    }, this);
    globalVariables.selectSuitStage.add(clubIcon);
    diamondIcon = globalVariables.selectSuitStage.create(background.x + (1 + 2 * 3) * constants.MARGIN + 3 * constants.SUIT_ICON_SIZE, background.y + constants.MARGIN, 'diamond');
    diamondIcon.width = constants.SUIT_ICON_SIZE;
    diamondIcon.height = constants.SUIT_ICON_SIZE;
    diamondIcon.inputEnabled = true;
    diamondIcon.input.useHandCursor = true;
    diamondIcon.events.onInputDown.add(function() {
      return suitTapEffect(4);
    }, this);
    globalVariables.selectSuitStage.add(diamondIcon);
    rectangle = globalVariables.selectSuitStage.create(spadeIcon.x, spadeIcon.y, 'rectangle');
    rectangle.width = constants.SUIT_ICON_SIZE + 10;
    rectangle.height = constants.SUIT_ICON_SIZE + 10;
    rectangle.visible = false;
    return globalVariables.selectSuitStage.add(rectangle);
  };

  selectSuit = function() {
    var csrfToken;
    csrfToken = document.getElementsByName('csrf-token')[0].content;
    return io.socket.post('/chooseMainSuit', {
      _csrf: csrfToken,
      userId: globalVariables.userId,
      loginToken: globalVariables.loginToken,
      roomName: globalVariables.roomName,
      maker: globalVariables.username,
      mainSuit: globalVariables.mainSuit
    }, function(resData, jwres) {
      var i, j, k, ref, ref1, spritesShouldBeRemoved;
      if (jwres.statusCode === 200) {
        globalVariables.surrenderButton.visible = false;
        globalVariables.selectSuitButton.visible = false;
        spritesShouldBeRemoved = [];
        for (i = j = 0, ref = globalVariables.selectSuitStage.children.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
          spritesShouldBeRemoved.push(globalVariables.selectSuitStage.children[i]);
        }
        for (i = k = 0, ref1 = spritesShouldBeRemoved.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
          globalVariables.selectSuitStage.remove(spritesShouldBeRemoved[i]);
        }
        globalVariables.iconOfMainSuit.frame = globalVariables.mainSuit;
        globalVariables.playCardsButton.visible = true;
        globalVariables.playCardsButton.inputEnabled = false;
        globalVariables.playCardsButton.setFrames(2, 2, 2);
        return globalVariables.gameStatus = constants.GAME_STATUS_PLAYING;
      } else {
        return alert(resData);
      }
    });
  };

  suitTapEffect = function(suitIndex) {
    var rectangle, suitIcon;
    globalVariables.mainSuit = suitIndex;
    rectangle = globalVariables.selectSuitStage.children[globalVariables.selectSuitStage.children.length - 1];
    suitIcon = globalVariables.selectSuitStage.children[suitIndex];
    rectangle.x = suitIcon.x - 5;
    rectangle.y = suitIcon.y - 5;
    rectangle.visible = true;
    globalVariables.selectSuitButton.inputEnabled = true;
    return globalVariables.selectSuitButton.setFrames(1, 0, 1);
  };

  leaveRoom = function() {
    var csrfToken;
    csrfToken = document.getElementsByName('csrf-token')[0].content;
    return io.socket.post('/leave_room', {
      _csrf: csrfToken,
      userId: globalVariables.userId,
      loginToken: globalVariables.loginToken
    }, function(resData, jwres) {
      if (jwres.statusCode === 200) {
        return window.location.href = '/';
      } else {
        return alert(resData);
      }
    });
  };

  showHistoricallyPlayedCards = function(game) {
    var background, lastRoundButton, nextRoundButton;
    if (globalVariables.playCardsButton.visible === true) {
      globalVariables.isPlayCardButtonVisibleBeforeShowingHistoricalRecordStage = true;
      globalVariables.playCardsButton.visible = false;
    } else {
      globalVariables.isPlayCardButtonVisibleBeforeShowingHistoricalRecordStage = false;
    }
    globalVariables.historicalButton.visible = false;
    globalVariables.historicalRecordStage = game.add.group();
    background = globalVariables.historicalRecordStage.create(0, 0, 'stageBackground');
    background.alpha = 0.3;
    background.width = globalVariables.screenWidth;
    background.height = globalVariables.screenHeight;
    background.inputEnabled = true;
    background.events.onInputDown.add(hideHistoricalRecordStage, this);
    globalVariables.historicalRecordStage.add(background);
    lastRoundButton = game.add.button(globalVariables.screenWidth - 2 * constants.MARGIN - constants.BUTTON_WIDTH - constants.AVATAR_SIZE, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET, 'lastRound', showLastRoundPlayedCards, this, 1, 0, 1);
    globalVariables.historicalRecordStage.add(lastRoundButton);
    nextRoundButton = game.add.button(globalVariables.screenWidth - 2 * constants.MARGIN - constants.BUTTON_WIDTH - constants.AVATAR_SIZE, globalVariables.screenHeight - globalVariables.scaledCardHeight - constants.BUTTON_HEIGHT - 2 * constants.MARGIN - constants.SELECTED_CARD_Y_OFFSET + constants.MARGIN + constants.BUTTON_HEIGHT, 'nextRound', showNextRoundPlayedCards, this, 1, 0, 1);
    globalVariables.historicalRecordStage.add(nextRoundButton);
    globalVariables.historicalRoundIndex = globalVariables.meHistoricalPlayedCardValues.length;
    return showLastRoundPlayedCards();
  };

  hideHistoricalRecordStage = function() {
    if (globalVariables.isPlayCardButtonVisibleBeforeShowingHistoricalRecordStage === true) {
      globalVariables.playCardsButton.visible = true;
    }
    globalVariables.historicalRecordStage.destroy(true, false);
    globalVariables.historicalButton.visible = true;
    globalVariables.meHistoricalPlayedCardGroupForOneRound.removeAll();
    globalVariables.player1HistoricalPlayedCardGroupForOneRound.removeAll();
    globalVariables.player2HistoricalPlayedCardGroupForOneRound.removeAll();
    return globalVariables.player3HistoricalPlayedCardGroupForOneRound.removeAll();
  };

  toggleLastAndNextRoundButton = function() {
    if (globalVariables.meHistoricalPlayedCardValues.length === 1) {
      globalVariables.historicalRecordStage.children[1].inputEnabled = false;
      globalVariables.historicalRecordStage.children[1].setFrames(2, 2, 2);
      globalVariables.historicalRecordStage.children[2].inputEnabled = false;
      return globalVariables.historicalRecordStage.children[2].setFrames(2, 2, 2);
    } else if (globalVariables.historicalRoundIndex === 0) {
      globalVariables.historicalRecordStage.children[1].inputEnabled = false;
      globalVariables.historicalRecordStage.children[1].setFrames(2, 2, 2);
      globalVariables.historicalRecordStage.children[2].inputEnabled = true;
      return globalVariables.historicalRecordStage.children[2].setFrames(1, 0, 1);
    } else if (globalVariables.historicalRoundIndex === (globalVariables.meHistoricalPlayedCardValues.length - 1)) {
      globalVariables.historicalRecordStage.children[1].inputEnabled = true;
      globalVariables.historicalRecordStage.children[1].setFrames(1, 0, 1);
      globalVariables.historicalRecordStage.children[2].inputEnabled = false;
      return globalVariables.historicalRecordStage.children[2].setFrames(2, 2, 2);
    } else {
      globalVariables.historicalRecordStage.children[1].inputEnabled = true;
      globalVariables.historicalRecordStage.children[1].setFrames(1, 0, 1);
      globalVariables.historicalRecordStage.children[2].inputEnabled = true;
      return globalVariables.historicalRecordStage.children[2].setFrames(1, 0, 1);
    }
  };

  showLastRoundPlayedCards = function() {
    if (globalVariables.historicalRoundIndex === 0) {
      return;
    }
    globalVariables.historicalRoundIndex -= 1;
    toggleLastAndNextRoundButton();
    showPlayedCardsForUser(0, globalVariables.meHistoricalPlayedCardValues[globalVariables.historicalRoundIndex], false);
    showPlayedCardsForUser(1, globalVariables.player1HistoricalPlayedCardValues[globalVariables.historicalRoundIndex], false);
    showPlayedCardsForUser(2, globalVariables.player2HistoricalPlayedCardValues[globalVariables.historicalRoundIndex], false);
    return showPlayedCardsForUser(3, globalVariables.player3HistoricalPlayedCardValues[globalVariables.historicalRoundIndex], false);
  };

  showNextRoundPlayedCards = function() {
    if (globalVariables.historicalRoundIndex === globalVariables.meHistoricalPlayedCardValues.length - 1) {
      return;
    }
    globalVariables.historicalRoundIndex += 1;
    toggleLastAndNextRoundButton();
    showPlayedCardsForUser(0, globalVariables.meHistoricalPlayedCardValues[globalVariables.historicalRoundIndex], false);
    showPlayedCardsForUser(1, globalVariables.player1HistoricalPlayedCardValues[globalVariables.historicalRoundIndex], false);
    showPlayedCardsForUser(2, globalVariables.player2HistoricalPlayedCardValues[globalVariables.historicalRoundIndex], false);
    return showPlayedCardsForUser(3, globalVariables.player3HistoricalPlayedCardValues[globalVariables.historicalRoundIndex], false);
  };

  module.exports = {
    toggleCardSelection: toggleCardSelection,
    displayCards: displayCards,
    showCoveredCards: showCoveredCards,
    showPlayedCardsForUser: showPlayedCardsForUser,
    tapUp: tapUp,
    tapDownOnSprite: tapDownOnSprite,
    backgroundTapped: backgroundTapped,
    playSelectedCards: playSelectedCards,
    showPlayer1Info: showPlayer1Info,
    showPlayer2Info: showPlayer2Info,
    showPlayer3Info: showPlayer3Info,
    hideLeftPlayer: hideLeftPlayer,
    showCallScorePanel: showCallScorePanel,
    raiseScore: raiseScore,
    lowerScore: lowerScore,
    pass: pass,
    surrender: surrender,
    settleCoveredCards: settleCoveredCards,
    showSelectSuitPanel: showSelectSuitPanel,
    setScore: setScore,
    selectSuit: selectSuit,
    leaveRoom: leaveRoom,
    sendGetReadyMessage: sendGetReadyMessage,
    showBigStampForTheLargestPlayedCardsCurrentRound: showBigStampForTheLargestPlayedCardsCurrentRound,
    showEarnedScoreTextWithFadeOutEffect: showEarnedScoreTextWithFadeOutEffect,
    showHistoricallyPlayedCards: showHistoricallyPlayedCards
  };

}).call(this);

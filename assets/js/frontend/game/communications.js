// Generated by CoffeeScript 1.10.0
(function() {
  var actions, constants, getRoomInfo, globalVariables, socketEventHandler, toolbox;

  constants = require('./constants.js');

  actions = require('./actions.js');

  toolbox = require('./toolbox.js');

  globalVariables = require('./globalVariables.js');

  getRoomInfo = function(game) {
    return io.socket.get('/get_room_info', {
      userId: globalVariables.userId,
      loginToken: globalVariables.loginToken
    }, function(resData, jwres) {
      var diff, i, j, k, readyPlayers, ref, ref1, ref2, results, seatIndexOfCurrentUser, seats, usernames;
      if (jwres.statusCode === 200) {
        globalVariables.textOfRoomName.text = resData.roomName;
        usernames = resData.usernames;
        seats = [resData.seats.one, resData.seats.two, resData.seats.three, resData.seats.four];
        seatIndexOfCurrentUser = seats.indexOf(globalVariables.username);
        for (i = j = ref = seatIndexOfCurrentUser + 1, ref1 = seatIndexOfCurrentUser + 4; ref <= ref1 ? j < ref1 : j > ref1; i = ref <= ref1 ? ++j : --j) {
          if (seats[i % 4] !== '') {
            diff = i - seatIndexOfCurrentUser;
            switch (diff) {
              case 1 || -3:
                actions.showPlayer1Info(game, seats[i % 4]);
                break;
              case 2 || -2:
                actions.showPlayer2Info(game, seats[i % 4]);
                break;
              case 3 || -1:
                actions.showPlayer3Info(game, seats[i % 4]);
            }
          }
        }
        readyPlayers = resData.readyPlayers;
        results = [];
        for (i = k = 0, ref2 = readyPlayers.length; 0 <= ref2 ? k < ref2 : k > ref2; i = 0 <= ref2 ? ++k : --k) {
          if (globalVariables.player1Username) {
            if (readyPlayers[i] === globalVariables.player1Username.text) {
              globalVariables.player1StatusText.text = 'Ready';
            }
          }
          if (globalVariables.player2Username) {
            if (readyPlayers[i] === globalVariables.player2Username.text) {
              globalVariables.player2StatusText.text = 'Ready';
            }
          }
          if (globalVariables.player3Username) {
            if (readyPlayers[i] === globalVariables.player3Username.text) {
              results.push(globalVariables.player3StatusText.text = 'Ready');
            } else {
              results.push(void 0);
            }
          } else {
            results.push(void 0);
          }
        }
        return results;
      }
    });
  };

  socketEventHandler = function(game) {
    io.socket.on('newPlayerJoined', function(data) {
      var diff, newPlayerUsername, seatIndexOfCurrentUser, seatIndexOfNewPlayer, seats;
      newPlayerUsername = data.newPlayer;
      seats = [data.seats.one, data.seats.two, data.seats.three, data.seats.four];
      seatIndexOfCurrentUser = seats.indexOf(globalVariables.username);
      seatIndexOfNewPlayer = seats.indexOf(newPlayerUsername);
      diff = seatIndexOfNewPlayer - seatIndexOfCurrentUser;
      if (diff === 1 || diff === -3) {
        actions.showPlayer1Info(game, newPlayerUsername);
      }
      if (diff === 2 || diff === -2) {
        actions.showPlayer2Info(game, newPlayerUsername);
      }
      if (diff === 3 || diff === -1) {
        actions.showPlayer3Info(game, newPlayerUsername);
      }
    });
    io.socket.on('playerLeavedRoom', function(data) {
      var leftUsername;
      leftUsername = data.username;
      return actions.hideLeftPlayer(leftUsername);
    });
    io.socket.on('playerReady', function(data) {
      var readyUsername;
      readyUsername = data.username;
      if (globalVariables.player1Username) {
        if (readyUsername === globalVariables.player1Username.text) {
          globalVariables.player1StatusText.text = 'Ready';
        }
      }
      if (globalVariables.player2Username) {
        if (readyUsername === globalVariables.player2Username.text) {
          globalVariables.player2StatusText.text = 'Ready';
        }
      }
      if (globalVariables.player3Username) {
        if (readyUsername === globalVariables.player3Username.text) {
          return globalVariables.player3StatusText.text = 'Ready';
        }
      }
    });
    io.socket.on('cardsSent', function(data) {
      var usernameToCallScore;
      globalVariables.cardsAtHand.indexes = data.cards;
      globalVariables.cardsAtHand.indexes = data.cards;
      usernameToCallScore = data.usernameToCallScore;
      globalVariables.cardsAtHand.indexes = toolbox.sortCards(globalVariables.cardsAtHand.indexes);
      actions.displayCards(globalVariables.cardsAtHand.indexes);
      globalVariables.meStatusText.text = '';
      globalVariables.player1StatusText.text = '';
      globalVariables.player2StatusText.text = '';
      globalVariables.player3StatusText.text = '';
      globalVariables.textOfAimedScores.text = '80';
      globalVariables.textOfCurrentScores.text = '0';
      if (usernameToCallScore === globalVariables.username) {
        return actions.showCallScorePanel(game, 80);
      } else {
        if (usernameToCallScore === globalVariables.player1Username.text) {
          return globalVariables.player1StatusText.text = '叫分中...';
        } else if (usernameToCallScore === globalVariables.player2Username.text) {
          return globalVariables.player2StatusText.text = '叫分中...';
        } else if (usernameToCallScore === globalVariables.player3Username.text) {
          return globalVariables.player3StatusText.text = '叫分中...';
        }
      }
    });
    io.socket.on('userCalledScore', function(data) {
      var currentAimedScore, usernameCalledScore, usernameToCallScore;
      currentAimedScore = data.currentAimedScore;
      usernameCalledScore = data.usernameCalledScore;
      usernameToCallScore = data.usernameToCallScore;
      globalVariables.textOfAimedScores.text = '' + currentAimedScore;
      if (usernameToCallScore === globalVariables.username) {
        globalVariables.meStatusText.text = '叫分中...';
        actions.showCallScorePanel(game, currentAimedScore);
      } else if (usernameToCallScore === globalVariables.player1Username.text) {
        globalVariables.player1StatusText.text = '叫分中...';
      } else if (usernameToCallScore === globalVariables.player2Username.text) {
        globalVariables.player2StatusText.text = '叫分中...';
      } else if (usernameToCallScore === globalVariables.player3Username.text) {
        globalVariables.player3StatusText.text = '叫分中...';
      }
      if (usernameCalledScore === globalVariables.player1Username.text) {
        return globalVariables.player1StatusText.text = currentAimedScore + '分';
      } else if (usernameCalledScore === globalVariables.player2Username.text) {
        return globalVariables.player2StatusText.text = currentAimedScore + '分';
      } else if (usernameCalledScore === globalVariables.player3Username.text) {
        return globalVariables.player3StatusText.text = currentAimedScore + '分';
      }
    });
    io.socket.on('userPassed', function(data) {
      var currentAimedScore, passedUser, usernameToCallScore;
      passedUser = data.passedUser;
      usernameToCallScore = data.usernameToCallScore;
      currentAimedScore = data.aimedScore;
      if (passedUser === globalVariables.player1Username.text) {
        globalVariables.player1StatusText.text = '不要';
      } else if (passedUser === globalVariables.player2Username.text) {
        globalVariables.player2StatusText.text = '不要';
      } else if (passedUser === globalVariables.player3Username.text) {
        globalVariables.player3StatusText.text = '不要';
      }
      if (usernameToCallScore === globalVariables.username) {
        return actions.showCallScorePanel(game, currentAimedScore);
      }
    });
    io.socket.on('makerSettled', function(data) {
      var aimedScore, coveredCards, makerUsername;
      aimedScore = data.aimedScore;
      makerUsername = data.makerUsername;
      globalVariables.textOfAimedScores.text = aimedScore + '分';
      if (makerUsername === globalVariables.player1Username.text) {
        globalVariables.player1IsMakerIcon.visible = true;
      } else if (makerUsername === globalVariables.player2Username.text) {
        globalVariables.player2IsMakerIcon.visible = true;
      } else if (makerUsername === globalVariables.player3Username.text) {
        globalVariables.player3IsMakerIcon.visible = true;
      }
      if (makerUsername === globalVariables.username) {
        coveredCards = data.coveredCards;
        globalVariables.cardsAtHand.indexes = globalVariables.cardsAtHand.indexes.concat(coveredCards);
        globalVariables.cardsAtHand.indexes = toolbox.sortCards(globalVariables.cardsAtHand.indexes);
        actions.displayCards(globalVariables.cardsAtHand.indexes);
        globalVariables.surrenderButton.visible = true;
        globalVariables.settleCoveredCardsButton.visible = true;
        globalVariables.settleCoveredCardsButton.inputEnabled = false;
        globalVariables.settleCoveredCardsButton.setFrames(2, 2, 2);
        globalVariables.player1StatusText.text = '';
        globalVariables.player2StatusText.text = '';
        globalVariables.player3StatusText.text = '';
      } else if (makerUsername === globalVariables.player1Username.text) {
        globalVariables.meStatusText.text = '';
        globalVariables.player1StatusText.text = '庄家埋底中...';
        globalVariables.player2StatusText.text = '';
        globalVariables.player3StatusText.text = '';
      } else if (makerUsername === globalVariables.player2Username.text) {
        globalVariables.meStatusText.text = '';
        globalVariables.player1StatusText.text = '';
        globalVariables.player2StatusText.text = '庄家埋底中...';
        globalVariables.player3StatusText.text = '';
      } else if (makerUsername === globalVariables.player3Username.text) {
        globalVariables.meStatusText.text = '';
        globalVariables.player1StatusText.text = '';
        globalVariables.player2StatusText.text = '';
        globalVariables.player3StatusText.text = '庄家埋底中...';
      }
      return globalVariables.gameStatus = constants.GAME_STATUS_SETTLING_COVERED_CARDS;
    });
    io.socket.on('finishedSettlingCoveredCards', function(data) {
      var makerUsername;
      makerUsername = data.maker;
      if (makerUsername === globalVariables.player1Username.text) {
        return globalVariables.player1StatusText.text = '庄家选主中...';
      } else if (makerUsername === globalVariables.player2Username.text) {
        return globalVariables.player2StatusText.text = '庄家选主中...';
      } else if (makerUsername === globalVariables.player3Username.text) {
        return globalVariables.player3StatusText.text = '庄家选主中...';
      }
    });
    return io.socket.on('mainSuitChosen', function(data) {
      var mainSuit;
      mainSuit = data.mainSuit;
      globalVariables.mainSuit = mainSuit;
      globalVariables.iconOfMainSuit.frame = globalVariables.mainSuit;
      globalVariables.meStatusText.text = '';
      globalVariables.player1StatusText.text = '';
      globalVariables.player2StatusText.text = '';
      return globalVariables.player3StatusText.text = '';
    });
  };

  module.exports = {
    getRoomInfo: getRoomInfo,
    socketEventHandler: socketEventHandler
  };

}).call(this);

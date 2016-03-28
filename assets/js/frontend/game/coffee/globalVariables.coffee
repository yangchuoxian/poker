constants = require './constants.js'
module.exports =
    screenWidth: Math.max(document.documentElement.clientWidth, window.innerWidth || 0)
    screenHeight: Math.max(document.documentElement.clientHeight, window.innerHeight || 0)
    userId: document.getElementById('userId').innerText
    username: document.getElementById('username').innerText
    loginToken: document.getElementById('loginToken').innerText
    roomName: document.getElementById('roomName').innerText
    scaledCardWidth: null
    scaledCardHeight: null
    scaleWidthRatio: null
    scaleHeightRatio: null
    currentUserPlayedCards: null
    user1PlayedCards: null
    user2PlayedCards: null
    user3PlayedCards: null
    isShowingCoveredCards: false
    cardsAtHand: null
    coveredCards: null
    background: null
    playCardsButton: null
    historicalButton: null
    prepareButton: null
    leaveButton: null
    surrenderButton: null
    settleCoveredCardsButton: null
    startSwipeCardIndex: null
    endSwipeCardIndex: null
    iconOfMainSuit: null
    textOfCurrentScores: null
    textOfAimedScores: null
    textOfEarnedScores: null
    textOfChipsWon: null
    textOfWaterpool: null

    textOfRoomName: null

    player1Username: null
    player2Username: null
    player3Username: null
    user1Avatar: null
    user2Avatar: null
    user3Avatar: null

    meStatusText: null
    player1StatusText: null
    player2StatusText: null
    player3StatusText: null

    player1IsBankerIcon: null
    player2IsBankerIcon: null
    player3IsBankerIcon: null

    callScoreStage: null

    gameStatus: null
    selectSuitButton: null
    selectSuitStage: null
    mainSuit: null
    firstlyPlayedCardValuesForCurrentRound: []
    bigSign: null
    cardValueRanks: null
    # historical played cards values
    meHistoricalPlayedCardValues: []
    player1HistoricalPlayedCardValues: []
    player2HistoricalPlayedCardValues: []
    player3HistoricalPlayedCardValues: []
    # historical played card group of sprites for one round
    meHistoricalPlayedCardGroupForOneRound: null
    player1HistoricalPlayedCardGroupForOneRound: null
    player2HistoricalPlayedCardGroupForOneRound: null
    player3HistoricalPlayedCardGroupForOneRound: null
    historicalRecordStage: null
    historicalRoundIndex: null
    isPlayCardButtonVisibleBeforeShowingHistoricalRecordStage: false
    nonBankerPlayersHaveNoMainSuit: constants.FALSE
    gameResultsStage: null
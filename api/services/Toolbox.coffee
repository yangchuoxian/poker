Promise = require 'bluebird'

sortCards = (array) ->
    sortNumber = (a, b) ->
        return a - b
    return array.sort sortNumber

generateLoginToken = ->
    s4 = -> Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
    s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

shuffleCards = ->
    array = []
    for j in [0...2]
        for i in [1...47]
            array.push i
    copy = []
    n = array.length
    numOfIterations = n
    for i in [0...numOfIterations]
        j = Math.floor(Math.random() * n)
        copy.push array[j]
        array.splice j, 1
        n -= 1
    return copy

calculateTotalScoresForThisRound = (playedCardsInfo) ->
    totalScores = 0
    for i in [0...playedCardInfo.length]
        for j in [0...playedCardsInfo[i].playedCardValues.length]
            if playedCardsInfo[i].playedCardValues[j] in sails.config.constants.indexesOfFiveScoreCards then totalScores += 5
            else if playedCardsInfo[i].playedCardValues[j] in sails.config.constants.indexesOfTenScoreCards then totalScores += 10
    totalScores

###
Given the selected main suit index and user played cards info for one round, this function returns the username
that played the largest cards for this round
@param: playedCardInfo                                  played card info object with such format
                                                        {
                                                            username: 'someUsername',
                                                            playedCardValues: [
                                                                valueOfCard1,
                                                                valueOfCard2,
                                                                ...
                                                            ]
                                                        }
@param: mainSuit                                        the main suit index
@param: cardValueRanks                                  all card value ranks after the main suit is settled
@return: String                                         the username that played the largest cards for this round
###
getPlayerThatPlayedLargestCardsForThisRound = (playedCardsInfo, mainSuit, cardValueRanks) ->
    playedCardValues = []
    for i in [0...playedCardsInfo.length]
        playedCardValues.push playedCardsInfo[i].playedCardValues
    suitForFirstlyPlayedCards = null
    if isSingleForMainSuit mainSuit, [playedCardValues[0][0]] then suitForFirstlyPlayedCards = sails.config.constants.INDEX_SUIT_MAIN
    else if isSingleForSuit sails.config.constants.INDEX_SUIT_SPADE, [playedCardValues[0][0]] then suitForFirstlyPlayedCards = sails.config.constants.INDEX_SUIT_SPADE
    else if isSingleForSuit sails.config.constants.INDEX_SUIT_HEART, [playedCardValues[0][0]] then suitForFirstlyPlayedCards = sails.config.constants.INDEX_SUIT_HEART
    else if isSingleForSuit sails.config.constants.INDEX_SUIT_CLUB, [playedCardValues[0][0]] then suitForFirstlyPlayedCards = sails.config.constants.INDEX_SUIT_CLUB
    else if isSingleForSuit sails.config.constants.INDEX_SUIT_DIAMOND, [playedCardValues[0][0]] then suitForFirstlyPlayedCards = sails.config.constants.INDEX_SUIT_DIAMOND

    largestIndex = 0
    # 首发牌是单张
    if playedCardValues[0].length is 1
        for i in [1...playedCardValues.length]
            if cardValueRanks[playedCardValues[i][0]] < cardValueRanks[playedCardValues[largestIndex][0]] then largestIndex = i
    # 首发牌是对子
    else if playedCardValues[0].length is 2
        for i in [1...playedCardValues.length]
            # 跟牌也是对子
            if playedCardValues[i][0] is playedCardValues[i][1]
                if cardValueRanks[playedCardValues[i][0]] < cardValueRanks[playedCardValues[largestIndex][0]] then largestIndex = i
    # 首发牌是拖拉机
    else
        for i in [1...playedCardValues.length]
            # 跟牌也是拖拉机
            if isTractorForSuit(playedCardValues[i].length / 2, suitForFirstlyPlayedCards, playedCardValues[i], cardValueRanks) or
            isTractorForMainSuit(playedCardValues[i].length / 2, mainSuit, playedCardValues[i], cardValueRanks)
                if cardValueRanks[playedCardValues[i][0]] < cardValueRanks[playedCardValues[largestIndex][0]] then largestIndex = i
    return playedCardsInfo[largestIndex].username


getStartAndEndValueForSuit = (suitIndex) ->
    startCardValueForSuit = 0
    endCardValueForSuit = 0
    switch suitIndex
        when sails.config.constants.INDEX_SUIT_MAIN
            startCardValueForSuit = sails.config.constants.START_VALUE_FOR_MAIN
            endCardValueForSuit = sails.config.constants.END_VALUE_FOR_MAIN
        when sails.config.constants.INDEX_SUIT_SPADE
            startCardValueForSuit = sails.config.constants.START_VALUE_FOR_SPADE
            endCardValueForSuit = sails.config.constants.END_VALUE_FOR_SPADE
        when sails.config.constants.INDEX_SUIT_HEART
            startCardValueForSuit = sails.config.constants.START_VALUE_FOR_HEART
            endCardValueForSuit = sails.config.constants.END_VALUE_FOR_HEART
        when sails.config.constants.INDEX_SUIT_CLUB
            startCardValueForSuit = sails.config.constants.START_VALUE_FOR_CLUB
            endCardValueForSuit = sails.config.constants.END_VALUE_FOR_CLUB
        when sails.config.constants.INDEX_SUIT_DIAMOND
            startCardValueForSuit = sails.config.constants.START_VALUE_FOR_DIAMOND
            endCardValueForSuit = sails.config.constants.END_VALUE_FOR_DIAMOND
    return [startCardValueForSuit, endCardValueForSuit]

getAllValuesOfMainAndMainSuit = (mainSuit) ->
    startAndEndValuesForMain = getStartAndEndValueForSuit constants.INDEX_SUIT_MAIN
    startAndEndValuesForMainSuit = getStartAndEndValueForSuit mainSuit
    valuesOfMainAndMainSuit = []
    for i in [startAndEndValuesForMain[0]...startAndEndValuesForMain[1] + 1]
        valuesOfMainAndMainSuit.push i
    for i in [startAndEndValuesForMainSuit[0]...startAndEndValuesForMainSuit[1] + 1]
        valuesOfMainAndMainSuit.push i
    return valuesOfMainAndMainSuit

isSingleForSuit = (suitIndex, cardValues) ->
    startAndEndValuesForSuit = getStartAndEndValueForSuit suitIndex
    if cardValues.length is 1 and
    cardValues[0] >= startAndEndValuesForSuit[0] and
    cardValues[0] <= startAndEndValuesForSuit[1] then return true
    else return false

isSingleForMainSuit = (mainSuit, cardValues) ->
    valuesOfMainAndMainSuit = getAllValuesOfMainAndMainSuit mainSuit
    if cardValues.length is 1 and
    cardValues[0] in valuesOfMainAndMainSuit then return true
    else return false

isPairForSuit = (suitIndex, cardValues) ->
    startAndEndValuesForSuit = getStartAndEndValueForSuit suitIndex
    if cardValues.length is 2 and
    cardValues[0] is cardValues[1] and
    cardValues[0] >= startAndEndValuesForSuit[0] and
    cardValues[1] <= startAndEndValuesForSuit[1] then return true
    else return false

isPairForMainSuit = (mainSuit, cardValues) ->
    valuesOfMainAndMainSuit = getAllValuesOfMainAndMainSuit mainSuit
    if cardValues.length is 2 and
    cardValues[0] is cardValues[1] and
    cardValues[i] in valuesOfMainAndMainSuit then return true
    else return false

isTractorForSuit = (tractorLength, suitIndex, cardValues, cardValueRanks) ->
    if tractorLength is 0 or cardValues.length < 4 then return false
    if cardValues.length < tractorLength * 2 or
    cardValues.length % 2 isnt 0 then return false
    startAndEndValuesForSuit = getStartAndEndValueForSuit suitIndex
    if cardValues[0] < startAndEndValuesForSuit[0] or cardValues[cardValues.length - 1] > startAndEndValuesForSuit[1] then return false
    i = 0
    pairRanks = []
    while i <= (cardValues.length - 2)
        if cardValues[i] isnt cardValues[i + 1] then return false
        else pairRanks.push cardValueRanks[cardValues[i]]
        i += 2
    pairRanks = sortCards pairRanks
    for i in [0...pairRanks.length - 1]
        if (pairRanks[i] + 1) isnt pairRanks[i + 1] then return false
    return true

isTractorForMainSuit = (tractorLength, mainSuit, cardValues, cardValueRanks) ->
    if tractorLength is 0 or cardValues.length < 4 then return false
    if cardValues.length < tractorLength * 2 or
    cardValues.length % 2 isnt 0 then return false
    mainSuitValues = getRelativeMainSuitValues mainSuit
    valuesOfMainAndMainSuit = getAllValuesOfMainAndMainSuit mainSuit
    # if the selected cards contains any card that is NEITHER main NOR main suit, then should return false
    for i in [0...cardValues.length]
        if cardValues[i] not in valuesOfMainAndMainSuit then return false
    i = 0
    pairRanks = []
    while i <= (cardValues.length - 2)
        # starting with even index, if the consecutive two cards is NOT the same, quit with false
        if cardValues[i] isnt cardValues[i + 1] then return false
        else pairRanks.push cardValueRanks[cardValues[i]]
        i += 2
    pairRanks = sortCards pairRanks
    for i in [0...pairRanks.length - 1]
        if (pairRanks[i] + 1) isnt pairRanks[i + 1] then return false
    return true

###
With the given main suit index, rank all card values and return a map that contains the ranking information
@param: mainSuit            the main suit index
@return: ranks              the map data structure with format like this:
                            {
                                valueOfCard1: rank1,
                                valueOfCard2: rank2,
                                ...
                            }
###
getRanksForMainSuitCards = (mainSuit) ->
    ranks = {}
    ranks[sails.config.constants.VALUE_BIG_JOKER] = 1                # big joker
    ranks[sails.config.constants.VALUE_SMALL_JOKER] = 2              # small joker
    for i in [sails.config.constants.VALUE_SPADE_SEVEN...sails.config.constants.VALUE_DIAMOND_SEVEN + 1]
        ranks[i] = 4
    for i in [sails.config.constants.VALUE_SPADE_TWO...sails.config.constants.VALUE_DIAMOND_TWO + 1]
        ranks[i] = 6

    nonMainSuitCardStartingRank = 16
    # spade cards ranks
    for i in [sails.config.constants.VALUE_SPADE_ACE...sails.config.constants.VALUE_SPADE_FIVE + 1]
        ranks[i] = nonMainSuitCardStartingRank + i - sails.config.constants.VALUE_SPADE_ACE
    # heart cards ranks
    for i in [sails.config.constants.VALUE_HEART_ACE...sails.config.constants.VALUE_HEART_FIVE + 1]
        ranks[i] = nonMainSuitCardStartingRank + i - sails.config.constants.VALUE_HEART_ACE
    # club cards ranks
    for i in [sails.config.constants.VALUE_CLUB_ACE...sails.config.constants.VALUE_CLUB_FIVE + 1]
        ranks[i] = nonMainSuitCardStartingRank + i - sails.config.constants.VALUE_CLUB_ACE
    # diamond cards ranks
    for i in [sails.config.constants.VALUE_DIAMOND_ACE...sails.config.constants.VALUE_DIAMOND_FIVE + 1]
        ranks[i] = nonMainSuitCardStartingRank + i - sails.config.constants.VALUE_DIAMOND_ACE

    startingRank = 7
    if mainSuit is sails.config.constants.INDEX_SUIT_SPADE
        ranks[sails.config.constants.VALUE_SPADE_SEVEN] = 3          # main seven
        ranks[sails.config.constants.VALUE_SPADE_TWO] = 5            # main two
        # spade ace to spade five
        for i in [sails.config.constants.VALUE_SPADE_ACE...sails.config.constants.VALUE_SPADE_FIVE + 1]
            ranks[i] = startingRank + i - sails.config.constants.VALUE_SPADE_ACE
    else if mainSuit is sails.config.constants.INDEX_SUIT_HEART
        ranks[sails.config.constants.VALUE_HEART_SEVEN] = 3          # main seven
        ranks[sails.config.constants.VALUE_HEART_TWO] = 5            # main two
        # heart ace to heart five
        for i in [sails.config.constants.VALUE_HEART_ACE...sails.config.constants.VALUE_HEART_FIVE + 1]
            ranks[i] = startingRank + i - sails.config.constants.VALUE_HEART_ACE
    else if mainSuit is sails.config.constants.INDEX_SUIT_CLUB
        ranks[sails.config.constants.VALUE_CLUB_SEVEN] = 3           # main seven
        ranks[sails.config.constants.VALUE_CLUB_TWO] = 5             # main two
        # club ace to club five
        for i in [sails.config.constants.VALUE_CLUB_ACE...sails.config.constants.VALUE_CLUB_FIVE + 1]
            ranks[i] = startingRank + i - sails.config.constants.VALUE_CLUB_ACE
    else if mainSuit is sails.config.constants.INDEX_SUIT_DIAMOND
        ranks[sails.config.constants.VALUE_DIAMOND_SEVEN] = 3        # main seven
        ranks[sails.config.constants.VALUE_DIAMOND_TWO] = 5          # main two
        # diamond ace to diamond five
        for i in [sails.config.constants.VALUE_DIAMOND_ACE...sails.config.constants.VALUE_DIAMOND_FIVE + 1]
            ranks[i] = startingRank + i - sails.config.constants.VALUE_DIAMOND_ACE
    return ranks

module.exports =
    isSingleForSuit: isSingleForSuit
    isSingleForMainSuit: isSingleForMainSuit
    isPairForSuit: isPairForSuit
    isPairForMainSuit: isPairForMainSuit
    isTractorForSuit: isTractorForSuit
    isTractorForMainSuit: isTractorForMainSuit
    generateLoginToken: generateLoginToken
    shuffleCards: shuffleCards
    getPlayerThatPlayedLargestCardsForThisRound: getPlayerThatPlayedLargestCardsForThisRound
    calculateTotalScoresForThisRound: calculateTotalScoresForThisRound
    getRanksForMainSuitCards: getRanksForMainSuitCards

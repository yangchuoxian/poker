Promise = require 'bluebird'

binarySearch = (array, x) ->
    n = array.length
    begin = 0
    end = n - 1
    result = -1
    while begin <= end
        mid = Math.floor((begin + end) / 2)
        if array[mid] <= x
            begin = mid + 1
            result = mid
        else end = mid - 1
    return result

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
    for i in [0...playedCardsInfo.length]
        for j in [0...playedCardsInfo[i].playedCardValues.length]
            if playedCardsInfo[i].playedCardValues[j] in sails.config.constants.indexesOfFiveScoreCards then totalScores += 5
            else if playedCardsInfo[i].playedCardValues[j] in sails.config.constants.indexesOfTenScoreCards then totalScores += 10
    totalScores

###
Given the selected main suit index and user played cards info for one round, this function returns the username
that played the largest cards for this round
@param: playedCardsInfo                                 played card info object with such format
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
    startAndEndValuesForMain = getStartAndEndValueForSuit sails.config.constants.INDEX_SUIT_MAIN
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
    cardValues[0] in valuesOfMainAndMainSuit then return true
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
Given a suit index and card values at hand, this function finds out all pairs within card values at hand that are the given suit
@param: suitIndex                       the given suit index
@param: cardValues                      the card values in which to search pairs for
@return: array                          all the values of pairs that satisfies the condition
###
getPairValuesForSuit = (suitIndex, cardValues) ->
    cardValuesOfSuit = getCardValuesForSuit suitIndex, cardValues
    pairValues = []
    if cardValuesOfSuit.length is 0 then return pairValues
    for i in [0...cardValuesOfSuit.length - 1]
        if cardValuesOfSuit[i] is cardValuesOfSuit[i + 1] then pairValues.push cardValuesOfSuit[i]
    return pairValues

###
Given a array of cards, find out all the card values that belongs to the designated suit
@param: suitIndex                       the suit index
@param: cardValues                      the card values in which to look for
@return: cardValuesForSuit              the card values that belongs to the given suit in the given card values
###
getCardValuesForSuit = (suitIndex, cardValues) ->
    startAndEndValuesForSuit = getStartAndEndValueForSuit suitIndex
    cardValuesForSuit = []
    for i in [0...cardValues.length]
        if cardValues[i] >= startAndEndValuesForSuit[0] and cardValues[i] <= startAndEndValuesForSuit[1] then cardValuesForSuit.push cardValues[i]
    return cardValuesForSuit

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

###
Check whether the card values contain at least 1 card of specific suit
@param: suitIndex                           designated suit index
@param: cardvaluesAtHand                    the given card values in which to search for
@return: boolean                            true if at least one card of the suit in the array of card values, false otherwise
###
haveSingleForSuit = (suitIndex, cardValues) ->
    cardValuesAtHandOfSuit = getCardValuesForSuit suitIndex, cardValues
    if cardValuesAtHandOfSuit.length > 0 then return true
    else return false

haveSingleForMainSuit = (mainSuit, cardValues) ->
    cardValuesAtHandForMain = getCardValuesForSuit sails.config.constants.INDEX_SUIT_MAIN, cardValues
    cardValuesAtHandForMainSuit = getCardValuesForSuit mainSuit, cardValues
    if cardValuesAtHandForMain.length > 0 or
    cardValuesAtHandForMainSuit.length > 0 then return true
    else return false

havePairForSuit = (suitIndex, cardValues) ->
    cardValuesOfSuit = getCardValuesForSuit suitIndex, cardValues
    if cardValuesOfSuit.length is 0 then return false
    for i in [0...cardValuesOfSuit.length - 1]
        if cardValuesOfSuit[i] is cardValuesOfSuit[i + 1] then return true
    return false

havePairForMainSuit = (mainSuit, cardValues) ->
    cardValuesForMain = getCardValuesForSuit sails.config.constants.INDEX_SUIT_MAIN, cardValues
    cardValuesForMainSuit = getCardValuesForSuit mainSuit, cardValues
    mains = cardValuesForMain.concat cardValuesForMainSuit
    if mains.length is 0 then return false
    for i in [0...mains.length - 1]
        if mains[i] is mains[i + 1] then return true
    return false

haveTractorForSuit = (tractorLength, suitIndex, cardValues) ->
    pairValuesOfSuit = getPairValuesForSuit suitIndex, cardValues
    # no pair, thus no tractor
    if pairValuesOfSuit.length is 0 then return false
    # the number of pairs is less than the tractor length
    if pairValuesOfSuit.length < tractorLength then return false
    numOfConsecutivePairs = 1
    for i in [0...pairValuesOfSuit.length]
        if (pairValuesOfSuit[i] + 1) is pairValuesOfSuit[i + 1]
            numOfConsecutivePairs += 1
            if numOfConsecutivePairs is tractorLength then return true
        else numOfConsecutivePairs = 0
    return false

haveTractorForMainSuit = (tractorLength, mainSuit, cardValues, cardValueRanks) ->
    pairValuesOfMain = getPairValuesForSuit sails.config.constants.INDEX_SUIT_MAIN, cardValues
    pairValuesOfSuit = getPairValuesForSuit mainSuit, cardValues
    pairs = pairValuesOfMain.concat pairValuesOfSuit
    # no pair for the given card values, thus no tractor for main suit
    if pairs.length is 0 then return false
    # the number of pairs is less than the tractor length
    if pairs.length < tractorLength then return false
    numOfConsecutivePairs = 1
    pairRanks = []
    for i in [0...pairs.length]
        pairRanks.push cardValueRanks[pairs[i]]
    pairRanks = sortCards pairRanks
    for i in [0...pairRanks.length - 1]
        if (pairRanks[i] + 1) is pairRanks[i + 1]
            numOfConsecutivePairs += 1
            if numOfConsecutivePairs is tractorLength then return true
        else numOfConsecutivePairs = 0
    return false

validatePlayedCards = (selectedCardValues, firstlyPlayedCardValues, cardValuesAtHand, mainSuit, cardValueRanks) ->
    if selectedCardValues.length is 0 then return false
    # 别人已经出牌，本次出牌为跟牌
    if firstlyPlayedCardValues.length > 0
        # 先确定第一轮出的牌的花色
        suitForFirstlyPlayedCards = null
        if isSingleForMainSuit mainSuit, [firstlyPlayedCardValues[0]] then suitForFirstlyPlayedCards = sails.config.constants.INDEX_SUIT_MAIN
        else if isSingleForSuit sails.config.constants.INDEX_SUIT_SPADE, [firstlyPlayedCardValues[0]] then suitForFirstlyPlayedCards = sails.config.constants.INDEX_SUIT_SPADE
        else if isSingleForSuit sails.config.constants.INDEX_SUIT_HEART, [firstlyPlayedCardValues[0]] then suitForFirstlyPlayedCards = sails.config.constants.INDEX_SUIT_HEART
        else if isSingleForSuit sails.config.constants.INDEX_SUIT_CLUB, [firstlyPlayedCardValues[0]] then suitForFirstlyPlayedCards = sails.config.constants.INDEX_SUIT_CLUB
        else if isSingleForSuit sails.config.constants.INDEX_SUIT_DIAMOND, [firstlyPlayedCardValues[0]] then suitForFirstlyPlayedCards = sails.config.constants.INDEX_SUIT_DIAMOND
        # 选中要出的牌和先出的牌数量不一样，非法
        if selectedCardValues.length isnt firstlyPlayedCardValues.length then return false

        if suitForFirstlyPlayedCards is sails.config.constants.INDEX_SUIT_MAIN
            numberOfMainCardsInSelectedCards = getCardValuesForSuit(sails.config.constants.INDEX_SUIT_MAIN, selectedCardValues).length + getCardValuesForSuit(mainSuit, selectedCardValues).length
            numberOfMainCardsAtHand = getCardValuesForSuit(sails.config.constants.INDEX_SUIT_MAIN, cardValuesAtHand).length + getCardValuesForSuit(mainSuit, cardValuesAtHand).length
            # 首发牌是调主，而：
            # a. 选定的牌中的主牌数量小于首发牌调主牌的数量，并且
            # b. 选定的牌中的主牌数量并不是手中持有的牌的主牌数量的全部
            # 那么，非法
            if numberOfMainCardsInSelectedCards < firstlyPlayedCardValues.length and
            numberOfMainCardsInSelectedCards isnt numberOfMainCardsAtHand then return false
        else
            numberOfCardsInSelectedCardsForSpecificSuit = getCardValuesForSuit(suitForFirstlyPlayedCards, selectedCardValues).length
            numberOfCardsAtHandForSpecificSuit = getCardValuesForSuit(suitForFirstlyPlayedCards, cardValuesAtHand).length
            # 首发牌是某花色的副牌，而：
            # a. 选定的牌中的该花色牌数量小于首发牌中该花色牌的数量，并且
            # b. 选定的牌中的该花色牌数量并不是手中持有的牌的该花色牌的全部
            # 那么，非法
            if (numberOfCardsInSelectedCardsForSpecificSuit < firstlyPlayedCardValues.length) and
            (numberOfCardsInSelectedCardsForSpecificSuit isnt numberOfCardsAtHandForSpecificSuit) then return false
        # 单牌调主，有主牌单牌但是不出，非法
        if isSingleForMainSuit mainSuit, firstlyPlayedCardValues
            if haveSingleForMainSuit(mainSuit, cardValuesAtHand) and
            not isSingleForMainSuit(mainSuit, selectedCardValues) then return false
        # 某花色单牌，有该花色单牌但是不出，非法
        else if isSingleForSuit suitForFirstlyPlayedCards, firstlyPlayedCardValues
            if haveSingleForSuit(suitForFirstlyPlayedCards, cardValuesAtHand) and
            not isSingleForSuit(suitForFirstlyPlayedCards, selectedCardValues) then return false
        # 对子调主，有主牌对子但是不出，非法
        else if isPairForMainSuit mainSuit, firstlyPlayedCardValues
            if havePairForMainSuit mainSuit, cardValuesAtHand
                if not isPairForMainSuit mainSuit, selectedCardValues then return false
        # 某花色对子，有该花色对子但是不出，非法
        else if isPairForSuit suitForFirstlyPlayedCards, firstlyPlayedCardValues
            if havePairForSuit suitForFirstlyPlayedCards, cardValuesAtHand
                if not isPairForSuit suitForFirstlyPlayedCards, selectedCardValues then return false

        # 主牌n对拖拉机调主，有主牌拖拉机但是不出，非法
        else if isTractorForMainSuit firstlyPlayedCardValues.length / 2, mainSuit, firstlyPlayedCardValues, cardValueRanks
            if haveTractorForMainSuit firstlyPlayedCardValues.length / 2, mainSuit, cardValuesAtHand, cardValueRanks
                if not isTractorForMainSuit selectedCardValues.length / 2, mainSuit, selectedCardValues, cardValueRanks then return false
            pairValuesAtHandOfSuit = getPairValuesForSuit sails.config.constants.INDEX_SUIT_MAIN, cardValuesAtHand
            pairValuesAtHandOfSuit = pairValuesAtHandOfSuit.concat getPairValuesForSuit mainSuit, cardValuesAtHand
            selectedPairValuesOfSuit = getPairValuesForSuit sails.config.constants.INDEX_SUIT_MAIN, selectedCardValues
            selectedPairValuesOfSuit = selectedPairValuesOfSuit.concat getPairValuesForSuit mainSuit, selectedCardValues
            # 手上有n对主牌但是选定的牌少于n对，非法
            if selectedPairValuesOfSuit.length < firstlyPlayedCardValues.length / 2
                if (selectedPairValuesOfSuit.length isnt pairValuesAtHandOfSuit.length) and
                (pairValuesAtHandOfSuit.length isnt 0) then return false
        # 某花色拖拉机先出，有该花色拖拉机但是不出，非法
        else if isTractorForSuit firstlyPlayedCardValues.length / 2, suitForFirstlyPlayedCards, firstlyPlayedCardValues, cardValueRanks
            if haveTractorForSuit firstlyPlayedCardValues.length / 2, suitForFirstlyPlayedCards, cardValuesAtHand
                if not isTractorForSuit selectedCardValues.length / 2, suitForFirstlyPlayedCards, selectedCardValues, cardValueRanks then return false
            # 手上有n对该花色的牌，但是选定的牌少于n对该花色的牌，非法
            pairValuesAtHandOfSuit = getPairValuesForSuit suitForFirstlyPlayedCards, cardValuesAtHand
            selectedPairValuesOfSuit = getPairValuesForSuit suitForFirstlyPlayedCards, selectedCardValues
            if selectedPairValuesOfSuit.length < firstlyPlayedCardValues.length / 2
                if selectedPairValuesOfSuit.length isnt pairValuesAtHandOfSuit.length and
                pairValuesAtHandOfSuit.length isnt 0 then return false
    # 第一个出牌
    else
        # 选中的牌数量为大于1的单数，非法
        if (selectedCardValues.length > 1) and
        (selectedCardValues.length % 2 isnt 0) then return false
        # 选中的牌为2张，但是不是对子，非法
        if (selectedCardValues.length is 2) and
        (selectedCardValues[0] isnt selectedCardValues[1]) then return false
        # 选中的牌数量大于等于4张，但是不是任何花色的拖拉机，非法
        if selectedCardValues.length >= 4
            if isTractorForSuit selectedCardValues.length / 2, sails.config.constants.INDEX_SUIT_SPADE, selectedCardValues, cardValueRanks then return true
            else if isTractorForSuit selectedCardValues.length / 2, sails.config.constants.INDEX_SUIT_HEART, selectedCardValues, cardValueRanks then return true
            else if isTractorForSuit selectedCardValues.length / 2, sails.config.constants.INDEX_SUIT_CLUB, selectedCardValues, cardValueRanks then return true
            else if isTractorForSuit selectedCardValues.length / 2, sails.config.constants.INDEX_SUIT_DIAMOND, selectedCardValues, cardValueRanks then return true
            else if isTractorForMainSuit selectedCardValues.length / 2, mainSuit, selectedCardValues, cardValueRanks then return true
            else return false
    return true

module.exports =
    sortCards: sortCards
    binarySearch: binarySearch
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
    validatePlayedCards: validatePlayedCards

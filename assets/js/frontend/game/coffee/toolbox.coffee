constants = require './constants.js'
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

sortCardsAfterMainSuitSettled = (array, mainSuit) ->
    array = sortCards array
    cardValuesForMainSuit = getCardValuesForSuit mainSuit, array
    cardValuesForMain = getCardValuesForSuit constants.INDEX_SUIT_MAIN, array

    if cardValuesForMain.length isnt 0
        indexesForMainSevens = []
        indexesForMainTwos = []
        mainSeven = null
        mainTwo = null
        switch mainSuit
            when constants.INDEX_SUIT_SPADE
                mainSeven = constants.VALUE_SPADE_SEVEN
                mainTwo = constants.VALUE_SPADE_TWO
            when constants.INDEX_SUIT_HEART
                mainSeven = constants.VALUE_HEART_SEVEN
                mainTwo = constants.VALUE_HEART_TWO
            when constants.INDEX_SUIT_CLUB
                mainSeven = constants.VALUE_CLUB_SEVEN
                mainTwo = constants.VALUE_CLUB_TWO
            when constants.INDEX_SUIT_DIAMOND
                mainSeven = constants.VALUE_DIAMOND_SEVEN
                mainTwo = constants.VALUE_DIAMOND_TWO
        for i in [0...cardValuesForMain.length]
            if cardValuesForMain[i] is mainSeven then indexesForMainSevens.push i
        if indexesForMainSevens.length is 1
            cardValuesForMain.splice indexesForMainSevens[0], 1
            indexForSmallJoker = binarySearch cardValuesForMain, constants.VALUE_SMALL_JOKER
            cardValuesForMain.splice indexForSmallJoker + 1, 0, mainSeven
        else if indexesForMainSevens.length is 2
            cardValuesForMain.splice indexesForMainSevens[0], 2
            indexForSmallJoker = binarySearch cardValuesForMain, constants.VALUE_SMALL_JOKER
            cardValuesForMain.splice indexForSmallJoker + 1, 0, mainSeven
            cardValuesForMain.splice indexForSmallJoker + 1, 0, mainSeven
        for i in [0...cardValuesForMain.length]
            if cardValuesForMain[i] is mainTwo then indexesForMainTwos.push i
        if indexesForMainTwos.length is 1
            cardValuesForMain.splice indexesForMainTwos[0], 1
            indexForDiamondSeven = binarySearch cardValuesForMain, constants.VALUE_DIAMOND_SEVEN
            cardValuesForMain.splice indexForDiamondSeven + 1, 0, mainTwo
        else if indexesForMainTwos.length is 2
            cardValuesForMain.splice indexesForMainTwos[0], 2
            indexForDiamondSeven = binarySearch cardValuesForMain, constants.VALUE_DIAMOND_SEVEN
            cardValuesForMain.splice indexForDiamondSeven + 1, 0, mainTwo
            cardValuesForMain.splice indexForDiamondSeven + 1, 0, mainTwo
        for i in [0...cardValuesForMain.length]
            index = array.indexOf cardValuesForMain[i]
            array.splice index, 1
        array = cardValuesForMain.concat array

    if cardValuesForMainSuit.length isnt 0
        for i in [0...cardValuesForMainSuit.length]
            index = array.indexOf cardValuesForMainSuit[i]
            array.splice index, 1
        for i in [0...cardValuesForMainSuit.length]
            array.splice cardValuesForMain.length + i, 0, cardValuesForMainSuit[i]
    return array

###
With the given card value, this function finds out its corresponding card name
@param n:                           the card value
@return string:                     the corresponding card value
###
getCardName = (n) ->
    cardName = ''
    switch n
        when constants.VALUE_BIG_JOKER then cardName = 'bigJoker'
        when constants.VALUE_SMALL_JOKER then cardName = 'smallJoker'
        when constants.VALUE_SPADE_SEVEN then cardName = 'sevenOfSpades'
        when constants.VALUE_HEART_SEVEN then cardName = 'sevenOfHearts'
        when constants.VALUE_CLUB_SEVEN then cardName = 'sevenOfClubs'
        when constants.VALUE_DIAMOND_SEVEN then cardName = 'sevenOfDiamonds'
        when constants.VALUE_SPADE_TWO then cardName = 'twoOfSpades'
        when constants.VALUE_HEART_TWO then cardName = 'twoOfHearts'
        when constants.VALUE_CLUB_TWO then cardName = 'twoOfClubs'
        when constants.VALUE_DIAMOND_TWO then cardName = 'twoOfDiamonds'
        when constants.VALUE_SPADE_ACE then cardName = 'aceOfSpades'
        when constants.VALUE_SPADE_KING then cardName = 'kingOfSpades'
        when constants.VALUE_SPADE_QUEEN then cardName = 'queenOfSpades'
        when constants.VALUE_SPADE_JACK then cardName = 'jackOfSpades'
        when constants.VALUE_SPADE_TEN then cardName = 'tenOfSpades'
        when constants.VALUE_SPADE_NINE then cardName = 'nineOfSpades'
        when constants.VALUE_SPADE_EIGHT then cardName = 'eightOfSpades'
        when constants.VALUE_SPADE_SIX then cardName = 'sixOfSpades'
        when constants.VALUE_SPADE_FIVE then cardName = 'fiveOfSpades'
        when constants.VALUE_HEART_ACE then cardName = 'aceOfHearts'
        when constants.VALUE_HEART_KING then cardName = 'kingOfHearts'
        when constants.VALUE_HEART_QUEEN then cardName = 'queenOfHearts'
        when constants.VALUE_HEART_JACK then cardName = 'jackOfHearts'
        when constants.VALUE_HEART_TEN then cardName = 'tenOfHearts'
        when constants.VALUE_HEART_NINE then cardName = 'nineOfHearts'
        when constants.VALUE_HEART_EIGHT then cardName = 'eightOfHearts'
        when constants.VALUE_HEART_SIX then cardName = 'sixOfHearts'
        when constants.VALUE_HEART_FIVE then cardName = 'fiveOfHearts'
        when constants.VALUE_CLUB_ACE then cardName = 'aceOfClubs'
        when constants.VALUE_CLUB_KING then cardName = 'kingOfClubs'
        when constants.VALUE_CLUB_QUEEN then cardName = 'queenOfClubs'
        when constants.VALUE_CLUB_JACK then cardName = 'jackOfClubs'
        when constants.VALUE_CLUB_TEN then cardName = 'tenOfClubs'
        when constants.VALUE_CLUB_NINE then cardName = 'nineOfClubs'
        when constants.VALUE_CLUB_EIGHT then cardName = 'eightOfClubs'
        when constants.VALUE_CLUB_SIX then cardName = 'sixOfClubs'
        when constants.VALUE_CLUB_FIVE then cardName = 'fiveOfClubs'
        when constants.VALUE_DIAMOND_ACE then cardName = 'aceOfDiamonds'
        when constants.VALUE_DIAMOND_KING then cardName = 'kingOfDiamonds'
        when constants.VALUE_DIAMOND_QUEEN then cardName = 'queenOfDiamonds'
        when constants.VALUE_DIAMOND_JACK then cardName = 'jackOfDiamonds'
        when constants.VALUE_DIAMOND_TEN then cardName = 'tenOfDiamonds'
        when constants.VALUE_DIAMOND_NINE then cardName = 'nineOfDiamonds'
        when constants.VALUE_DIAMOND_EIGHT then cardName = 'eightOfDiamonds'
        when constants.VALUE_DIAMOND_SIX then cardName = 'sixOfDiamonds'
        when constants.VALUE_DIAMOND_FIVE then cardName = 'fiveOfDiamonds'
    cardName

###
Given a suit index, find out the starting card value and ending card value that belongs to that suit
@param: suitIndex               the suit index
@return: array                  an array that contains the starting card value and ending card value that belongs to that suit
###
getStartAndEndValueForSuit = (suitIndex) ->
    startCardValueForSuit = 0
    endCardValueForSuit = 0
    switch suitIndex
        when constants.INDEX_SUIT_MAIN
            startCardValueForSuit = constants.START_VALUE_FOR_MAIN
            endCardValueForSuit = constants.END_VALUE_FOR_MAIN
        when constants.INDEX_SUIT_SPADE
            startCardValueForSuit = constants.START_VALUE_FOR_SPADE
            endCardValueForSuit = constants.END_VALUE_FOR_SPADE
        when constants.INDEX_SUIT_HEART
            startCardValueForSuit = constants.START_VALUE_FOR_HEART
            endCardValueForSuit = constants.END_VALUE_FOR_HEART
        when constants.INDEX_SUIT_CLUB
            startCardValueForSuit = constants.START_VALUE_FOR_CLUB
            endCardValueForSuit = constants.END_VALUE_FOR_CLUB
        when constants.INDEX_SUIT_DIAMOND
            startCardValueForSuit = constants.START_VALUE_FOR_DIAMOND
            endCardValueForSuit = constants.END_VALUE_FOR_DIAMOND
    return [startCardValueForSuit, endCardValueForSuit]

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
    ranks[constants.VALUE_BIG_JOKER] = 1                # big joker
    ranks[constants.VALUE_SMALL_JOKER] = 2              # small joker
    for i in [constants.VALUE_SPADE_SEVEN...constants.VALUE_DIAMOND_SEVEN + 1]
        ranks[i] = 4
    for i in [constants.VALUE_SPADE_TWO...constants.VALUE_DIAMOND_TWO + 1]
        ranks[i] = 6

    nonMainSuitCardStartingRank = 16
    # spade cards ranks
    for i in [constants.VALUE_SPADE_ACE...constants.VALUE_SPADE_FIVE + 1]
        ranks[i] = nonMainSuitCardStartingRank + i - constants.VALUE_SPADE_ACE
    # heart cards ranks
    for i in [constants.VALUE_HEART_ACE...constants.VALUE_HEART_FIVE + 1]
        ranks[i] = nonMainSuitCardStartingRank + i - constants.VALUE_HEART_ACE
    # club cards ranks
    for i in [constants.VALUE_CLUB_ACE...constants.VALUE_CLUB_FIVE + 1]
        ranks[i] = nonMainSuitCardStartingRank + i - constants.VALUE_CLUB_ACE
    # diamond cards ranks
    for i in [constants.VALUE_DIAMOND_ACE...constants.VALUE_DIAMOND_FIVE + 1]
        ranks[i] = nonMainSuitCardStartingRank + i - constants.VALUE_DIAMOND_ACE

    startingRank = 7
    if mainSuit is constants.INDEX_SUIT_SPADE
        ranks[constants.VALUE_SPADE_SEVEN] = 3          # main seven
        ranks[constants.VALUE_SPADE_TWO] = 5            # main two
        # spade ace to spade five
        for i in [constants.VALUE_SPADE_ACE...constants.VALUE_SPADE_FIVE + 1]
            ranks[i] = startingRank + i - constants.VALUE_SPADE_ACE
    else if mainSuit is constants.INDEX_SUIT_HEART
        ranks[constants.VALUE_HEART_SEVEN] = 3          # main seven
        ranks[constants.VALUE_HEART_TWO] = 5            # main two
        # heart ace to heart five
        for i in [constants.VALUE_HEART_ACE...constants.VALUE_HEART_FIVE + 1]
            ranks[i] = startingRank + i - constants.VALUE_HEART_ACE
    else if mainSuit is constants.INDEX_SUIT_CLUB
        ranks[constants.VALUE_CLUB_SEVEN] = 3           # main seven
        ranks[constants.VALUE_CLUB_TWO] = 5             # main two
        # club ace to club five
        for i in [constants.VALUE_CLUB_ACE...constants.VALUE_CLUB_FIVE + 1]
            ranks[i] = startingRank + i - constants.VALUE_CLUB_ACE
    else if mainSuit is constants.INDEX_SUIT_DIAMOND
        ranks[constants.VALUE_DIAMOND_SEVEN] = 3        # main seven
        ranks[constants.VALUE_DIAMOND_TWO] = 5          # main two
        # diamond ace to diamond five
        for i in [constants.VALUE_DIAMOND_ACE...constants.VALUE_DIAMOND_FIVE + 1]
            ranks[i] = startingRank + i - constants.VALUE_DIAMOND_ACE
    return ranks

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
Given the main suit index, this function finds out all card values that is either main card or main suit card
@param: mainSuit                        the main suit index
@return array                           all card values that is either main card or main suit card
###
getAllValuesOfMainAndMainSuit = (mainSuit) ->
    startAndEndValuesForMain = getStartAndEndValueForSuit constants.INDEX_SUIT_MAIN
    startAndEndValuesForMainSuit = getStartAndEndValueForSuit mainSuit
    valuesOfMainAndMainSuit = []
    for i in [startAndEndValuesForMain[0]...startAndEndValuesForMain[1] + 1]
        valuesOfMainAndMainSuit.push i
    for i in [startAndEndValuesForMainSuit[0]...startAndEndValuesForMainSuit[1] + 1]
        valuesOfMainAndMainSuit.push i
    return valuesOfMainAndMainSuit

###
Given a suit index and card values at hand, this function finds out all pairs within card values at hand that are the given suit
@param: suitIndex                       the given suit index
@param: cardValues                      the card values from which to search pairs for
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
Check whether the card values contain at least 1 card of specific suit
@param: suitIndex                           designated suit index
@param: cardvaluesAtHand                    the given card values in which to search for
@return: boolean                            true if at least one card of the suit in the array of card values, false otherwise
###
haveSingleForSuit = (suitIndex, cardValues) ->
    cardValuesOfSuit = getCardValuesForSuit suitIndex, cardValues
    if cardValuesOfSuit.length > 0 then return true
    else return false

haveSingleForMainSuit = (mainSuit, cardValues) ->
    cardValuesForMain = getCardValuesForSuit constants.INDEX_SUIT_MAIN, cardValues
    cardValuesForMainSuit = getCardValuesForSuit mainSuit, cardValues
    if cardValuesForMain.length > 0 or
    cardValuesForMainSuit.length > 0 then return true
    else return false

havePairForSuit = (suitIndex, cardValues) ->
    cardValuesOfSuit = getCardValuesForSuit suitIndex, cardValues
    if cardValuesOfSuit.length is 0 then return false
    for i in [0...cardValuesOfSuit.length - 1]
        if cardValuesOfSuit[i] is cardValuesOfSuit[i + 1] then return true
    return false

havePairForMainSuit = (mainSuit, cardValues) ->
    cardValuesForMain = getCardValuesForSuit constants.INDEX_SUIT_MAIN, cardValues
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
    pairValuesOfMain = getPairValuesForSuit constants.INDEX_SUIT_MAIN, cardValues
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

validateSelectedCardsForPlay = (selectedCardValues, firstlyPlayedCardValues, cardValuesAtHand, mainSuit, cardValueRanks, nonBankerPlayersHaveNoMainSuit) ->
    if selectedCardValues.length is 0 then return false
    # 别人已经出牌，本次出牌为跟牌
    if firstlyPlayedCardValues.length > 0
        # 先确定第一轮出的牌的花色
        suitForFirstlyPlayedCards = null
        if isSingleForMainSuit mainSuit, [firstlyPlayedCardValues[0]] then suitForFirstlyPlayedCards = constants.INDEX_SUIT_MAIN
        else if isSingleForSuit constants.INDEX_SUIT_SPADE, [firstlyPlayedCardValues[0]] then suitForFirstlyPlayedCards = constants.INDEX_SUIT_SPADE
        else if isSingleForSuit constants.INDEX_SUIT_HEART, [firstlyPlayedCardValues[0]] then suitForFirstlyPlayedCards = constants.INDEX_SUIT_HEART
        else if isSingleForSuit constants.INDEX_SUIT_CLUB, [firstlyPlayedCardValues[0]] then suitForFirstlyPlayedCards = constants.INDEX_SUIT_CLUB
        else if isSingleForSuit constants.INDEX_SUIT_DIAMOND, [firstlyPlayedCardValues[0]] then suitForFirstlyPlayedCards = constants.INDEX_SUIT_DIAMOND
        # 选中要出的牌和先出的牌数量不一样，非法
        if selectedCardValues.length isnt firstlyPlayedCardValues.length then return false

        if suitForFirstlyPlayedCards is constants.INDEX_SUIT_MAIN
            numberOfMainCardsInSelectedCards = getCardValuesForSuit(constants.INDEX_SUIT_MAIN, selectedCardValues).length + getCardValuesForSuit(mainSuit, selectedCardValues).length
            numberOfMainCardsAtHand = getCardValuesForSuit(constants.INDEX_SUIT_MAIN, cardValuesAtHand).length + getCardValuesForSuit(mainSuit, cardValuesAtHand).length
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
            pairValuesAtHandOfSuit = getPairValuesForSuit constants.INDEX_SUIT_MAIN, cardValuesAtHand
            pairValuesAtHandOfSuit = pairValuesAtHandOfSuit.concat getPairValuesForSuit mainSuit, cardValuesAtHand
            selectedPairValuesOfSuit = getPairValuesForSuit constants.INDEX_SUIT_MAIN, selectedCardValues
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
        # 其他所有情况都是合法
        return true
    # 第一个出牌
    else
        # 选中的牌是单牌，合法
        if selectedCardValues.length is 1 then return true
        # 选中的牌是对子，合法
        if selectedCardValues.length is 2 and
        selectedCardValues[0] is selectedCardValues[1] then return true
        # 选中的牌是任意花色的拖拉机或主牌拖拉机，合法
        if isTractorForSuit selectedCardValues.length / 2, constants.INDEX_SUIT_SPADE, selectedCardValues, cardValueRanks then return true
        else if isTractorForSuit selectedCardValues.length / 2, constants.INDEX_SUIT_HEART, selectedCardValues, cardValueRanks then return true
        else if isTractorForSuit selectedCardValues.length / 2, constants.INDEX_SUIT_CLUB, selectedCardValues, cardValueRanks then return true
        else if isTractorForSuit selectedCardValues.length / 2, constants.INDEX_SUIT_DIAMOND, selectedCardValues, cardValueRanks then return true
        else if isTractorForMainSuit selectedCardValues.length / 2, mainSuit, selectedCardValues, cardValueRanks then return true

        numOfMainSuitCardsInSelectedCards = 0
        for i in [0...selectedCardValues.length]
            if isSingleForMainSuit mainSuit, [selectedCardValues[i]] then numOfMainSuitCardsInSelectedCards += 1
        # 要出的牌全部是主牌，而且所有闲家都已经脱主（也即甩牌），合法
        if numOfMainSuitCardsInSelectedCards is selectedCardValues.length and
        nonBankerPlayersHaveNoMainSuit is constants.TRUE then return true
        # 其他所有情况都是非法
        return false

module.exports =
    sortCards: sortCards
    getCardName: getCardName
    validateSelectedCardsForPlay: validateSelectedCardsForPlay
    getCardValuesForSuit: getCardValuesForSuit
    havePairForSuit: havePairForSuit
    haveSingleForSuit: haveSingleForSuit
    getPairValuesForSuit: getPairValuesForSuit
    haveTractorForSuit: haveTractorForSuit
    getRanksForMainSuitCards: getRanksForMainSuitCards
    sortCardsAfterMainSuitSettled: sortCardsAfterMainSuitSettled
    binarySearch: binarySearch

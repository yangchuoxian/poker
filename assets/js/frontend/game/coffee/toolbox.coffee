constants = require './constants.js'
globalVariables = require './globalVariables.js'
sortCards = (array) ->
    sortNumber = (a, b) ->
        return a - b
    return array.sort sortNumber

###
With the given card value, this function finds out its corresponding card name
@param n:                           the card value
@return string:                     the corresponding card value
###
getCardName = (n) ->
    cardName = ''
    switch n
        when 1 then cardName = 'bigJoker'
        when 2 then cardName = 'smallJoker'
        when 3 then cardName = 'sevenOfSpades'
        when 4 then cardName = 'sevenOfHearts'
        when 5 then cardName = 'sevenOfClubs'
        when 6 then cardName = 'sevenOfDiamonds'
        when 7 then cardName = 'twoOfSpades'
        when 8 then cardName = 'twoOfHearts'
        when 9 then cardName = 'twoOfClubs'
        when 10 then cardName = 'twoOfDiamonds'
        when 11 then cardName = 'aceOfSpades'
        when 12 then cardName = 'kingOfSpades'
        when 13 then cardName = 'queenOfSpades'
        when 14 then cardName = 'jackOfSpades'
        when 15 then cardName = 'tenOfSpades'
        when 16 then cardName = 'nineOfSpades'
        when 17 then cardName = 'eightOfSpades'
        when 18 then cardName = 'sixOfSpades'
        when 19 then cardName = 'fiveOfSpades'
        when 20 then cardName = 'aceOfHearts'
        when 21 then cardName = 'kingOfHearts'
        when 22 then cardName = 'queenOfHearts'
        when 23 then cardName = 'jackOfHearts'
        when 24 then cardName = 'tenOfHearts'
        when 25 then cardName = 'nineOfHearts'
        when 26 then cardName = 'eightOfHearts'
        when 27 then cardName = 'sixOfHearts'
        when 28 then cardName = 'fiveOfHearts'
        when 29 then cardName = 'aceOfClubs'
        when 30 then cardName = 'kingOfClubs'
        when 31 then cardName = 'queenOfClubs'
        when 32 then cardName = 'jackOfClubs'
        when 33 then cardName = 'tenOfClubs'
        when 34 then cardName = 'nineOfClubs'
        when 35 then cardName = 'eightOfClubs'
        when 36 then cardName = 'sixOfClubs'
        when 37 then cardName = 'fiveOfClubs'
        when 38 then cardName = 'aceOfDiamonds'
        when 39 then cardName = 'kingOfDiamonds'
        when 40 then cardName = 'queenOfDiamonds'
        when 41 then cardName = 'jackOfDiamonds'
        when 42 then cardName = 'tenOfDiamonds'
        when 43 then cardName = 'nineOfDiamonds'
        when 44 then cardName = 'eightOfDiamonds'
        when 45 then cardName = 'sixOfDiamonds'
        when 46 then cardName = 'fiveOfDiamonds'
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
@param: cardValuesAtHand                the card values at hand
@return: array                          all the values of pairs that satisfies the condition
###
getAllPairValuesAtHandForSuit = (suitIndex, cardValuesAtHand) ->
    cardValuesAtHandOfSuit = getCardValuesForSuit suitIndex, cardValuesAtHand
    pairValues = []
    for i in [0...cardValuesAtHandOfSuit.length - 1]
        if cardValuesAtHandOfSuit[i] is cardValuesAtHandOfSuit[i + 1] then pairValues.push cardValuesAtHandOfSuit[i]
    return pairValues

###
With the given suit as main suit, this function returns all related main suit card values
@param: mainSuit                        the main suit index
@return: mainSuitValues                 an array that contains card values including main seven, other sevens, main two, other twos and main ace
###
getRelativeMainSuitValues = (mainSuit) ->
    mainSuitValues = {}
    switch mainSuit
        when constants.INDEX_SUIT_SPADE
            mainSuitValues.valueOfMainSuitOfSeven = constants.VALUE_SPADE_SEVEN
            mainSuitValues.valuesOfRestSuitsOfSeven = [constants.VALUE_HEART_SEVEN, constants.VALUE_CLUB_SEVEN, constants.VALUE_DIAMOND_SEVEN]
            mainSuitValues.valueOfMainSuitOfTwo = constants.VALUE_SPADE_TWO
            mainSuitValues.valuesOfRestSuitsOfTwo = [constants.VALUE_HEART_TWO, constants.VALUE_CLUB_TWO, constants.VALUE_DIAMOND_TWO]
            mainSuitValues.valueOfMainSuitOfAce = constants.VALUE_SPADE_ACE
        when constants.INDEX_SUIT_HEART
            mainSuitValues.valueOfMainSuitOfSeven = constants.VALUE_HEART_SEVEN
            mainSuitValues.valuesOfRestSuitsOfSeven = [constants.VALUE_SPADE_SEVEN, constants.VALUE_CLUB_SEVEN, constants.VALUE_DIAMOND_SEVEN]
            mainSuitValues.valueOfMainSuitOfTwo = constants.VALUE_HEART_TWO
            mainSuitValues.valuesOfRestSuitsOfTwo = [constants.VALUE_SPADE_TWO, constants.VALUE_CLUB_TWO, constants.VALUE_DIAMOND_TWO]
            mainSuitValues.valueOfMainSuitOfAce = constants.VALUE_HEART_ACE
        when constants.INDEX_SUIT_CLUB
            mainSuitValues.valueOfMainSuitOfSeven = constants.VALUE_CLUB_SEVEN
            mainSuitValues.valuesOfRestSuitsOfSeven = [constants.VALUE_SPADE_SEVEN, constants.VALUE_HEART_SEVEN, constants.VALUE_DIAMOND_SEVEN]
            mainSuitValues.valueOfMainSuitOfTwo = constants.VALUE_CLUB_TWO
            mainSuitValues.valuesOfRestSuitsOfTwo = [constants.VALUE_SPADE_TWO, constants.VALUE_HEART_TWO, constants.VALUE_DIAMOND_TWO]
            mainSuitValues.valueOfMainSuitOfAce = constants.VALUE_CLUB_ACE
        when constants.INDEX_SUIT_DIAMOND
            mainSuitValues.valueOfMainSuitOfSeven = constants.VALUE_DIAMOND_SEVEN
            mainSuitValues.valuesOfRestSuitsOfSeven = [constants.VALUE_SPADE_SEVEN, constants.VALUE_HEART_SEVEN, constants.VALUE_CLUB_SEVEN]
            mainSuitValues.valueOfMainSuitOfTwo = constants.VALUE_DIAMOND_TWO
            mainSuitValues.valuesOfRestSuitsOfTwo = [constants.VALUE_SPADE_TWO, constants.VALUE_HEART_TWO, constants.VALUE_CLUB_TWO]
            mainSuitValues.valueOfMainSuitOfAce = constants.VALUE_DIAMOND_ACE
    return mainSuitValues

###
Check whether the card values contain at least 1 card of specific suit
@param: suitIndex                           designated suit index
@param: cardvaluesAtHand                    the given card values in which to search for
@return: boolean                            true if at least one card of the suit in the array of card values, false otherwise
###
haveSingleForSuit = (suitIndex, cardValuesAtHand) ->
    cardValuesAtHandOfSuit = getCardValuesForSuit suitIndex, cardValuesAtHand
    if cardValuesAtHandOfSuit.length > 0 then return true
    else return false

haveSingleForMainSuit = (mainSuit, cardValuesAtHand) ->
    cardValuesAtHandForMain = getCardValuesForSuit constants.INDEX_SUIT_MAIN, cardValuesAtHand
    cardValuesAtHandForMainSuit = getCardValuesForSuit mainSuit, cardValuesAtHand
    if cardValuesAtHandForMain.length > 0 or
    cardValuesAtHandForMainSuit.length > 0 then return true
    else return false

havePairForSuit = (suitIndex, cardValuesAtHand) ->
    cardValuesAtHandOfSuit = getCardValuesForSuit suitIndex, cardValuesAtHand
    for i in [0...cardValuesAtHandOfSuit.length - 1]
        if cardValuesAtHandOfSuit[i] is cardValuesAtHandOfSuit[i + 1] then return true
    return false

havePairForMainSuit = (mainSuit, cardValuesAtHand) ->
    cardValuesAtHandForMain = getCardValuesForSuit constants.INDEX_SUIT_MAIN, cardValuesAtHand
    cardValuesAtHandForMainSuit = getCardValuesForSuit mainSuit, cardValuesAtHand
    mains = cardValuesAtHandForMain.concat cardValuesAtHandForMainSuit
    for i in [0...mains.length - 1]
        if mains[i] is mains[i + 1] then return true
    return false

haveTractorForSuit = (tractorLength, suitIndex, cardValuesAtHand) ->
    pairValuesAtHandOfSuit = getAllPairValuesAtHandForSuit suitIndex, cardValuesAtHand
    if pairValuesAtHandOfSuit.length < tractorLength then return false
    numOfConsecutivePairs = 0
    for i in [0...pairValuesAtHandOfSuit.length]
        if (pairValuesAtHandOfSuit.length - i) < tractorLength then return false
        if (pairValuesAtHandOfSuit[i] + 1) is pairValuesAtHandOfSuit[i + 1]
            numOfConsecutivePairs += 1
            if numOfConsecutivePairs is tractorLength then return true
        else numOfConsecutivePairs = 0
    return false

haveTractorForMainSuit = (tractorLength, mainSuit, cardValuesAtHand) ->
    pairValuesAtHandOfMain = getAllPairValuesAtHandForSuit constants.INDEX_SUIT_MAIN, cardValuesAtHand
    pairValuesAtHandOfSuit = getAllPairValuesAtHandForSuit mainSuit, cardValuesAtHand
    pairs = pairValuesAtHandOfMain.concat pairValuesAtHandOfSuit
    numOfConsecutivePairs = 0
    mainSuitValues = getRelativeMainSuitValues mainSuit
    for i in [0...pairs.length]
        if (pairs.length - i) < tractorLength then return false
        # big joker and small joker
        if (pairs[i] is 1 and pairs[i + 1] is 2) or
        # small joker and main seven
        (pairs[i] is 2 and pairs[i + 1] is mainSuitValues.valueOfMainSuitOfSeven) or
        # main seven and rest seven
        (pairs[i] is mainSuitValues.valueOfMainSuitOfSeven and pairs[i + 1] in mainSuitValues.valuesOfRestSuitsOfSeven) or
        # rest seven and main seven
        (pairs[i] in mainSuitValues.valuesOfRestSuitsOfSeven and pairs[i + 1] is mainSuitValues.valueOfMainSuitOfSeven) or
        # rest seven and main two
        (pairs[i] in mainSuitValues.valuesOfRestSuitsOfSeven and pairs[i + 1] is mainSuitValues.valueOfMainSuitOfTwo) or
        # main two and rest two
        (pairs[i] is mainSuitValues.valueOfMainSuitOfTwo and pairs[i + 1] in mainSuitValues.valuesOfRestSuitsOfTwo) or
        # rest two and main two
        (pairs[i] in mainSuitValues.valuesOfRestSuitsOfTwo and pairs[i + 1] is mainSuitValues.valueOfMainSuitOfTwo) or
        # rest two and main ace
        (pairs[i] in mainSuitValues.valuesOfRestSuitsOfTwo and pairs[i + 1] is mainSuitValues.valueOfMainSuitOfAce) or
        # regular suit tractor
        (pairs[i] >= mainSuitValues.valueOfMainSuitOfAce and (pairs[i] + 1) is pairs[i + 1])
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
    cardValues[i] in valuesOfMainAndMainSuit then return true
    else return false

isTractorForSuit = (tractorLength, suitIndex, cardValues) ->
    if tractorLength is 0 or cardValues.length < 4 then return false
    if cardValues.length < tractorLength * 2 or
    cardValues.length % 2 isnt 0 then return false
    startAndEndValuesForSuit = getStartAndEndValueForSuit suitIndex
    if cardValues[0] < startAndEndValuesForSuit[0] or cardValues[cardValues.length - 1] > startAndEndValuesForSuit[1] then return false
    i = 0
    while i < (cardValues.length - 2)
        if cardValues[i] isnt cardValues[i + 1] or
        (cardValues[i] + 1) isnt cardValues[i + 2] then return false
        i += 2
    return true

isTractorForMainSuit = (tractorLength, mainSuit, cardValues) ->
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
        else pairRanks.push globalVariables.cardValueRanks[cardValues[i]]
        i += 2
    pairRanks = sortCards pairRanks
    for i in [0...pairRanks.length - 1]
        if (pairRanks[i] + 1) isnt pairRanks[i + 1] then return false
    return true

validateSelectedCardsForPlay = (selectedCardValues, firstlyPlayedCardValues, cardValuesAtHand, mainSuit) ->
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
            if numberOfCardsInSelectedCardsForSpecificSuit < firstlyPlayedCardValues.length and
            numberOfCardsInSelectedCardsForSpecificSuit isnt numberOfCardsAtHandForSpecificSuit then return false

        # 单牌调主，有主牌单牌但是不出，非法
        if isSingleForMainSuit mainSuit, firstlyPlayedCardValues
            if haveSingleForMainSuit mainSuit, cardValuesAtHand and
            not isSingleForMainSuit mainSuit, selectedCardValues then return false
        # 某花色单牌，有该花色单牌但是不出，非法
        if isSingleForSuit suitForFirstlyPlayedCards, firstlyPlayedCardValues
            if haveSingleForSuit suitForFirstlyPlayedCards, cardValuesAtHand and
            not isSingleForSuit suitForFirstlyPlayedCards, selectedCardValues then return false
        # 对子调主，有主牌对子但是不出，非法
        if isPairForMainSuit mainSuit, firstlyPlayedCardValues
            if havePairForMainSuit mainSuit, cardValuesAtHand and
            not isPairForMainSuit mainSuit, selectedCardValues then return false
        # 某花色对子，有该花色对子但是不出，非法
        if isPairForSuit suitForFirstlyPlayedCards, firstlyPlayedCardValues
            if havePairForSuit suitForFirstlyPlayedCards, cardValuesAtHand and
            not isPairForSuit suitForFirstlyPlayedCards, selectedCardValues then return false

        if firstlyPlayedCardValues.length % 2 is 0
            # 主牌拖拉机调主，有主牌拖拉机但是不出，非法
            if isTractorForMainSuit firstlyPlayedCardValues.length / 2, mainSuit, firstlyPlayedCardValues
                if haveTractorForMainSuit firstlyPlayedCardValues.length / 2, mainSuit, cardValuesAtHand and
                not isTractorForMainSuit selectedCardValues.length / 2, mainSuit, selectedCardValues then return false
            # 某花色拖拉机先出，有该花色拖拉机但是不出，非法
            if isTractorForSuit firstlyPlayedCardValues.length / 2, suitForFirstlyPlayedCards, firstlyPlayedCardValues
                if haveTractorForSuit firstlyPlayedCardValues.length / 2, suitForFirstlyPlayedCards, cardValuesAtHand and
                not isTractorForSuit selectedCardValues.length / 2, suitForFirstlyPlayedCards, selectedCardValues then return false
    # 第一个出牌
    else
        # 选中的牌数量为大于1的单数，非法
        if selectedCardValues.length > 1 and
        selectedCardValues.length % 2 isnt 0 then return false
        # 选中的牌为2张，但是不是对子，非法
        if selectedCardValues.length is 2 and
        selectedCardValues[0] isnt selectedCardValues[1] then return false
        # 选中的牌数量大于等于4张，但是不是任何花色的拖拉机，非法
        if selectedCardValues.length >= 4
            if isTractorForSuit selectedCardValues.length / 2, constants.INDEX_SUIT_SPADE, selectedCardValues then return true
            else if isTractorForSuit selectedCardValues.length / 2, constants.INDEX_SUIT_HEART, selectedCardValues then return true
            else if isTractorForSuit selectedCardValues.length / 2, constants.INDEX_SUIT_CLUB, selectedCardValues then return true
            else if isTractorForSuit selectedCardValues.length / 2, constants.INDEX_SUIT_DIAMOND, selectedCardValues then return true
            else if isTractorForMainSuit selectedCardValues.length / 2, mainSuit, selectedCardValues then return true
            else return false
    return true

module.exports =
    sortCards: sortCards
    getCardName: getCardName
    validateSelectedCardsForPlay: validateSelectedCardsForPlay
    getCardValuesForSuit: getCardValuesForSuit
    havePairForSuit: havePairForSuit
    haveSingleForSuit: haveSingleForSuit
    getAllPairValuesAtHandForSuit: getAllPairValuesAtHandForSuit
    haveTractorForSuit: haveTractorForSuit
    getRanksForMainSuitCards: getRanksForMainSuitCards

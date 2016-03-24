constants = require './constants.js'
globalVariables = require './globalVariables.js'
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
Set status text for one player and clear status text for all other players
@param: username                                player username whose status text needs to be updated
@param: statusText                              the status text string
@return: -
###
setPlayerStatusTextForOneUserAndClearStatusTextForOthers = (username, statusText) ->
    globalVariables.meStatusText.text = ''
    globalVariables.player1StatusText.text = ''
    globalVariables.player2StatusText.text = ''
    globalVariables.player3StatusText.text = ''
    if username is globalVariables.username then globalVariables.meStatusText.text = statusText
    else if username is globalVariables.player1Username.text then globalVariables.player1StatusText.text = statusText
    else if username is globalVariables.player2Username.text then globalVariables.player2StatusText.text = statusText
    else if username is globalVariables.player3Username.text then globalVariables.player3StatusText.text = statusText

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
    if cardValuesAtHandOfSuit.length is 0 then return pairValues
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
haveSingleForSuit = (suitIndex, cardValues) ->
    cardValuesAtHandOfSuit = getCardValuesForSuit suitIndex, cardValues
    if cardValuesAtHandOfSuit.length > 0 then return true
    else return false

haveSingleForMainSuit = (mainSuit, cardValues) ->
    cardValuesAtHandForMain = getCardValuesForSuit constants.INDEX_SUIT_MAIN, cardValues
    cardValuesAtHandForMainSuit = getCardValuesForSuit mainSuit, cardValues
    if cardValuesAtHandForMain.length > 0 or
    cardValuesAtHandForMainSuit.length > 0 then return true
    else return false

havePairForSuit = (suitIndex, cardValues) ->
    cardValuesAtHandOfSuit = getCardValuesForSuit suitIndex, cardValues
    for i in [0...cardValuesAtHandOfSuit.length - 1]
        if cardValuesAtHandOfSuit[i] is cardValuesAtHandOfSuit[i + 1] then return true
    return false

havePairForMainSuit = (mainSuit, cardValues) ->
    cardValuesAtHandForMain = getCardValuesForSuit constants.INDEX_SUIT_MAIN, cardValues
    cardValuesAtHandForMainSuit = getCardValuesForSuit mainSuit, cardValues
    mains = cardValuesAtHandForMain.concat cardValuesAtHandForMainSuit
    for i in [0...mains.length - 1]
        if mains[i] is mains[i + 1] then return true
    return false

haveTractorForSuit = (tractorLength, suitIndex, cardValues) ->
    pairValuesAtHandOfSuit = getAllPairValuesAtHandForSuit suitIndex, cardValues
    # no pair, thus no tractor
    if pairValuesAtHandOfSuit.length is 0 then return false
    # the number of pairs is less than the tractor length
    if pairValuesAtHandOfSuit.length < tractorLength then return false
    numOfConsecutivePairs = 1
    for i in [0...pairValuesAtHandOfSuit.length]
        if (pairValuesAtHandOfSuit[i] + 1) is pairValuesAtHandOfSuit[i + 1]
            numOfConsecutivePairs += 1
            if numOfConsecutivePairs is tractorLength then return true
        else numOfConsecutivePairs = 0
    return false

haveTractorForMainSuit = (tractorLength, mainSuit, cardValues) ->
    pairValuesAtHandOfMain = getAllPairValuesAtHandForSuit constants.INDEX_SUIT_MAIN, cardValues
    pairValuesAtHandOfSuit = getAllPairValuesAtHandForSuit mainSuit, cardValues
    pairs = pairValuesAtHandOfMain.concat pairValuesAtHandOfSuit
    # no pair for the given card values, thus no tractor for main suit
    if pairs.length is 0 then return false
    # the number of pairs is less than the tractor length
    if pairs.length < tractorLength then return false
    numOfConsecutivePairs = 1
    pairRanks = []
    for i in [0...pairs.length]
        pairRanks.push globalVariables.cardValueRanks[pairs[i]]
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

isTractorForSuit = (tractorLength, suitIndex, cardValues) ->
    if tractorLength is 0 or cardValues.length < 4 then return false
    if cardValues.length < tractorLength * 2 or
    cardValues.length % 2 isnt 0 then return false
    startAndEndValuesForSuit = getStartAndEndValueForSuit suitIndex
    if cardValues[0] < startAndEndValuesForSuit[0] or cardValues[cardValues.length - 1] > startAndEndValuesForSuit[1] then return false
    i = 0
    pairRanks = []
    while i <= (cardValues.length - 2)
        if cardValues[i] isnt cardValues[i + 1] then return false
        else pairRanks.push globalVariables.cardValueRanks[cardValues[i]]
        i += 2
    pairRanks = sortCards pairRanks
    for i in [0...pairRanks.length - 1]
        if (pairRanks[i] + 1) isnt pairRanks[i + 1] then return false
    return true

isTractorForMainSuit = (tractorLength, mainSuit, cardValues) ->
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
        else if isTractorForMainSuit firstlyPlayedCardValues.length / 2, mainSuit, firstlyPlayedCardValues
            if haveTractorForMainSuit firstlyPlayedCardValues.length / 2, mainSuit, cardValuesAtHand
                if not isTractorForMainSuit selectedCardValues.length / 2, mainSuit, selectedCardValues then return false
            pairValuesAtHandOfSuit = getAllPairValuesAtHandForSuit constants.INDEX_SUIT_MAIN, cardValuesAtHand
            pairValuesAtHandOfSuit = pairValuesAtHandOfSuit.concat getAllPairValuesAtHandForSuit mainSuit, cardValuesAtHand
            selectedPairValuesOfSuit = getAllPairValuesAtHandForSuit constants.INDEX_SUIT_MAIN, selectedCardValues
            selectedPairValuesOfSuit = selectedPairValuesOfSuit.concat getAllPairValuesAtHandForSuit mainSuit, selectedCardValues
            # 手上有n对主牌但是选定的牌少于n对，非法
            if selectedPairValuesOfSuit.length < firstlyPlayedCardValues.length / 2
                if (selectedPairValuesOfSuit.length isnt pairValuesAtHandOfSuit.length) and
                (pairValuesAtHandOfSuit.length isnt 0) then return false
        # 某花色拖拉机先出，有该花色拖拉机但是不出，非法
        else if isTractorForSuit firstlyPlayedCardValues.length / 2, suitForFirstlyPlayedCards, firstlyPlayedCardValues
            if haveTractorForSuit firstlyPlayedCardValues.length / 2, suitForFirstlyPlayedCards, cardValuesAtHand
                if not isTractorForSuit selectedCardValues.length / 2, suitForFirstlyPlayedCards, selectedCardValues then return false
            # 手上有n对该花色的牌，但是选定的牌少于n对该花色的牌，非法
            pairValuesAtHandOfSuit = getAllPairValuesAtHandForSuit suitForFirstlyPlayedCards, cardValuesAtHand
            selectedPairValuesOfSuit = getAllPairValuesAtHandForSuit suitForFirstlyPlayedCards, selectedCardValues
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
    setPlayerStatusTextForOneUserAndClearStatusTextForOthers: setPlayerStatusTextForOneUserAndClearStatusTextForOthers
    sortCardsAfterMainSuitSettled: sortCardsAfterMainSuitSettled
    binarySearch: binarySearch

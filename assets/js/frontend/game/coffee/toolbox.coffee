constants = require './constants.js'
globalVariables = require './globalVariables.js'
sortCards = (array) ->
    sortNumber = (a, b) ->
        return a - b
    return array.sort sortNumber

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

showPlayedCardsForUser = (n, valuesOfPlayedCards) ->
    startX = null
    startY = null
    userPlayedCards = null
    switch n
        when 0         # current user
            startX = globalVariables.screenWidth / 2 - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 8
            startY = globalVariables.screenHeight - 2 * globalVariables.scaledCardHeight - 2 * constants.MARGIN
            userPlayedCards = globalVariables.currentUserPlayedCards
        when 1         # the 1st user
            startX = globalVariables.screenWidth - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 4 - constants.MARGIN
            startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2
            userPlayedCards = globalVariables.user1PlayedCards
        when 2         # the 2nd user
            startX = globalVariables.screenWidth / 2 - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 8
            startY = constants.MARGIN
            userPlayedCards = globalVariables.user2PlayedCards
        when 3         # the 3rd user
            startX = constants.MARGIN
            startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2
            userPlayedCards = globalVariables.user3PlayedCards
    # remove played cards
    cardsToRemove = []
    for i in [0...userPlayedCards.children.length]
        cardsToRemove.push userPlayedCards.children[i]
    for i in [0...cardsToRemove.length]
        userPlayedCards.remove cardsToRemove[i]
    for i in [0...valuesOfPlayedCards.length]
        playedCard = userPlayedCards.create startX + i * globalVariables.scaledCardWidth / 4, startY, getCardName(valuesOfPlayedCards[i])
        playedCard.width = globalVariables.scaledCardWidth
        playedCard.height = globalVariables.scaledCardHeight

toggleCardSelection = (sprite) ->
    if not sprite.isSelected then sprite.y = sprite.y - constants.SELECTED_CARD_Y_OFFSET
    else sprite.y = sprite.y + constants.SELECTED_CARD_Y_OFFSET
    sprite.isSelected = !sprite.isSelected

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

getCardValuesAtHandForSuit = (suitIndex, cardValuesAtHand) ->
    startAndEndValuesForSuit = getStartAndEndValueForSuit suitIndex
    cardValuesAtHandOfSuit = []
    for i in [0...cardValuesAtHand.length]
        if cardValuesAtHand[i] >= startAndEndValuesForSuit[0] and cardValuesAtHand[i] <= startAndEndValuesForSuit[1] then cardValuesAtHandOfSuit.push cardValuesAtHand[i]
    return cardValuesAtHandOfSuit

havePairForSuit = (suitIndex, cardValuesAtHand) ->
    cardValuesAtHandOfSuit = getCardValuesAtHandForSuit suitIndex, cardValuesAtHand
    for i in [0...cardValuesAtHandOfSuit.length - 1]
        if cardValuesAtHandOfSuit[i] is cardValuesAtHandOfSuit[i + 1] then return true
    return false

haveSingleForSuit = (suitIndex, cardValuesAtHand) ->
    cardValuesAtHandOfSuit = getCardValuesAtHandForSuit suitIndex, cardValuesAtHand
    if cardValuesAtHandOfSuit.length > 0 then return true
    else return false

getAllPairValuesAtHandForSuit = (suitIndex, cardValuesAtHand) ->
    cardValuesAtHandOfSuit = getCardValuesAtHandForSuit suitIndex, cardValuesAtHand
    pairValues = []
    for i in [0...cardValuesAtHandOfSuit.length - 1]
        if cardValuesAtHandOfSuit[i] is cardValuesAtHandOfSuit[i + 1] then pairValues.push cardValuesAtHandOfSuit[i]
    return pairValues

haveTractorForSuit = (suitIndex, tractorLength, cardValuesAtHand) ->
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

getRelativeMainSuitValues = (mainSuit) ->
    mainSuitValues = {}
    switch mainSuit
        when constants.INDEX_SUIT_SPADE
            mainSuitValues.valueOfMainSuitOfSeven = 3
            mainSuitValues.valuesOfRestSuitsOfSeven = [4, 5, 6]
            mainSuitValues.valueOfMainSuitOfTwo = 7
            mainSuitValues.valuesOfRestSuitsOfTwo = [8, 9, 10]
            mainSuitValues.valueOfMainSuitOfAce = 11
        when constants.INDEX_SUIT_HEART
            mainSuitValues.valueOfMainSuitOfSeven = 4
            mainSuitValues.valuesOfRestSuitsOfSeven = [3, 5, 6]
            mainSuitValues.valueOfMainSuitOfTwo = 8
            mainSuitValues.valuesOfRestSuitsOfTwo = [7, 9, 10]
            mainSuitValues.valueOfMainSuitOfAce = 20
        when constants.INDEX_SUIT_CLUB
            mainSuitValues.valueOfMainSuitOfSeven = 5
            mainSuitValues.valuesOfRestSuitsOfSeven = [3, 4, 6]
            mainSuitValues.valueOfMainSuitOfTwo = 9
            mainSuitValues.valuesOfRestSuitsOfTwo = [7, 8, 10]
            mainSuitValues.valueOfMainSuitOfAce = 29
        when constants.INDEX_SUIT_DIAMOND
            mainSuitValues.valueOfMainSuitOfSeven = 6
            mainSuitValues.valuesOfRestSuitsOfSeven = [3, 4, 5]
            mainSuitValues.valueOfMainSuitOfTwo = 10
            mainSuitValues.valuesOfRestSuitsOfTwo = [7, 8, 9]
            mainSuitValues.valueOfMainSuitOfAce = 38
    return mainSuitValues

haveTractorForMainSuit = (tractorLength, cardValuesAtHand, mainSuit) ->
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

isPairForSuit = (suitIndex, cardValues) ->
    startAndEndValuesForSuit = getStartAndEndValueForSuit suitIndex
    if cardValues.length is 2 and
    cardValues[0] is cardValues[1] and
    cardValues[0] >= startAndEndValuesForSuit[0] and
    cardValues[1] <= startAndEndValuesForSuit[1] then return true
    else return false

isTractorForSuit = (suitIndex, cardValues) ->
    if cardValues.length < 4 or cardValues.length % 2 isnt 0 then return false
    startAndEndValuesForSuit = getStartAndEndValueForSuit suitIndex
    if cardValues[0] < startAndEndValuesForSuit[0] or cardValues[cardValues.length - 1] > startAndEndValuesForSuit[1] then return false
    i = 0
    while i < (cardValues.length - 2)
        if cardValues[i] isnt cardValues[i + 1] or
        (cardValues[i] + 1) isnt cardValues[i + 2] then return false
        i += 2
    return true

isTractorForMainSuit = (mainSuit, cardValues) ->
    if cardValues.length < 4 or cardValues.length % 2 isnt 0 then return false
    mainSuitValues = getRelativeMainSuitValues mainSuit
    startAndEndValuesForMain = getStartAndEndValueForSuit constants.INDEX_SUIT_MAIN
    startAndEndValuesForMainSuit = getStartAndEndValueForSuit mainSuit
    valuesOfMainAndMainSuit = []
    for i in [startAndEndValuesForMain[0]...startAndEndValuesForMain[1] + 1]
        valuesOfMainAndMainSuit.push i
    for i in [startAndEndValuesForMainSuit[0]...startAndEndValuesForMainSuit[1] + 1]
        valuesOfMainAndMainSuit.push i
    # if the selected cards contains any card that is NEITHER main NOR main suit, then should return false
    for i in [0...cardValues.length]
        if cardValues[i] not in valuesOfMainAndMainSuit then return false
    i = 0
    while i < (cardValues.length - 2)
        # starting with even index, if the consecutive two cards is NOT the same, quit with false
        if cardValues[i] isnt cardValues[i + 1] then return false
        # for 2 consecutive pairs, if the first pair is big joker and the second pair is NOT small joker, quit with false
        else if cardValues[i] is 1 and cardValues[i + 2] isnt 2 then return false
        # for 2 consecutive pairs, if the first pair is small joker and the second pair is NOT main seven, quit with false
        else if cardValues[i] is 2 and cardValues[i + 2] isnt mainSuitValues.valueOfMainSuitOfSeven then return false
        # for 2 consecutive pairs, if the first pair is main seven and the second pair is NOT one of the rest suit of sevens, quit with false
        else if cardValues[i] is mainSuitValues.valueOfMainSuitOfSeven and cardValues[i + 2] not in mainSuitValues.valuesOfRestSuitsOfSeven then return false
        # for 2 consecutive pairs, if the first pair is one of rest suit of sevens and the second pair is NEITHER main seven NOR main two, quit with false
        else if cardValues[i] in mainSuitValues.valuesOfRestSuitsOfSeven and
        (cardValues[i + 2] isnt mainSuitValues.valueOfMainSuitOfSeven and cardValues[i + 2] isnt mainSuitValues.valueOfMainSuitOfTwo) then return false
        # for 2 consecutive pairs, if the first pair is main two and the second pair is NOT one of the rest of twos, quit with false
        else if cardValues[i] is mainSuitValues.valueOfMainSuitOfTwo and cardValues[i + 2] not in mainSuitValues.valuesOfRestSuitsOfTwo then return false
        # for 2 consecutive pairs, if the first pair is one of the rest of twos and the second pair is NEITHER main two NOR main ace, quit with false
        else if cardValues[i] in mainSuitValues.valuesOfRestSuitsOfTwo and
        (cardValues[i + 2] isnt mainSuitValues.valueOfMainSuitOfTwo and cardValues[i + 2] isnt mainSuitValues.valueOfMainSuitOfAce) then return false
        # whether regular consecutive pairs for main suit
        else if cardValues[i] >= mainSuitValues.valueOfMainSuitOfAce and (cardValues[i] + 1) isnt cardValues[i + 2] then return false
        i += 2
    return true

validateSelectedCardsForPlay = (selectedCardValues, firstlyPlayedCardValues) ->
    if selectedCardValues.length is 0 then return false

    return false

module.exports =
    sortCards: sortCards
    getCardName: getCardName
    toggleCardSelection: toggleCardSelection
    showPlayedCardsForUser: showPlayedCardsForUser
    validateSelectedCardsForPlay: validateSelectedCardsForPlay
    getCardValuesAtHandForSuit: getCardValuesAtHandForSuit
    havePairForSuit: havePairForSuit
    haveSingleForSuit: haveSingleForSuit
    getAllPairValuesAtHandForSuit: getAllPairValuesAtHandForSuit
    haveTractorForSuit: haveTractorForSuit

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

getCardValuesAtHandForSuit = (suitIndex, cardValuesAtHand) ->
    startCardValueForSuit = 0
    endCardValueForSuit = 0
    switch suitIndex
        when constants.SUIT_SPADE
            startCardValueForSuit = constants.START_VALUE_FOR_SPADE
            endCardValueForSuit = constants.END_VALUE_FOR_SPADE
        when constants.SUIT_HEART
            startCardValueForSuit = constants.START_VALUE_FOR_HEART
            endCardValueForSuit = constants.END_VALUE_FOR_HEART
        when constants.SUIT_CLUB
            startCardValueForSuit = constants.START_VALUE_FOR_CLUB
            endCardValueForSuit = constants.END_VALUE_FOR_CLUB
        when constants.SUIT_DIAMOND
            startCardValueForSuit = constants.START_VALUE_FOR_DIAMOND
            endCardValueForSuit = constants.END_VALUE_FOR_DIAMOND
    cardValuesAtHandOfSuit = []
    for i in [0...cardValuesAtHand.length]
        if cardValuesAtHand[i] >= startCardValueForSuit and cardValuesAtHand[i] <= endCardValueForSuit then cardValuesAtHandOfSuit.push cardValuesAtHand[i]
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

getAllPairValuesAtHandForSuit = (suitIndex) ->
    cardValuesAtHandOfSuit = getCardValuesAtHandForSuit suitIndex, cardValuesAtHand
    pairValues = []
    for i in [0...cardValuesAtHandOfSuit.length - 1]
        if cardValuesAtHandOfSuit[i] is cardValuesAtHandOfSuit[i + 1] then pairValues.push cardValuesAtHandOfSuit[i]
    return pairValues

haveTractorForSuit = (suitIndex, tractorLength, cardValuesAtHand) ->
    pairValuesAtHandOfSuit = getAllPairValuesAtHandForSuit suitIndex
    if pairValuesAtHandOfSuit.length < tractorLength then return false
    numOfConsecutivePairs = 0
    for i in [0...pairValuesAtHandOfSuit.length]
        if (pairValuesAtHandOfSuit.length - i) < tractorLength then return false
        if (pairValuesAtHandOfSuit[i] + 1) is pairValuesAtHandOfSuit[i]
            numOfConsecutivePairs += 1
            if numOfConsecutivePairs is tractorLength then return true
        else numOfConsecutivePairs = 0
    return false

validateSelectedCardsForPlay = (selectedCardValues, cardValuesAtHand, firstlyPlayedCardValues) ->
    if selectedCardValues.length is 0 then return false
    selectedCardValues = sortCards selectedCardValues
    cardValuesAtHand = sortCards cardValuesAtHand
    firstlyPlayedCardValues = sortCards firstlyPlayedCardValues

module.exports =
    sortCards: sortCards
    getCardName: getCardName
    toggleCardSelection: toggleCardSelection
    showPlayedCardsForUser: showPlayedCardsForUser
    validateSelectedCardsForPlay: validateSelectedCardsForPlay

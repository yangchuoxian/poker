var constants = require('./constants.js');
var globalVariables = require('./globalVariables.js');

module.exports = {
	shuffleCards: function() {
	    var array = [];
	    var i, j;
	    for (j = 0; j < 2; j ++) {
	        for (i = 1; i <= 46; i ++) {
	            array.push(i);
	        }
	    }
	    var copy = [], n = array.length;
	    while (n) {
	        i = Math.floor(Math.random() * array.length);
	        if (i in array) {
	            copy.push(array[i]);
	            delete array[i];
	            n --;
	        }
	    }
	    return copy;
	},

	sortCards: function(array) {
	    var sortNumber = function(a, b) {
	        return a - b;
	    };
	    return array.sort(sortNumber);
	},

	getCardName: function(n) {
	    var cardName = '';
	    switch (n) {
	        case 1:
	        cardName = 'bigJoker';
	        break;
	        case 2:
	        cardName = 'smallJoker';
	        break;
	        case 3:
	        cardName = 'sevenOfSpades';
	        break;
	        case 4:
	        cardName = 'sevenOfHearts';
	        break;
	        case 5:
	        cardName = 'sevenOfClubs';
	        break;
	        case 6:
	        cardName = 'sevenOfDiamonds';
	        break;
	        case 7:
	        cardName = 'twoOfSpades';
	        break;
	        case 8:
	        cardName = 'twoOfHearts';
	        break;
	        case 9:
	        cardName = 'twoOfClubs';
	        break;
	        case 10:
	        cardName = 'twoOfDiamonds';
	        break;
	        case 11:
	        cardName = 'aceOfSpades';
	        break;
	        case 12: 
	        cardName = 'kingOfSpades';
	        break;
	        case 13:
	        cardName = 'queenOfSpades';
	        break;
	        case 14:
	        cardName = 'jackOfSpades';
	        break;
	        case 15:
	        cardName = 'tenOfSpades';
	        break;
	        case 16:
	        cardName = 'nineOfSpades';
	        break;
	        case 17:
	        cardName = 'eightOfSpades';
	        break;
	        case 18:
	        cardName = 'sixOfSpades';
	        break;
	        case 19:
	        cardName = 'fiveOfSpades';
	        break;
	        case 20:
	        cardName = 'aceOfHearts';
	        break;
	        case 21:
	        cardName = 'kingOfHearts';
	        break;
	        case 22:
	        cardName = 'queenOfHearts';
	        break;
	        case 23:
	        cardName = 'jackOfHearts';
	        break;
	        case 24:
	        cardName = 'tenOfHearts';
	        break;
	        case 25:
	        cardName = 'nineOfHearts';
	        break;
	        case 26:
	        cardName = 'eightOfHearts';
	        break;
	        case 27:
	        cardName = 'sixOfHearts';
	        break;
	        case 28:
	        cardName = 'fiveOfHearts';
	        break;
	        case 29:
	        cardName = 'aceOfClubs';
	        break;
	        case 30:
	        cardName = 'kingOfClubs';
	        break;
	        case 31:
	        cardName = 'queenOfClubs';
	        break;
	        case 32:
	        cardName = 'jackOfClubs';
	        break;
	        case 33:
	        cardName = 'tenOfClubs';
	        break;
	        case 34:
	        cardName = 'nineOfClubs';
	        break;
	        case 35:
	        cardName = 'eightOfClubs';
	        break;
	        case 36:
	        cardName = 'sixOfClubs';
	        break;
	        case 37:
	        cardName = 'fiveOfClubs';
	        break;
	        case 38:
	        cardName = 'aceOfDiamonds';
	        break;
	        case 39:
	        cardName = 'kingOfDiamonds';
	        break;
	        case 40:
	        cardName = 'queenOfDiamonds';
	        break;
	        case 41:
	        cardName = 'jackOfDiamonds';
	        break;
	        case 42:
	        cardName = 'tenOfDiamonds';
	        break;
	        case 43:
	        cardName = 'nineOfDiamonds';
	        break;
	        case 44:
	        cardName = 'eightOfDiamonds';
	        break;
	        case 45:
	        cardName = 'sixOfDiamonds';
	        break;
	        case 46:
	        cardName = 'fiveOfDiamonds';
	        break;
	        default:
	        break;
	    }
	    return cardName;
	},


	toggleCardSelection: function(sprite) {
	    if (!sprite.isSelected) {
	        sprite.y = sprite.y - constants.SELECTED_CARD_Y_OFFSET;
	    } else {
	        sprite.y = sprite.y + constants.SELECTED_CARD_Y_OFFSET;
	    }
	    sprite.isSelected = !sprite.isSelected;
	},

	showPlayedCardsForUser: function(n, valuesOfPlayedCards) {
	    var startX, startY, userPlayedCards;
	    switch (n) {
	        case 0:         // current user
	        startX = globalVariables.screenWidth / 2 - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 8;
	        startY = globalVariables.screenHeight - 2 * globalVariables.scaledCardHeight - 2 * constants.MARGIN;
	        userPlayedCards = globalVariables.currentUserPlayedCards;
	        break;
	        case 1:         // the 1st user
	        startX = globalVariables.screenWidth - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 4 - constants.MARGIN;
	        startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2;
	        userPlayedCards = globalVariables.user1PlayedCards;
	        break;
	        case 2:         // the 2nd user
	        startX = globalVariables.screenWidth / 2 - (valuesOfPlayedCards.length + 3) * globalVariables.scaledCardWidth / 8;
	        startY = constants.MARGIN;
	        userPlayedCards = globalVariables.user2PlayedCards;
	        break;
	        case 3:         // the 3rd user
	        startX = constants.MARGIN;
	        startY = globalVariables.screenHeight / 2 - globalVariables.scaledCardHeight / 2;
	        userPlayedCards = globalVariables.user3PlayedCards;
	        break;
	        default:
	        break;
	    }
	    // remove played cards
	    var cardsToRemove = [];
	    for (var i = 0; i < userPlayedCards.children.length; i ++) {
	        cardsToRemove.push(userPlayedCards.children[i]);
	    }
	    for (i = 0; i < cardsToRemove.length; i ++) {
	        userPlayedCards.remove(cardsToRemove[i]);
	    }

	    for (i = 0; i < valuesOfPlayedCards.length; i ++) {
	        var playedCard = userPlayedCards.create(startX + i * globalVariables.scaledCardWidth / 4, startY, this.getCardName(valuesOfPlayedCards[i]));
	        playedCard.width = globalVariables.scaledCardWidth;
	        playedCard.height = globalVariables.scaledCardHeight;
	    }
	},
};
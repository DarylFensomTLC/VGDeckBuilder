//
//  VGDecksXMLParser.h
//  VGApp
//
//  Created by Daryl Fensom on 12/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGDeck.h"
#import "VGCard.h"
@interface VGDecksXMLParser : NSObject
{
    NSMutableString *currentElementValue;
    // user object
    
    VGDeck * deck;
    
    // array of user objects
    NSMutableArray * decks;
    NSMutableArray * cards;
    bool dealingWithExtraDeck;
}

@property (nonatomic,retain) VGDeck * deck;
@property (nonatomic,retain) NSMutableArray * decks;
@property (nonatomic,retain) NSMutableArray * cards;


-(VGDecksXMLParser*) initXMLParser;


@end

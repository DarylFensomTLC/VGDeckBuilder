//
//  VGCardsXMLParser.h
//  VGApp
//
//  Created by Daryl Fensom on 07/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VGCard;

@interface VGCardsXMLParser : NSObject
{
    NSMutableString *currentElementValue;
    // user object
    VGCard *card;
    // array of user objects
    NSMutableArray *cards;
}


@property (nonatomic, retain) VGCard *card;
@property (nonatomic, retain) NSMutableArray *cards;

- (VGCardsXMLParser *) initXMLParser;



@end

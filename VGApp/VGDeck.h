//
//  VGDeck.h
//  VGApp
//
//  Created by Daryl Fensom on 11/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VGDeck : NSObject
{
    NSMutableArray * cards;
    NSString * name;
}

@property (nonatomic, retain) NSMutableArray * cards;
@property (nonatomic, retain) NSMutableArray * cardsSets;
@property (nonatomic, retain) NSMutableArray * extraCards;
@property (nonatomic, retain) NSMutableArray * extraCardSets;
@property (nonatomic, retain) NSString * name;
@property NSInteger deckID;

@property (nonatomic, strong) NSMutableArray * xmlArray;

-(NSString*) toXML;


-(void)sortDeckByName;


-(int)getCardSetIDfrom:(int)inIndex;

-(int)getExtraCardSetIDfrom:(int)inIndex;

@end

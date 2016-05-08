//
//  VGDeck.m
//  VGApp
//
//  Created by Daryl Fensom on 11/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGDeck.h"
#import "VGCard.h"

@implementation VGDeck

@synthesize cards           = mCards;
@synthesize extraCards      = mExtraCards;
@synthesize extraCardSets   = mExtraCardSets;
@synthesize name            = mName;
@synthesize deckID          = mDeckID;
@synthesize cardsSets       = mCardsSets;
@synthesize xmlArray        = mXmlArray;

- (id)init
{
    self = [super init];
    if (self) {
        mCards = [[NSMutableArray alloc] init];
        mCardsSets = [[NSMutableArray alloc]init];
        mExtraCards = [[NSMutableArray alloc]init];
        mExtraCardSets = [[NSMutableArray alloc]init];
    }
    return self;
}


-(void) sortDeckByName
{
    [self sortCardArrayByName:mCards cardSetArray:mCardsSets];
    [self sortCardArrayByName:mExtraCards cardSetArray:mExtraCardSets];
}


-(void)sortCardArrayByName:(NSMutableArray*)cardArray cardSetArray:(NSMutableArray*)cardSetArray{
    for (int i = 0; i < cardArray.count; i++)
    {
        for(int j = 0; j < cardArray.count; j++)
        {
            if(i  != j)
            {
                VGCard * cardOne = [cardArray objectAtIndex:i];
                VGCard * cardTwo = [cardArray objectAtIndex:j];
                
                
                
                if([cardOne.Name localizedCompare:cardTwo.Name] == -1)
                {
                    [cardArray replaceObjectAtIndex:i withObject:cardTwo];
                    [cardArray replaceObjectAtIndex:j withObject:cardOne];
                    
                    if(cardSetArray.count == cardArray.count)
                    {
                        NSString *cardOneSet = [cardSetArray objectAtIndex:i];
                        NSString * cardTwoSet = [cardSetArray objectAtIndex:j];
                        
                        [cardSetArray replaceObjectAtIndex:i withObject:cardTwoSet];
                        [cardSetArray replaceObjectAtIndex:j withObject:cardOneSet];
                    }
                    
                }
                
                
            }
            
        }
    }

}

-(NSString*) toXML
{
   mXmlArray = [[NSMutableArray alloc] init];
    
    [mXmlArray addObject: @"<Deck>"];
    [mXmlArray addObject: [NSString stringWithFormat:@"<Name>%@",mName]];
    [mXmlArray addObject: @"</Name>"];
    
    for (int i = 0; i < mCards.count; i++)
    {
        VGCard * tempCard = [mCards objectAtIndex:i];
        NSString * tempSet = [mCardsSets objectAtIndex:i];
        
        [mXmlArray addObject: [NSString stringWithFormat:@"<Card>%@",tempCard.Name]];
        [mXmlArray addObject: @"</Card>"];
        [mXmlArray addObject: [NSString stringWithFormat:@"<Set>%@",tempSet]];
        [mXmlArray addObject: @"</Set>"];
    }
    
        [mXmlArray addObject: @"</Deck>"];
        [mXmlArray addObject: @"<ExtraDeck>"];
        for (int i = 0; i < mExtraCards.count; i++)
        {
            VGCard * tempExtraCard = [mExtraCards objectAtIndex:i];
            NSString * tempExtraSet = [mExtraCardSets objectAtIndex:i];
        
            [mXmlArray addObject: [NSString stringWithFormat:@"<Card>%@",tempExtraCard.Name]];
            [mXmlArray addObject: @"</Card>"];
            [mXmlArray addObject: [NSString stringWithFormat:@"<Set>%@",tempExtraSet]];
            [mXmlArray addObject: @"</Set>"];
        }

        [mXmlArray addObject: @"</ExtraDeck>"];
    
    NSString * xmlString    =   [mXmlArray componentsJoinedByString:@""];
    
    return xmlString;
}

-(int)getCardSetIDfrom:(int)inIndex
{
    return [[mCardsSets objectAtIndex:inIndex] intValue];
}

-(int)getExtraCardSetIDfrom:(int)inIndex
{
    return [[mExtraCardSets objectAtIndex:inIndex] intValue];
}

@end

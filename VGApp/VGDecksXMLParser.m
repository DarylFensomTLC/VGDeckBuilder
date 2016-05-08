//
//  VGDecksXMLParser.m
//  VGApp
//
//  Created by Daryl Fensom on 12/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGDecksXMLParser.h"

@implementation VGDecksXMLParser

@synthesize decks,cards,deck;

-(VGDecksXMLParser*) initXMLParser
{
    decks = [[NSMutableArray alloc] init];
    dealingWithExtraDeck = false;
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"Deck"]) {
        
        deck = [[VGDeck alloc] init];
        
        dealingWithExtraDeck = false;
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here:
        // user.att = [[attributeDict objectForKey:@"<att name>"] ...];
    }
    
    if ([elementName isEqualToString:@"ExtraDeck"])
    {
        dealingWithExtraDeck = true;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentElementValue) {
        // init the ad hoc string with the value
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        // append value to the ad hoc string
        [currentElementValue appendString:string];
    }
    //NSLog(@"Processing value for : %@", string);
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"Decks"]) {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:@"Deck"]) {
        // We are done with user entry – add the parsed user
        // object to our user array
       
        
        
    }
    
    
    

    
    if ([elementName isEqualToString:@"Name"]){
        // The parser hit one of the element values.
        // This syntax is possible because User object
        // property names match the XML user element names
        [deck setValue:currentElementValue forKey:elementName];
    }
    
    if([elementName isEqualToString:@"Card"])
    {
        VGCard * newCard = [self getCardByName:currentElementValue];
        if(newCard != nil)
        {
            if(dealingWithExtraDeck)
            {
                [deck.extraCards addObject:newCard];
            }
            else
            {
                [deck.cards addObject:newCard];
            }
            
        }
    }
    
    if([elementName isEqualToString:@"Set"])
    {
        NSString *  set = currentElementValue;
        if(dealingWithExtraDeck)
        {
            [deck.extraCardSets addObject:set];
        }
        else
        {
            [deck.cardsSets addObject:set];
        }
        
    }
    
    if([elementName isEqualToString:@"ExtraDeck"])
    {
         [self createNewDeck];
    }
    
    
    currentElementValue = nil;
}

-(void)createNewDeck
{
    if (deck.cards.count != deck.cardsSets.count)
    {
        for(int i = 0; i < deck.cards.count; i++)
        {
            [deck.cardsSets addObject:@"0"];
        }
    }
    
    [decks addObject:deck];
    deck.deckID = decks.count -1;
    // release user object
    
    deck = nil;
    
}

-(VGCard*)getCardByName:(NSString*) inCardName
{
    VGCard *returnCard;
    
    for (int i = 0; i < cards.count; i++)
    {
        VGCard * tempCard  =  [cards objectAtIndex:i];
        if([tempCard.Name isEqual:inCardName])
        {
            returnCard = tempCard;
            //Break the loop
            i = cards.count;
            return returnCard;
        }
    }
    
    return returnCard;
}




@end

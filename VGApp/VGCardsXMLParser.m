//
//  VGCardsXMLParser.m
//  VGApp
//
//  Created by Daryl Fensom on 07/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGCardsXMLParser.h"
#import "VGCard.h"

@implementation VGCardsXMLParser

@synthesize card, cards;

- (VGCardsXMLParser *) initXMLParser {
       // init array of user objects
    cards = [[NSMutableArray alloc] init];
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:@"Card"]) {
       
        card = [[VGCard alloc] init];
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here:
        // user.att = [[attributeDict objectForKey:@"<att name>"] ...];
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
    
    if ([elementName isEqualToString:@"Cards"]) {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:@"Card"]) {
        // We are done with user entry – add the parsed user
        // object to our user array
        [card determineTriggerType];
        [cards addObject:card];
        // release user object
        
        card = nil;
    } else {
        // The parser hit one of the element values.
        // This syntax is possible because User object
        // property names match the XML user element names
        [card setValue:currentElementValue forKey:elementName];
    }
    
    
    currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Error %i, Description: %@, Line: %i, Column: %i", [parseError code],
          [[parser parserError] localizedDescription], [parser lineNumber],
          [parser columnNumber]);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError{
    NSLog(@"valid: %@", validError);
}



@end

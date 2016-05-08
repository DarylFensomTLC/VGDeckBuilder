//
//  VGImageToGrab.m
//  Deckbuilder
//
//  Created by Daryl Fensom on 02/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGImageToGrab.h"

@implementation VGImageToGrab


@synthesize cardImageURL = mCardImageURL;
@synthesize card         =  mCard;
@synthesize tableView = mTableView;
@synthesize cardCell = mCardCell;

-(id)initWithCard: (VGCard*)card cardCell:(VGCardCell*)inCardCell  tableView:(UITableView*)inTableView
{
    mCardCell = inCardCell;
    mCard = card;
    mTableView = inTableView;
    return self;
}


@end

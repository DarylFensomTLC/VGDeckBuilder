//
//  VGImageToGrab.h
//  Deckbuilder
//
//  Created by Daryl Fensom on 02/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGCard.h"
#import "VGCardCell.h"


@interface VGImageToGrab : NSObject

@property (strong, nonatomic) VGCardCell * cardCell;
@property (strong, nonatomic) NSString * cardImageURL;
@property (strong, nonatomic) VGCard * card;

@property (strong, nonatomic) UITableView * tableView;

-(id)initWithCard: (VGCard*)card cardCell:(VGCardCell*)inCardCell  tableView:(UITableView*)inTableView;

@end

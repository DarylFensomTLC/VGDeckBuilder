//
//  VGCardCell.h
//  Deckbuilder
//
//  Created by Daryl Fensom on 02/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VGCardCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *cardImageView;


@property (retain, nonatomic) IBOutlet UILabel *lblName;

@property (retain, nonatomic) IBOutlet UILabel *lblGrade;
@property (retain, nonatomic) IBOutlet UILabel *lblClan;

@property (retain, nonatomic) IBOutlet UILabel *lblTrigger;

@property (retain, nonatomic) IBOutlet UILabel *lblStats;
@property (retain, nonatomic) IBOutlet UILabel *lblEffect;

-(void) setCardName:(NSString*)inName;

-(void) setGrade:(NSString*)inGrade;

-(void) setClan:(NSString*)inClan;

-(void) setTrigger:(NSString*)inTrigger;

-(void) setStats:(NSString*)inPower defense:(NSString*)inDefense;

-(void) setEffect:(NSString*)inEffect;

-(void) resetCell;


@property (strong, nonatomic) UIActivityIndicatorView * activityIndicator;
@end

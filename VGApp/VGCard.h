//
//  VGCard.h
//  VGApp
//
//  Created by Daryl Fensom on 07/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VGCard : NSObject
{
    int _ID;
    NSString * mName;
    NSString * mImageLocation;
    NSString * mTrigger;
    NSString * mGrade;
    NSString * mPower;
    NSString * mShield;
    NSString * mClan;
    NSString * mEffect;
    NSString * mSet;
    NSInteger triggerType;
    
}

@property (nonatomic) int ID;
@property (nonatomic,retain) NSString *Name;
@property (nonatomic,retain) NSString *ImageLocation;
@property (nonatomic,retain) NSString *Trigger;
@property (nonatomic,retain) NSString *Grade;
@property (nonatomic,retain) NSString *Power;
@property (nonatomic,retain) NSString *Shield;
@property (nonatomic,retain) NSString *Clan;
@property (nonatomic,retain) NSString *Effect;
@property (nonatomic,retain) NSString *Set;

@property (nonatomic, strong)
NSString * localCardImageLocation;

@property NSInteger triggerType;


-(NSString *) toXML;
-(NSString *) toJSON;
-(NSInteger) getGrade;
-(void)determineTriggerType;
-(NSString*) getImageURL:(NSInteger)size;
-(NSArray*) getSetArray;

@end

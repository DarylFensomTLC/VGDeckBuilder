 //
//  VGCard.m
//  VGApp
//
//  Created by Daryl Fensom on 07/05/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGCard.h"
#import "SBJsonParser.h"

@implementation VGCard

@synthesize Name            =   mName;
@synthesize ImageLocation   =   mImageLocation;
@synthesize Trigger         =   mTrigger;
@synthesize Grade           =   mGrade;
@synthesize Power           =   mPower;
@synthesize Shield          =   mShield;
@synthesize Clan            =   mClan;
@synthesize Effect          =   mEffect;
@synthesize Set             =   mSet;
@synthesize triggerType     =   mTriggerType;
@synthesize localCardImageLocation = mLocalCardImageLocation;

-(void)determineTriggerType
{
    mTriggerType = 0;
    
    if([mTrigger rangeOfString:@"Heal" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        mTriggerType = 1;
    }
    
    
    if([mTrigger rangeOfString:@"Draw" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        mTriggerType = 2;
    }
    
    if([mTrigger rangeOfString:@"Critical" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        mTriggerType =   3;
    }
    
    if([mTrigger rangeOfString:@"Stand" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        mTriggerType =   4;
    }
    
}

-(NSInteger)getGrade
{
    
    if([mGrade rangeOfString:@"0" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        return 0;
    }
    
    if([mGrade rangeOfString:@"1" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        return  1;
    }
    
    
    if([mGrade rangeOfString:@"2" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        return  2;
    }
    
    if([mGrade rangeOfString:@"3" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        return    3;
    }
    
    if([mGrade rangeOfString:@"4" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        return    4;
    }
    
    return 0;
    
}

-(NSString*) toXML
{
    NSMutableArray * xmlArray = [[NSMutableArray alloc] init];
    
    [xmlArray addObject: @"<Card>"];
    [xmlArray addObject: [NSString stringWithFormat:@"<Name>%@",mName]];
    [xmlArray addObject: @"</Name>"];
    [xmlArray addObject: [NSString stringWithFormat:@"<ImageLocation>%@",mImageLocation]];
    [xmlArray addObject: @"</ImageLocation>"];
    [xmlArray addObject: [NSString stringWithFormat:@"<Trigger>%@",mTrigger]];
    [xmlArray addObject: @"</Trigger>"];
    [xmlArray addObject: [NSString stringWithFormat:@"<Grade>%@",mGrade]];
    [xmlArray addObject: @"</Grade>"];
    [xmlArray addObject: [NSString stringWithFormat:@"<Power>%@",mPower]];
    [xmlArray addObject: @"</Power>"];
    [xmlArray addObject: [NSString stringWithFormat:@"<Shield>%@",mShield]];
    [xmlArray addObject: @"</Shield>"];
    [xmlArray addObject: [NSString stringWithFormat:@"<Clan>%@",mClan]];
    [xmlArray addObject: @"</Clan>"];
    [xmlArray addObject: [NSString stringWithFormat:@"<Effect>%@",mEffect]];
    [xmlArray addObject: @"</Effect>"];
    [xmlArray addObject: [NSString stringWithFormat:@"<Set>%@",mSet]];
    [xmlArray addObject: @"</Set>"];
    [xmlArray addObject: @"</Card>"];
    
    NSString * xmlString    =   [xmlArray componentsJoinedByString:@""];
    
    return xmlString;
}

-(NSString*) toJSON
{
    NSMutableArray * JSONArray = [[NSMutableArray alloc] init];
    
    [JSONArray addObject:@"{"];
    [JSONArray addObject:[NSString stringWithFormat:@"\"Name\":\"%@\",",mName]];
    [JSONArray addObject:[NSString stringWithFormat:@"\"ImageLocation\":\"%@\",",mImageLocation]];
    [JSONArray addObject:[NSString stringWithFormat:@"\"Trigger\":\"%@\",",mTrigger]];
    [JSONArray addObject:[NSString stringWithFormat:@"\"Grade\":\"%@\",",mGrade]];
    [JSONArray addObject:[NSString stringWithFormat:@"\"Power\":\"%@\",",mPower]];
    [JSONArray addObject:[NSString stringWithFormat:@"\"Shield\":\"%@\",",mShield]];
    [JSONArray addObject:[NSString stringWithFormat:@"\"Clan\":\"%@\",",mClan]];
    [JSONArray addObject:[NSString stringWithFormat:@"\"Effect\":\"%@\",",mEffect]];
    [JSONArray addObject:[NSString stringWithFormat:@"\"Set\":\"%@\"",mSet]];
    [JSONArray addObject:@"}"];
    
    NSString * JSONString     =   [JSONArray componentsJoinedByString:@""];
    
    return JSONString;
}

-(NSString *) getImageURL:(NSInteger)size
{
    NSString * imageURL = @"";
    NSString * cardArticleId = @"";
    
    
    
    NSString * cardNameFixed = [mName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    
    
    cardNameFixed = [cardNameFixed stringByReplacingOccurrencesOfString:@"PR?ISM" withString:@"PR%E2%99%A5ISM"];
    
    
    const char *ch = [cardNameFixed cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSString *decode_string = [[NSString alloc]initWithCString:ch encoding:NSUTF8StringEncoding];
    
    NSString * grabPageIDURL = [NSString stringWithFormat:@"http://www.cardfight.wikia.com/api.php?action=query&prop=revisions&rvprop=content&format=json&titles=%@",decode_string];
    
    
    //Make the request to find the id of the article
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:grabPageIDURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
    
    NSURLResponse  *response;
    NSError *error;
    
    NSData *urlData             =   [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    NSString *data                   =   [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    NSArray * splitData = [data componentsSeparatedByString:@"pageid"];
    
    if(splitData.count < 2)
    {
        return mImageLocation;
    }
    
    NSArray * splitData2 = [[splitData objectAtIndex:1] componentsSeparatedByString:@","];
    //dictionary search
    
    
    
    NSString * cardID = [splitData2 objectAtIndex:0];
    cardID = [cardID stringByReplacingOccurrencesOfString:@"\":" withString:@""];
    
    NSString *imageCropperURL = [NSString stringWithFormat:@"http://cardfight.wikia.com/api.php?action=imagecrop&format=json&imgSize=%d&imgId=%@",size,cardID];
    
    NSURLRequest *request2=[NSURLRequest requestWithURL:[NSURL URLWithString:imageCropperURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
    
    NSURLResponse  *response2;
    NSError *error2;
    
    NSData *urlData2             =   [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response error:&error];
    
    NSString *data2                  =   [[NSString alloc] initWithData:urlData2 encoding:NSASCIIStringEncoding];
    
    NSArray * cardCropArray = [data2 componentsSeparatedByString:@"imagecrop\":\""];
    
    if(cardCropArray.count > 1)
    {
        NSArray * cardCropArray2 = [[cardCropArray objectAtIndex:1] componentsSeparatedByString:@"\"},"];
        
        NSString * cardImageLocation = [cardCropArray2 objectAtIndex:0];
        cardImageLocation = [cardImageLocation stringByReplacingOccurrencesOfString:@"\\" withString:@""];
         return cardImageLocation;
    }
    else{
        
    }
    
  
    return mImageLocation;
    
   
    
}

-(NSArray*)getSetArray
{
    return [mSet componentsSeparatedByString:@"||"];

}



@end

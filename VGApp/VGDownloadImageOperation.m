//
//  VGDownloadImageOperation.m
//  Deckbuilder
//
//  Created by Daryl Fensom on 06/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import "VGDownloadImageOperation.h"

@implementation VGDownloadImageOperation
@synthesize imageToGrabObject = mImageToGrabObject;

-(id)initWithImageTograbObject:(VGImageToGrab*)imageToGrab
{
    if (![super init]) return nil;
    mImageToGrabObject = imageToGrab;
    return self;
}

- (void)main {
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* foofile = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[mImageToGrabObject.card.Name stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    
    
        
        
        
        if(fileExists)
        {
            UIImage *mCardImage = [UIImage imageWithContentsOfFile:foofile];
            //[mImageToGrabObject.cardCell.imageView setImage:mCardImage];
            
        }
        else
        {
            
                
                
                NSString * imageGrabURL = [mImageToGrabObject.card getImageURL:100];
                
                
                    
                    
                    UIImage * mCardImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageGrabURL]]];
                    
                    
                    //[mImageToGrabObject.cardCell.imageView setImage:mCardImage];
                    
                    
                    
                    NSData *imgData = UIImagePNGRepresentation(mCardImage);
                    // Identify the home directory and file name
                    NSString  *jpgPath = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[mImageToGrabObject.card.Name stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
                    
                    
                    [imgData writeToFile:jpgPath atomically:NO];
                }
            
            
            
        
        
        
        NSArray *viewsToRemove = [mImageToGrabObject.cardCell.imageView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
    
}


@end

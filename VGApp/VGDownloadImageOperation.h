//
//  VGDownloadImageOperation.h
//  Deckbuilder
//
//  Created by Daryl Fensom on 06/08/2013.
//  Copyright (c) 2013 Daryl Fensom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGImageToGrab.h"

@interface VGDownloadImageOperation : NSOperation


@property (strong, nonatomic) VGImageToGrab * imageToGrabObject;


-(id)initWithImageTograbObject:(VGImageToGrab*)imageToGrab;

@end

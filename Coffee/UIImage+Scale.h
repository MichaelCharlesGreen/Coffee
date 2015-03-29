//
//  UIImage+Scale.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  Scale an image for either MasterImageSize or DetailImageSize
//  See HelperTypes.h

#import <UIKit/UIKit.h>
#import "HelperTypes.h"

@interface UIImage (Scale)
- (UIImage *)scaleToDisplaySize:(ImageDisplaySize)imageDisplaySize;
@end

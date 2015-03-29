//
//  UIColor+HexColors.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  Returns an UIColor from a hex color format.

#import <UIKit/UIKit.h>

@interface UIColor (HexColors)
+ (UIColor *)colorFromHexString:(NSString *)hexString;
@end

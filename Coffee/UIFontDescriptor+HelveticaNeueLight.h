//
//  UIFontDescriptor+HelveticaNeueLight.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  Dynamic Type fonts for use in the app.

#import <UIKit/UIKit.h>

extern NSString *const AppFontTextStyleCellDescription;
extern NSString *const AppFontTextStyleCellLargeName;

@interface UIFontDescriptor (HelveticaNeueLight)
+ (UIFontDescriptor *)preferredHelveticaNeueLightFontDescriptorWithTextStyle:(NSString *)style;
+ (UIFontDescriptor *)preferredHelveticaNeueLightItalicFontDescriptorWithTextStyle:(NSString *)style;
@end

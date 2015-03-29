//
//  UIButton+Title.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  Returns the button used in the navbar and social sharing controller.
//  Configurable with a title.
//  Returns an orange button with a white border.

#import <UIKit/UIKit.h>

@interface UIButton (Title)
+ (UIButton *)buttonWithTitle:(NSString *)title;
@end

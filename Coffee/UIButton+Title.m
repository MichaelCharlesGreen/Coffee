//
//  UIButton+Title.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "UIButton+Title.h"
#import "Design.h"

@implementation UIButton (Title)

// Returns an orange button with a white border.
+ (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *button = nil;
    
    title = [NSString stringWithFormat:@"  %@  ", title];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [[UIButton appearance].titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // TODO:mg hacky - fix this
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    
    CGSize buttonBackgroundSize = [button backgroundRectForBounds:button.bounds].size;
    buttonBackgroundSize.width = buttonBackgroundSize.width;
    
    // Create background image for button.
    CGRect outerRect = CGRectMake(0.0f, 0.0f, buttonBackgroundSize.width, buttonBackgroundSize.height);
    UIGraphicsBeginImageContext(buttonBackgroundSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, outerRect);
    
    CGRect innerRect = CGRectInset(outerRect, 2.0, 2.0);
    CGContextSetFillColorWithColor(context, [[Design orangeColor] CGColor]);
    CGContextFillRect(context, innerRect);
    
    UIImage *buttonBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    
    return button;
}

// Helper
- (UIImage *)createButtonBackgroundImageForSize:(CGSize)buttonBackgroundSize
{
    CGRect outerRect = CGRectMake(0.0f, 0.0f, buttonBackgroundSize.width, buttonBackgroundSize.height);
    UIGraphicsBeginImageContext(buttonBackgroundSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, outerRect);
    
    CGRect innerRect = CGRectInset(outerRect, 2.0, 2.0);
    CGContextSetFillColorWithColor(context, [[UIColor orangeColor] CGColor]);
    CGContextFillRect(context, innerRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

//
//  Design.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "Design.h"
#import "UIColor+HexColors.h"

@implementation Design

+ (UIColor *)orangeColor
{
    return [UIColor colorFromHexString:@"#F16421"];
}

+ (UIColor *)lightGrayColor
{
    return [UIColor colorFromHexString:@"#AAAAAA"];
}

+ (UIColor *)darkGrayColor
{
    return [UIColor colorFromHexString:@"#666666"];
}

@end

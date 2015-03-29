//
//  CoffeeMasterModel.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "CoffeeMasterModel.h"

@implementation CoffeeMasterModel

// Used with Mantle to map objects.
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"identifier":@"id",
             @"shortDescription":@"desc",
             @"imageURLString":@"image_url"
             };
}

@end

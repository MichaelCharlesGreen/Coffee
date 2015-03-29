//
//  CoffeeDetailModel.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "CoffeeDetailModel.h"

@implementation CoffeeDetailModel

// Used with Mantle to map objects.
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"identifier":@"id",
             @"detailDescription":@"desc",
             @"imageURLString":@"image_url",
             @"lastUpdatedAt":@"last_updated_at"
             };
}

@end

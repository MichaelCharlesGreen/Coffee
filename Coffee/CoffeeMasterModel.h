//
//  CoffeeMasterModel.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  Model for Coffee displayed in CoffeeMasterTableViewController

#import <Foundation/Foundation.h>

@interface CoffeeMasterModel : MTLModel <MTLJSONSerializing>
@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *shortDescription;
@property (copy, nonatomic) NSString *imageURLString;
@property (strong, nonatomic) UIImage *image; // to cache image //TODO:mg change to real cache
@end

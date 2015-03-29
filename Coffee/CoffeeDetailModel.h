//
//  CoffeeDetailModel.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  Model for information displayed in CoffeeDetailTableViewController

#import "MTLJSONAdapter.h"

@interface CoffeeDetailModel : MTLModel <MTLJSONSerializing>
@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *detailDescription;
@property (copy, nonatomic) NSString *imageURLString;
@property (copy, nonatomic) NSString *lastUpdatedAt;
@property (strong, nonatomic) UIImage *image; // to cache image //TODO:mg change
@end

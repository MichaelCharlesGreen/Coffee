//
//  CoffeeMasterTableViewCell.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  Table view cell for the main table view controller, CoffeeMasterTableViewController.

#import <UIKit/UIKit.h>

extern NSString * const MasterCellIdentifier;

@interface CoffeeMasterTableViewCell : UITableViewCell
// display coffee name
@property (strong, nonatomic) UILabel *itemNameLabel;
// display a short description of the coffee
@property (strong, nonatomic) UILabel *itemDescriptionLabel;
// display an image of the coffee
@property (strong, nonatomic) UIImageView *itemImageView;
// Sets the Dynamic Type used in the cell.
- (void)updateFonts;
@end

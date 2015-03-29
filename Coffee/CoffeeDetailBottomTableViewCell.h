//
//  CoffeeDetailBottomTableViewCell.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  This is the bottom cell in the CoffeeDetailTableViewController.

#import <UIKit/UIKit.h>

extern NSString * const BottomDetailCellIdentifier;

@interface CoffeeDetailBottomTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *itemDescriptionLabel;
@property (strong, nonatomic) UIImageView *itemImageView;
@property (strong, nonatomic) UILabel *lastUpdatedAtLabel;
- (void)updateFonts;
@end

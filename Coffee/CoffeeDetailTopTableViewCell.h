//
//  CoffeeDetailTopTableViewCell.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  This is the top cell displayed in the CoffeeDetailTableViewController.

#import <UIKit/UIKit.h>

extern NSString * const TopDetailCellIdentifier;

@interface CoffeeDetailTopTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *itemNameLabel;
- (void)updateFonts;
@end

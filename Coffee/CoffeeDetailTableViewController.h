//
//  CoffeeDetailTableViewController.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  View controller for Detail Coffee.

#import <UIKit/UIKit.h>

@interface CoffeeDetailTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString *coffeeID;
@end

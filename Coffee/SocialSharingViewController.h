//
//  SocialSharingViewController.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  Displays view with options for sharing information on social media.

#import <UIKit/UIKit.h>

@class CoffeeDetailModel;
@interface SocialSharingViewController : UIViewController
@property (strong, nonatomic) CoffeeDetailModel *modelToShare;
@end

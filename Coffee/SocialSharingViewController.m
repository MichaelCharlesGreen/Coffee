//
//  SocialSharingViewController.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "SocialSharingViewController.h"
#import "Design.h"
#import "UIButton+Title.h"
#import <Social/Social.h>
#import "CoffeeDetailModel.h"
#import "Alert.h"

#define kViewHorizontalInsets 15.0f
#define kViewVerticalInsets 10.0f

@interface SocialSharingViewController () <UIAccelerometerDelegate>
@property (strong, nonatomic) UIButton *twitterButton;
@property (strong, nonatomic) UIButton *facebookButton;
@end

@implementation SocialSharingViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.twitterButton addTarget:self action:@selector(onTwitter:) forControlEvents:UIControlEventTouchUpInside];
    [self.facebookButton addTarget:self action:@selector(onFacebook:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [Design orangeColor];
    self.view = contentView;
    
    self.twitterButton = [UIButton buttonWithTitle:@"TWITTER"];
    [self.twitterButton setTranslatesAutoresizingMaskIntoConstraints:NO]; //TODO:mg is this necessary
    
    self.facebookButton = [UIButton buttonWithTitle:@"FACEBOOK"];
    [self.facebookButton setTranslatesAutoresizingMaskIntoConstraints:NO]; //TODO:mg is this necessary
    
    [self.view addSubview:self.twitterButton];
    [self.view addSubview:self.facebookButton];
    
    [UIView autoSetPriority:999 forConstraints:^{
        [self.twitterButton autoCenterInSuperview];
        [self.facebookButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.twitterButton];
        [self.facebookButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.twitterButton withOffset:kViewVerticalInsets*4 relation:NSLayoutRelationEqual];
    }];
}

#pragma mark - Action
- (void)onTwitter:(id)sender
{
    BOOL isTwitterAvailable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    
    if (isTwitterAvailable) {
        [self shareOnSocialMedia:SLServiceTypeTwitter];
    } else {
        // Display alert
        AlertWithTitleAndMessageAndDelegate(@"Twitter", @"Please add Twitter account in Settings", self);
    }
}

- (void)onFacebook:(id)sender
{
    BOOL isFacebookAvailable = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    
    if (isFacebookAvailable) {
        [self shareOnSocialMedia:SLServiceTypeFacebook];
    } else {
        // Display alert
        AlertWithTitleAndMessageAndDelegate(@"Facebook", @"Please add Facebook account in Settings", self);
    }
}

#pragma mark - Helper
// Shares coffee information on chosen social media platform.
- (void)shareOnSocialMedia:(NSString *)serviceType
{
    // Check again for availability (future-proofing).
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        __block BOOL userSharedInformation = NO;
        SLComposeViewController *sharingSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        // Ensure that any UI updates occur on the main queue.
        sharingSheet.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                //  User cancelled action.
                case SLComposeViewControllerResultCancelled:
                    userSharedInformation = NO;
                    break;
                // User posted information.
                case SLComposeViewControllerResultDone:
                    userSharedInformation = YES;
                    break;
            }
            
            //  Dismiss the sharingSheet whether the user shared or cancelled.
            // They will be returned to the CoffeeDetailTableViewController view.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        };
        [sharingSheet setInitialText:[self coffeeInformationToShare]];
//        [sharingSheet addImage:[UIImage imageNamed:@""]]; // TODO:mgadd image
//        [sharingSheet addURL:[NSURL URLWithString:@""]]; // TODO:mg add URL
        [self presentViewController:sharingSheet animated:YES completion:nil];
    }
}

// This method returns the coffee information to share on social media.
- (NSString *)coffeeInformationToShare
{
    return [NSString stringWithFormat:@"Check out\n%@\n%@.", self.modelToShare.name, self.modelToShare.detailDescription];
}

#pragma mark - UIAlertViewDelegate
// Dismiss this controller when the user dismisses the alertview informing them
// that they have to add the appropriate social media account in Settings, before
// sharing.
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Will be sent to the presenting view controller...
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

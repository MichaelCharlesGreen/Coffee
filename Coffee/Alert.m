//
//  Alert.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "Alert.h"

void AlertWithTitleAndMessageAndDelegate(NSString *title, NSString *message, id delegate)
{
    // open an alert with OK and Cancel buttons
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
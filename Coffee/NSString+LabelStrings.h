//
//  NSString+LabelStrings.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  Modify a string from the service call to match the date format specified in
//  the design. Last updated 2 week ago - etc.

#import <Foundation/Foundation.h>

@interface NSString (LabelStrings)
- (NSString *)toLastUpdatedAtString;
@end

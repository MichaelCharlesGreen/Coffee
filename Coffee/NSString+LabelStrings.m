//
//  NSString+LabelStrings.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "NSString+LabelStrings.h"

@implementation NSString (LabelStrings)

// This method returns the string for the lastUpdatedAt label.
// It will be in the form:
// Last update (time duration value) ago
// If the helper method is called sequentially (EXHAUSTIVE_TIME_FORMAT) with values,
// the form will be:
// Last update 1 year, 2 months, 3 weeks, 1 day, 4 hours, 3 minutes ago
- (NSString *)toLastUpdatedAtString
{
    NSString *desiredLabelString = nil;
    
    NSString * const format = @"yyyy-MM-dd H:mm:ss.SSSSSS";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:format];
    NSDate *dateOutput = [dateFormatter dateFromString:self];
    
    NSTimeInterval timeInterval = fabs([dateOutput timeIntervalSinceNow]);
    
    // Get the system calendar
    NSCalendar *systemCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSWeekOfMonthCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *breakdownInfo = [systemCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];

    NSInteger years = [breakdownInfo year];
    NSInteger months = [breakdownInfo month];
    NSInteger weeks = [breakdownInfo weekOfMonth];
    NSInteger days = [breakdownInfo day];
    NSInteger hours = [breakdownInfo hour];
    NSInteger minutes = [breakdownInfo minute];

    NSMutableString *mutableString = [NSMutableString string];
    NSDictionary *timeDict = @{@"years" : [NSNumber numberWithLong:years],
                               @"months" : [NSNumber numberWithLong:months],
                               @"weeks" : [NSNumber numberWithLong:weeks],
                               @"days" : [NSNumber numberWithLong:days],
                               @"hours" : [NSNumber numberWithLong:hours],
                               @"minutes" : [NSNumber numberWithLong:minutes]};
    
    // Calling updateLabelString:timeDict:forKey: in this manner, will produce
    // a result, which only returns the highest-order time, i.e. if results
    // exist for years, months, weeks, days, hours and minutes, only the years
    // will be included in the string for the label.
    // However, if updateLabelString:timeDict:forKey: is called in succession
    // for years, months, weeks, days, hours, minutes, (EXHAUSTIVE_TIME_FORMAT)
    // a string of the form
    // Last updated 1 year, 11 months, 5 days, 1 minute ago
    // will be produced (for example)
//#define EXHAUSTIVE_TIME_FORMAT
#ifndef EXHAUSTIVE_TIME_FORMAT
    if (years > 0) {
        [self updateLabelString:mutableString timeDict:timeDict forKey:@"years"];
    } else if (months > 0) {
        [self updateLabelString:mutableString timeDict:timeDict forKey:@"months"];
    } else if (weeks > 0) {
        [self updateLabelString:mutableString timeDict:timeDict forKey:@"weeks"];
    } else if (days > 0) {
        [self updateLabelString:mutableString timeDict:timeDict forKey:@"days"];
    } else if (hours > 0) {
        [self updateLabelString:mutableString timeDict:timeDict forKey:@"hours"];
    } else if (minutes > 0) {
        [self updateLabelString:mutableString timeDict:timeDict forKey:@"minutes"];
    }
#endif
#ifdef EXHAUSTIVE_TIME_FORMAT
    [self updateLabelString:mutableString timeDict:timeDict forKey:@"years"];
    [self updateLabelString:mutableString timeDict:timeDict forKey:@"months"];
    [self updateLabelString:mutableString timeDict:timeDict forKey:@"weeks"];
    [self updateLabelString:mutableString timeDict:timeDict forKey:@"days"];
    [self updateLabelString:mutableString timeDict:timeDict forKey:@"hours"];
    [self updateLabelString:mutableString timeDict:timeDict forKey:@"minutes"];
#endif
    
    desiredLabelString = [NSString stringWithFormat:@"Updated %@ ago", mutableString];
    
    return desiredLabelString;
}

- (NSMutableString *)updateLabelString:(NSMutableString *)mutableString timeDict:(NSDictionary *)timeDict forKey:(NSString *)key
{
    NSArray *orderedPluralKeysArray = @[@"years", @"months", @"weeks", @"days", @"hours", @"minutes"];
    NSArray *orderedSingularKeysArray = @[@"year", @"month", @"week", @"day", @"hour", @"minute"];
    
    NSInteger valueForKey = [timeDict[key] longValue];
    NSInteger valueForNextLowerKey = 0;
    
    NSUInteger keyIndex = [orderedPluralKeysArray indexOfObject:key];
    NSUInteger lowerKeyIndex = 0;
    
    if (keyIndex > 0) {
        lowerKeyIndex = keyIndex - 1;
        valueForNextLowerKey = [timeDict[orderedPluralKeysArray[lowerKeyIndex]] longValue];
    }
//    NSLog(@"orderedPluralKeysArray[keyIndex]%@", orderedPluralKeysArray[keyIndex]);
//    NSLog(@"keyIndex: %lu lowerKeyIndex: %lu", (unsigned long)keyIndex, (unsigned long)lowerKeyIndex);
//    NSLog(@"valueForKey: %lu valueForNextLowerKey: %lu", (unsigned long)valueForKey, (unsigned long)valueForNextLowerKey);
   
    NSString *resultString = nil;
    if (valueForKey > 0) {
        if (valueForKey > 1) {
            if (valueForNextLowerKey > 0) {
                resultString = [NSString stringWithFormat:@", %ld %@", (long)valueForKey, orderedPluralKeysArray[keyIndex]];
            } else {
                resultString = [NSString stringWithFormat:@"%ld %@", (long)valueForKey, orderedPluralKeysArray[keyIndex]];
            }
        } else {
            if (valueForNextLowerKey > 0) {
                resultString = [NSString stringWithFormat:@", %ld %@", (long)valueForKey, orderedSingularKeysArray[keyIndex]];
            } else {
                resultString = [NSString stringWithFormat:@"%ld %@", (long)valueForKey, orderedSingularKeysArray[keyIndex]];
            }
        }
        [mutableString appendString:resultString];
    }

//    NSLog(@"mutableString: %@\n\n", mutableString);
    return mutableString;
}

@end

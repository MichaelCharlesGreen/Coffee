//
//  HTTPManager.h
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//
//  HTTP manager for accessing a remote HTTP service.

#import <Foundation/Foundation.h>

@interface HTTPManager : AFHTTPSessionManager

+ (HTTPManager *)sharedHTTPManager;
// Request Coffee data to start the app.
- (void)getCoffeesSuccess:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

// Request Coffee detail using information from getCoffees:failure: response.
- (void)getCoffeeForID:(NSString *)coffeeID
               success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

// Request image from URL string.
- (void)getImageAtURLString:(NSString *)urlString
                    success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

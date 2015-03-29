//
//  HTTPManager.m
//  Coffee
//
//  Created by Michael Green on 3/29/15.
//  Copyright (c) 2015 Michael Charles Green. All rights reserved.
//

#import "HTTPManager.h"
#import "APIInformation.h"

NSString *const kBaseURLString = BaseURLString;

@interface HTTPManager () //<AFURLResponseSerialization>
@end

@implementation HTTPManager

#pragma mark - Class Methods
// Returns a singleton instance of this class configured for this project.
+ (HTTPManager *)sharedHTTPManager
{
    static HTTPManager *_sharedHTTPManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedHTTPManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
    });
    
    return _sharedHTTPManager;
}

#pragma mark - Initializers
// Designated initializer
- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) return self;
 
    // Sending API key as part of the HTTP authorization header.
    [self.requestSerializer setValue:APIKeyString forHTTPHeaderField:@"Authorization"];
    
    return self;
}

#pragma mark - Service calls
// Requests a list of coffee objects.
- (void)getCoffeesSuccess:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *path = [NSString stringWithFormat:kBaseURLString];
    
    [self GET:path
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (success) {
              success(task, responseObject);
            
          }
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (failure) {
              failure(task, error);
          }
      }];
}

// Request a detailed coffee object
- (void)getCoffeeForID:(NSString *)coffeeID
               success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *path = [NSString stringWithFormat:@"%@%@", kBaseURLString, coffeeID];
    
    [self GET:path
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (success) {
              success(task, responseObject);
          }
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (failure) {
              failure(task, error);
          }
      }];
}

// Request image from URL string.
- (void)getImageAtURLString:(NSString *)urlString
                    success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    self.responseSerializer = [AFImageResponseSerializer serializer]; // This works for most of the images[AFPropertyListRequestSerializer serializer]]];
    
    [self GET:urlString
    parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (success) {
              success(task, responseObject);
          }
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (failure) {
              failure(task, error);
          }
      }];
}

@end

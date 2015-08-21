//
//  MyApi.h
//  Test
//
//  Created by Alex Tran on 8/21/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const APIBase = @"https://salty-mesa-4348.herokuapp.com/";
static NSString * const SCIOSSESSION = @"wefpwekfpokwe";
static NSString * const ContentType = @"application/json";

@interface MyApi : NSObject

+(NSString *) getAPIStringWithFunction:(NSString *) functionString;

+(void) checkLogInWithUsername:(NSString *)username andPassword:(NSString *)password inBackground:(void(^)(BOOL success, NSError* error)) completionHandler;

+(void)getTweetsWithMaxId:(NSInteger)maxId inBackground:(void(^)(NSMutableArray *tweets, BOOL success, NSError *error)) completionHandler;

+(void)logOut:(void(^)(BOOL success, NSError* error)) completionHandler;

@end

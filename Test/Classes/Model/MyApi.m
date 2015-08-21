//
//  MyApi.m
//  Test
//
//  Created by Alex Tran on 8/21/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import "MyApi.h"
#import <AFNetworking/AFNetworking.h>
#import "Tweet.h"

@implementation MyApi

+(NSString *) getAPIStringWithFunction:(NSString *) functionString{
    return [NSString stringWithFormat:@"%@%@", APIBase, functionString];
}

+(void) checkLogInWithUsername:(NSString *)username andPassword:(NSString *)password inBackground:(void(^)(BOOL success, NSError *error)) completionHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"Login": username, @"Password": password};
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:SCIOSSESSION forHTTPHeaderField:@"SCIOSSESSION"];
    [manager.requestSerializer setValue:ContentType forHTTPHeaderField:@"Content-Type"];
    [manager POST:[self getAPIStringWithFunction:@"login"] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionHandler(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        if(statusCode == 401) {
            completionHandler(NO, nil);
        }else{
            completionHandler(NO, error);
        }
    }];
}

+(void)getTweetsWithMaxId:(NSInteger)maxId inBackground:(void(^)(NSMutableArray *tweets, BOOL success, NSError *error)) completionHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{[NSNumber numberWithInteger:maxId]: @"max_id"};
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:SCIOSSESSION forHTTPHeaderField:@"SCIOSSESSION"];
    [manager.requestSerializer setValue:ContentType forHTTPHeaderField:@"Content-Type"];
    [manager GET:[self getAPIStringWithFunction:@"tweets"] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            completionHandler(nil, NO, nil);
        }else{
            NSMutableArray *arrayResponse = [NSMutableArray arrayWithArray:responseObject];
            NSMutableArray *arrayTweet = [NSMutableArray new];
            for (int i=0; i<arrayResponse.count; i++) {
                NSDictionary *dictionaryResponse = arrayResponse[i];
                Tweet *tweetObject = [Tweet new];
                tweetObject.tweetId = [dictionaryResponse objectForKey:@"id"];
                tweetObject.author = [dictionaryResponse objectForKey:@"author"];
                tweetObject.content = [dictionaryResponse objectForKey:@"content"];
                if ([dictionaryResponse objectForKey:@"images"] != [NSNull null]) {
                    tweetObject.images = [dictionaryResponse objectForKey:@"images"];
                }
                [arrayTweet addObject:tweetObject];
            }
            completionHandler(arrayTweet, YES, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionHandler(nil, NO, error);
    }];
}

+(void)logOut:(void(^)(BOOL success, NSError* error)) completionHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:SCIOSSESSION forHTTPHeaderField:@"SCIOSSESSION"];
    [manager.requestSerializer setValue:ContentType forHTTPHeaderField:@"Content-Type"];
    [manager DELETE:[self getAPIStringWithFunction:@"logout"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionHandler(YES, nil);
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionHandler(NO, error);
    }];
}

@end

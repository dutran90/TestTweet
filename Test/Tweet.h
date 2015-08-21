//
//  Tweet.h
//  Test
//
//  Created by Alex Tran on 8/20/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic) NSString* tweetId;
@property (nonatomic) NSString* author;
@property (nonatomic) NSString* content;
@property (nonatomic) NSMutableArray* images;

@end

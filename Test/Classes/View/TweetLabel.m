//
//  TweetLabel.m
//  Test
//
//  Created by Alex Tran on 8/22/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import "TweetLabel.h"

@implementation TweetLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}

@end

//
//  CCMain.h
//  Test
//
//  Created by Alex Tran on 8/20/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetLabel.h"

@interface TweetBasicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TweetLabel *subtitleLabel;

@end

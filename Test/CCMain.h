//
//  CCMain.h
//  Test
//
//  Created by Alex Tran on 8/20/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCMain : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imvTweet;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDes;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *atlLeftName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *atlLeftDes;

@end

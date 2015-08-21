//
//  MainVC.m
//  Test
//
//  Created by Alex Tran on 8/20/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import "MainViewController.h"
#import "TweetImageCell.h"
#import "TweetBasicCell.h"
#import "Tweet.h"
#import "LoginViewController.h"
#import "MyApi.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweetsTable;
@property (strong, nonatomic) NSMutableArray *arrayTweet;
@property (strong, nonatomic) MBProgressHUD *hud;
- (IBAction)touchLogout:(id)sender;
@end

static NSString * const TweetImageCellIdentifier = @"TweetImageCell";
static NSString * const TweetBasicCellIdentifier = @"TweetBasicCell";


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *cellImageNib = [UINib nibWithNibName:@"TweetImageCell" bundle:nil];
    [_tweetsTable registerNib:cellImageNib forCellReuseIdentifier:TweetImageCellIdentifier];
    
    UINib *cellBasicNib = [UINib nibWithNibName:@"TweetBasicCell" bundle:nil];
    [_tweetsTable registerNib:cellBasicNib forCellReuseIdentifier:TweetBasicCellIdentifier];
    
    _arrayTweet = [NSMutableArray new];
    
    [self showLoading];
    [MyApi getTweetsWithMaxId:1 inBackground:^(NSMutableArray *tweets, BOOL success, NSError *error) {
        [self hideLoading];
        if (!error) {
            if (success) {
                _arrayTweet = tweets;
                [_tweetsTable reloadData];
            }else{
                NSLog(@"No tweets!");
            }
        }else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row pressed!!");
}

#pragma mark - IBAction
- (IBAction)touchLogout:(id)sender {
    [self showLoading];
    [MyApi logOut:^(BOOL success, NSError *error) {
        [self hideLoading];
        if (!error) {
            if (success) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"Can not logout!");
            }
        }else{
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _arrayTweet.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self hasImageAtIndexPath:indexPath]) {
        return [self galleryCellAtIndexPath:indexPath];
    } else {
        return [self basicCellAtIndexPath:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self hasImageAtIndexPath:indexPath]) {
        return [self heightForImageCellAtIndexPath:indexPath];
    } else {
        return [self heightForBasicCellAtIndexPath:indexPath];
    }
}

#pragma mark - Configure UITableViewCell
- (BOOL)hasImageAtIndexPath:(NSIndexPath *)indexPath {
    if (_arrayTweet.count>0){
        Tweet *tweetObject = _arrayTweet[indexPath.row];
        if (tweetObject.images) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

- (TweetImageCell *)galleryCellAtIndexPath:(NSIndexPath *)indexPath {
    TweetImageCell *cell = [_tweetsTable dequeueReusableCellWithIdentifier:TweetImageCellIdentifier forIndexPath:indexPath];
    [self configureImageCell:cell atIndexPath:indexPath];
    return cell;
}
- (TweetBasicCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    TweetBasicCell *cell = [_tweetsTable dequeueReusableCellWithIdentifier:TweetBasicCellIdentifier forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(TweetBasicCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweetObject = _arrayTweet[indexPath.row];
    [self setTitleForCell:cell tweet:tweetObject];
    [self setSubtitleForCell:cell tweet:tweetObject];
}

- (void)configureImageCell:(TweetImageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweetObject = _arrayTweet[indexPath.row];
    [self setTitleForCell:cell tweet:tweetObject];
    [self setSubtitleForCell:cell tweet:tweetObject];
    [self setImageForCell:(id)cell tweet:tweetObject];
}

- (void)setImageForCell:(TweetImageCell *)cell tweet:(Tweet *)tweetObject {
    NSURL *url = [NSURL URLWithString:[tweetObject.images firstObject]];
    [cell.imvTweet setImage:nil];
    [cell.imvTweet setImageWithURL:url];
}


- (void)setTitleForCell:(TweetBasicCell *)cell tweet:(Tweet *)tweetObject {
    NSString *title;
    if ([tweetObject.author isEqual:@""] || !tweetObject.author) {
        title = @"No author";
    }else{
        title = tweetObject.author;
    }
    [cell.titleLabel setText:title];
}

- (void)setSubtitleForCell:(TweetBasicCell *)cell tweet:(Tweet *)tweetObject {
    NSString *subtitle;
    if ([tweetObject.content isEqual:@""] || !tweetObject.author) {
        subtitle = @"No content";
    }else{
        subtitle = tweetObject.content;
    }
    // Some subtitles can be really long, so only display the
    // first 200 characters
//    if (subtitle.length > 200) {
//        subtitle = [NSString stringWithFormat:@"%@...", [subtitle substringToIndex:200]];
//    }
    
    [cell.subtitleLabel setText:subtitle];
    [cell.subtitleLabel sizeToFit];
    cell.subtitleLabel.adjustsFontSizeToFitWidth=YES;
}

- (CGFloat)heightForImageCellAtIndexPath:(NSIndexPath *)indexPath {
    static TweetImageCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [_tweetsTable dequeueReusableCellWithIdentifier:TweetImageCellIdentifier];
    });
    
    [self configureImageCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static TweetBasicCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [_tweetsTable dequeueReusableCellWithIdentifier:TweetBasicCellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(_tweetsTable.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark - MBHudProgress
-(void)showLoading{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud show:YES];
}

-(void)hideLoading{
    [_hud hide:YES];
}

@end

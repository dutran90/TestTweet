//
//  MainVC.m
//  Test
//
//  Created by Alex Tran on 8/20/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import "MainVC.h"
#import "CCMain.h"
#import "Tweet.h"
#import "LoginVC.h"

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MainVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbvMain;
- (IBAction)touchLogout:(id)sender;


@end

@implementation MainVC{
    NSMutableArray *arrTweet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrTweet = [NSMutableArray new];
    [self getTweetsWithMaxId:1 Inbackground:^(NSMutableArray *tweets, BOOL success, NSError *error) {
        if (!error) {
            if (success) {
                arrTweet = tweets;
                [_tbvMain reloadData];
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

#pragma mark - UITableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return arrTweet.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CCDetail";
    
    CCMain *cell = (CCMain*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CCMain" owner:self options:nil];
        cell = (CCMain *)[nib objectAtIndex:0];
    }
    
    if (arrTweet.count>0) {
        Tweet *tw = arrTweet[indexPath.row];
        if (tw.images) {
            NSURL *url = [NSURL URLWithString:tw.images[0]];
            [cell.imvTweet setImageWithURL:url];
        }
        cell.lblName.text = tw.author;
        cell.lblDes.text = tw.content;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row pressed!!");
}

#pragma mark - WS
-(void)getTweetsWithMaxId:(NSInteger)maxId Inbackground:(void(^)(NSMutableArray* tweets, BOOL success, NSError* error)) completionHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:maxId], @"max_id", nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"wefpwekfpokwe" forHTTPHeaderField:@"SCIOSSESSION"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:@"https://salty-mesa-4348.herokuapp.com/tweets" parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            completionHandler(nil, NO, nil);
        }else{
            NSMutableArray *responseObjs = [NSMutableArray arrayWithArray:responseObject];
            NSMutableArray *arrTw = [NSMutableArray new];
            for (int i=0; i<responseObjs.count; i++) {
                NSDictionary *dic = responseObjs[i];
                Tweet *tw = [Tweet new];
                tw.tweetId = [dic objectForKey:@"id"];
                tw.author = [dic objectForKey:@"author"];
                tw.content = [dic objectForKey:@"content"];
                if ([dic objectForKey:@"images"] != [NSNull null]) {
                   tw.images = [dic objectForKey:@"images"];
                }
                [arrTw addObject:tw];
            }
            completionHandler(arrTw, YES, nil);
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionHandler(nil, NO, error);
    }];
}

-(void)logOut:(void(^)(BOOL success, NSError* error)) completionHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:username, @"Login", password, @"Password", nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"wefpwekfpokwe" forHTTPHeaderField:@"SCIOSSESSION"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager DELETE:@"https://salty-mesa-4348.herokuapp.com/logout" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionHandler(YES, nil);
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionHandler(NO, error);
    }];

}

- (IBAction)touchLogout:(id)sender {
    [self logOut:^(BOOL success, NSError *error) {
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
@end

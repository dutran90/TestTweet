//
//  LoginVC.m
//  Test
//
//  Created by Alex Tran on 8/20/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import "LoginVC.h"
#import <AFNetworking/AFNetworking.h>
#import "MainVC.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
- (IBAction)touchLogin:(id)sender;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextfidld delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)touchLogin:(id)sender {
    
    // Valid
    if ([_tfUsername.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please input username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([_tfPassword.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please input password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self checkLoginWithUsername:_tfUsername.text andPassword:_tfPassword.text InBackground:^(BOOL success, NSError *error) {
        if (!error) {
            if (success) {
                MainVC *main = [[MainVC alloc] initWithNibName:@"MainVC" bundle:nil];
                [self.navigationController pushViewController:main animated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Username or password is not correct" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
}

-(void) checkLoginWithUsername:(NSString*)username andPassword:(NSString*)password InBackground:(void(^)(BOOL success, NSError* error)) completionHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:username, @"Login", password, @"Password", nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"wefpwekfpokwe" forHTTPHeaderField:@"SCIOSSESSION"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"https://salty-mesa-4348.herokuapp.com/login" parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionHandler(YES, nil);
            NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionHandler(NO, error);
    }];
}


@end

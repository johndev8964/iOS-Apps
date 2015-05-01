//
//  FirstViewController.m
//  CashAssistMobileCard
//
//  Created by User on 4/8/15.
//  Copyright (c) 2015 liming. All rights reserved.
//

#import "FirstViewController.h"
#import "CreateAccountViewController.h"
#import "SigininViewController.h"
#import "UIColor+HexString.h"
#import "Global.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize createBtn;
@synthesize siginBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    createBtn.layer.cornerRadius = 15;
    createBtn.clipsToBounds = YES;
    createBtn.layer.borderWidth = 1;
    createBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
    siginBtn.layer.cornerRadius = 15;
    siginBtn.clipsToBounds = YES;
    siginBtn.layer.borderWidth = 1;
    siginBtn.layer.borderColor = [[UIColor colorWithHexString:@"#d79834"] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goCreateAccount:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateAccountViewController *createViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"CreateAccountView"];
    [Global pageFlip:self to:createViewCtrl];
}

- (IBAction)goSigin:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SigininViewController *siginViewCtrl = [mainStoryboard instantiateViewControllerWithIdentifier:@"SigninView"];
    [Global pageFlip:self to:siginViewCtrl];
}

@end

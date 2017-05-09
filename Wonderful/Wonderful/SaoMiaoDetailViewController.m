
//
//  SaoMiaoDetailViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/28.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "SaoMiaoDetailViewController.h"

@interface SaoMiaoDetailViewController ()

@property (nonatomic , retain) UIWebView *web;

@end

@implementation SaoMiaoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.web];
    
    NSURL *url = [NSURL URLWithString:self.url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.web loadRequest:request];
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

@end


//
//  RootViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/17.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<DCPathButtonDelegate>

@property (nonatomic , retain) DCPathButton *dcPathButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MeiWenViewController *MWVC = [[MeiWenViewController alloc] init];
    [self.navigationController pushViewController:MWVC animated:YES];
    
    self.dcPathButton = [[DCPathButton alloc] initDCPathButtonWithSubButtons:6 totalRadius:60 centerRadius:20 subRadius:15 centerImage:@"menu" centerBackground:nil subImages:^(DCPathButton *dc) {
        [dc subButtonImage:@"meiwen" withTag:2];
        [dc subButtonImage:@"meitu" withTag:4];
        [dc subButtonImage:@"meisheng" withTag:5];
        [dc subButtonImage:@"shoucang" withTag:1];
        [dc subButtonImage:@"zhezhi" withTag:0];
        [dc subButtonImage:@"saomiao" withTag:3];
    } subImageBackground:nil inLocationX:0 locationY:0 toParentView:[UIApplication sharedApplication].keyWindow];
    self.dcPathButton.frame = CGRectMake(-kScreenWidth + 80, -kScreenHeight + 90, self.dcPathButton.frame.size.width, self.dcPathButton.frame.size.height);
    self.dcPathButton.delegate = self;
    [self.dcPathButton bringSubviewToFront:self.view];
    
    UIPanGestureRecognizer *panP = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.dcPathButton addGestureRecognizer:panP];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panP
{
    UIView *aView = panP.view;
    CGPoint offset = [panP translationInView:aView];
    panP.view.transform = CGAffineTransformTranslate(panP.view.transform, offset.x, offset.y);
    [panP setTranslation:CGPointZero inView:aView];
}

- (void)button_0_action
{
    self.dcPathButton.frame = CGRectMake(-kScreenWidth + 80, -kScreenHeight + 90, self.dcPathButton.frame.size.width, self.dcPathButton.frame.size.height);
    [self.navigationController popViewControllerAnimated:YES];
    SheZhiViewController *SZVC = [[SheZhiViewController alloc] init];
    [self.navigationController pushViewController:SZVC animated:YES];
}

- (void)button_1_action
{
    self.dcPathButton.frame = CGRectMake(-kScreenWidth + 80, -kScreenHeight + 90, self.dcPathButton.frame.size.width, self.dcPathButton.frame.size.height);
    [self.navigationController popViewControllerAnimated:YES];
    CollectionViewController *CVC = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:CVC animated:YES];
}

- (void)button_2_action
{
    self.dcPathButton.frame = CGRectMake(-kScreenWidth + 80, -kScreenHeight + 90, self.dcPathButton.frame.size.width, self.dcPathButton.frame.size.height);
    [self.navigationController popViewControllerAnimated:YES];
    MeiWenViewController *MWVC = [[MeiWenViewController alloc] init];
    [self.navigationController pushViewController:MWVC animated:YES];
}

- (void)button_3_action
{
    self.dcPathButton.frame = CGRectMake(-kScreenWidth + 80, -kScreenHeight + 90, self.dcPathButton.frame.size.width, self.dcPathButton.frame.size.height);
    [self.navigationController popViewControllerAnimated:YES];
    SaoMiaoViewController *SMVC = [[SaoMiaoViewController alloc] init];
    [self.navigationController pushViewController:SMVC animated:YES];
}

- (void)button_4_action
{
    self.dcPathButton.frame = CGRectMake(-kScreenWidth + 80, -kScreenHeight + 90, self.dcPathButton.frame.size.width, self.dcPathButton.frame.size.height);
    [self.navigationController popViewControllerAnimated:YES];
    MeiTuViewController *MTVC = [[MeiTuViewController alloc] init];
    [self.navigationController pushViewController:MTVC animated:YES];
}

- (void)button_5_action
{
    self.dcPathButton.frame = CGRectMake(-kScreenWidth + 80, -kScreenHeight + 90, self.dcPathButton.frame.size.width, self.dcPathButton.frame.size.height);
    [self.navigationController popViewControllerAnimated:YES];
    MeiShengViewController *MSVC = [[MeiShengViewController alloc] init];
    [self.navigationController pushViewController:MSVC animated:YES];
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

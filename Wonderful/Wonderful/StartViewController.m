//
//  StartViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/26.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "StartViewController.h"
#import "RootViewController.h"

#define kStartButtonWidthAndHeight 100

@interface StartViewController ()<UIScrollViewDelegate>

@property (nonatomic , retain) UIScrollView *scrollView;

@property (nonatomic , retain) UIPageControl *pageControl;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 4, kScreenHeight);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - kStartButtonWidthAndHeight / 2, kScreenWidth, kStartButtonWidthAndHeight / 3)];
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self.view addSubview:self.pageControl];
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg" , i + 1]];
        [self.scrollView addSubview:imageView];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"开启美好之旅" forState:UIControlStateNormal];
    button.frame = CGRectMake(kScreenWidth * 3 + (kScreenWidth - kStartButtonWidthAndHeight) / 2, kScreenHeight - kStartButtonWidthAndHeight * 3, kStartButtonWidthAndHeight, kStartButtonWidthAndHeight / 2);
    button.tintColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    button.layer.borderColor = [[UIColor orangeColor] CGColor];
    button.layer.borderWidth = 3;
    [self.scrollView addSubview:button];
}

- (void)buttonAction:(UIButton *)sender
{
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]] animated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
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

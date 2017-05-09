//
//  CollectionViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/18.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "CollectionViewController.h"

#import "CollectionDetailViewController.h"

#define kViewWidthAndHeight 120
#define kSpace 10

@interface CollectionViewController ()

@property (nonatomic , retain) UIView *nav;

@property (nonatomic , retain) UIImageView *meiWenView;

@property (nonatomic , retain) UIImageView *meiShengView;

@property (nonatomic , retain) UIImageView *meiTuView;

@property (nonatomic , retain) NSMutableArray *sourceArray;

@property (nonatomic , retain) UIImageView *image;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBackImage];
}

- (void)setBackImage
{
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    self.image.image = [UIImage imageNamed:@"snow.jpg"];
    self.image.userInteractionEnabled = YES;
    [self.view addSubview:self.image];
    [self setViews];
}

- (void)setViews
{
    self.meiWenView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - kViewWidthAndHeight / 2, kScreenHeight / 2 - kViewWidthAndHeight * 2, kViewWidthAndHeight, kViewWidthAndHeight)];
    self.meiWenView.image = [UIImage imageNamed:@"wonderful3.jpg"];
    [self.meiWenView addSubview:[self creatLabelWithText:@"美文收藏"]];
    
    self.meiShengView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - kViewWidthAndHeight - kSpace, kScreenHeight / 2 - kViewWidthAndHeight, kViewWidthAndHeight, kViewWidthAndHeight)];
    self.meiShengView.image = [UIImage imageNamed:@"wonderful2.jpeg"];
    [self.meiShengView addSubview:[self creatLabelWithText:@"美声收藏"]];
    
    self.meiTuView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 + kSpace, kScreenHeight / 2 - kViewWidthAndHeight, kViewWidthAndHeight, kViewWidthAndHeight)];
    self.meiTuView.image = [UIImage imageNamed:@"wonderful4.jpg"];
    [self.meiTuView addSubview:[self creatLabelWithText:@"美图收藏"]];
    
    self.meiWenView.layer.cornerRadius = kViewWidthAndHeight / 2;
    self.meiWenView.clipsToBounds = YES;
    self.meiWenView.layer.borderColor = [[UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 225.0 alpha:1.0] CGColor];
    self.meiWenView.layer.borderWidth = 5;
    
    self.meiShengView.layer.cornerRadius = kViewWidthAndHeight / 2;
    self.meiShengView.clipsToBounds = YES;
    self.meiShengView.layer.borderColor = [[UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 225.0 alpha:1.0] CGColor];
    self.meiShengView.layer.borderWidth = 5;
    
    self.meiTuView.layer.cornerRadius = kViewWidthAndHeight / 2;
    self.meiTuView.clipsToBounds = YES;
    self.meiTuView.layer.borderColor = [[UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 225.0 alpha:1.0] CGColor];
    self.meiTuView.layer.borderWidth = 5;
    
    [self.meiWenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(meiWenTapAction:)]];
    self.meiWenView.userInteractionEnabled = YES;
    [self.meiShengView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(meiShengTapAction:)]];
    self.meiShengView.userInteractionEnabled = YES;
    [self.meiTuView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(meiTuTapAction:)]];
    self.meiTuView.userInteractionEnabled = YES;
    
    [self.image addSubview:self.meiWenView];
    [self.image addSubview:self.meiShengView];
    [self.image addSubview:self.meiTuView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(setTransformView) userInfo:nil repeats:YES];
}

- (NSMutableArray *)sourceArray
{
    if (_sourceArray == nil) {
        self.sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}

- (void)meiWenTapAction:(UITapGestureRecognizer *)sender
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MeiWen" inManagedObjectContext:kGetContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortArray];
    
    NSArray *array = [kGetContext executeFetchRequest:request error:nil];
    [self.sourceArray addObjectsFromArray:array];
    
    CollectionDetailViewController *CDVC = [[CollectionDetailViewController alloc] init];
    CDVC.collectionTitle = @"美文收藏";
    CDVC.sourceArray = self.sourceArray;
    
    [self.navigationController pushViewController:CDVC animated:YES];
}

- (void)meiShengTapAction:(UITapGestureRecognizer *)sender
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MeiSheng" inManagedObjectContext:kGetContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortArray];
    
    NSArray *array = [kGetContext executeFetchRequest:request error:nil];
    [self.sourceArray addObjectsFromArray:array];
    
    CollectionDetailViewController *CDVC = [[CollectionDetailViewController alloc] init];
    CDVC.collectionTitle = @"美声收藏";
    CDVC.sourceArray = self.sourceArray;
    
    [self.navigationController pushViewController:CDVC animated:YES];
}

- (void)meiTuTapAction:(UITapGestureRecognizer *)sender
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MeiTu" inManagedObjectContext:kGetContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortArray];
    
    NSArray *array = [kGetContext executeFetchRequest:request error:nil];
    [self.sourceArray addObjectsFromArray:array];
    
    CollectionDetailViewController *CDVC = [[CollectionDetailViewController alloc] init];
    CDVC.collectionTitle = @"美图收藏";
    CDVC.sourceArray = self.sourceArray;
    
    [self.navigationController pushViewController:CDVC animated:YES];
}

- (void)setTransformView
{
    self.meiWenView.transform = CGAffineTransformRotate(self.meiWenView.transform, M_PI/180);
    self.meiShengView.transform = CGAffineTransformRotate(self.meiShengView.transform, M_PI/180);
    self.meiTuView.transform = CGAffineTransformRotate(self.meiTuView.transform, M_PI/180);
}

- (UILabel *)creatLabelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kViewWidthAndHeight, kViewWidthAndHeight)];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.alpha = .8;
    label.textColor = [UIColor yellowColor];
    
    return label;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.nav = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    self.nav.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.nav];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, kScreenWidth, 30)];
    label.text = @"收藏";
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    [self.nav addSubview:label];
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

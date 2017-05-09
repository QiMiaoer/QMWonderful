//
//  MeiTuViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/18.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "MeiTuViewController.h"

#import "MeiTuDetailViewController.h"

#define kImageViewWidthAndHeight 120
#define kSphereViewHeight 164

@interface MeiTuViewController ()

@property (nonatomic , retain) UIView *nav;

@property (nonatomic , retain) NSMutableArray *sourceArray;

@property (nonatomic , retain) DBSphereView *sphereView;

@end

@implementation MeiTuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD show];
    
    [self getDataFromNetwork];
}

- (void)setSphereView
{
    self.sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(0, kSphereViewHeight, kScreenWidth, kScreenHeight - kSphereViewHeight + 44)];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = 0; i < self.sourceArray.count; i++) {
        MeiTuModel *model = self.sourceArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageViewWidthAndHeight, kImageViewWidthAndHeight)];
        imageView.layer.borderColor = [[UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0] CGColor];
        imageView.layer.borderWidth = 5;
        imageView.layer.cornerRadius = kImageViewWidthAndHeight / 2;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"wonderful6.jpg"]];
        imageView.tag = [model.aid integerValue];
        [array addObject:imageView];
        [self.sphereView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
    }
    [self.sphereView setCloudTags:array];
    self.sphereView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.sphereView];
    [self layoutDWBubbleMenuButton];
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    for (MeiTuModel *model in self.sourceArray) {
        if (sender.view.tag == [model.aid integerValue]) {
            MeiTuDetailViewController *MTDVC = [[MeiTuDetailViewController alloc] init];
            MTDVC.model = model;
            
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
            [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                switch (status) {
                    case AFNetworkReachabilityStatusNotReachable:
                    {
                        NSLog(@"没网络");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络，请检查是否网络通畅" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }
                        break;
                    case AFNetworkReachabilityStatusReachableViaWWAN:
                    {
                        NSLog(@"2G/3G/4G");
                        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:@"即将用数据流量浏览图片，可能使用较多流量" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [aler show];
                    }
                        break;
                    case AFNetworkReachabilityStatusReachableViaWiFi:
                        NSLog(@"WIFI");
                        [self.navigationController pushViewController:MTDVC animated:YES];
                        break;
                        
                    default:
                        break;
                }
            }];
        }
    }
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
    label.text = @"美图";
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    [self.nav addSubview:label];
}

- (void)getDataFromNetwork
{
    [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"wmtp"]];
}

- (void)getDataFromNetworkingWithMainUrl:(NSString *)mainUrl andParmUrl:(NSString *)parmUrl
{
    NSURL *url = [NSURL URLWithString:mainUrl];
    NSData *parm = [parmUrl dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:parm];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            [self parserJsonData:data];
            [SVProgressHUD dismiss];
        } else {
            NSLog(@"%@" , connectionError.localizedDescription);
        }
    }];
}

- (void)parserJsonData:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *array = [NSArray array];
    for (NSString *key in dic) {
        if ([key isEqualToString:@"result"]) {
            array = dic[key];
        }
    }
    
    for (NSDictionary *miniDic in array) {
        MeiTuModel *model = [[MeiTuModel alloc] init];
        for (NSString *key in miniDic) {
            if ([key isEqualToString:@"aid"]) {
                model.aid = [NSString stringWithFormat:@"%@" , miniDic[key]];
            }
            if ([key isEqualToString:@"count"]) {
                model.count = [NSString stringWithFormat:@"%@" , miniDic[key]];
            }
            if ([key isEqualToString:@"date"]) {
                model.date = [miniDic[key] substringToIndex:16];
            }
            if ([key isEqualToString:@"image"]) {
                model.image = miniDic[key];
            }
            if ([key isEqualToString:@"title"]) {
                model.title = miniDic[key];
            }
        }
        [self.sourceArray addObject:model];
    }
    [self setSphereView];
}

- (NSMutableArray *)sourceArray
{
    if (_sourceArray == nil) {
        self.sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self layoutDWBubbleMenuButton];
}

- (void)layoutDWBubbleMenuButton
{
    UILabel *homeLabel = [self createHomeButtonView];
    
    DWBubbleMenuButton *downMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40, kScreenHeight - 40, homeLabel.frame.size.width, homeLabel.frame.size.height) expansionDirection:DirectionUp];
    
    downMenuButton.homeButtonView = homeLabel;
    
    [downMenuButton addButtons:[self createDemoButtonArray]];
    [self.view addSubview:downMenuButton];
}

- (NSArray *)createDemoButtonArray
{
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"可爱", @"文字", @"欧美", @"情侣", @"动漫", @"明星", @"精美", @"创意", @"摄影", @"每日", @"治愈"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0.f, 0.f, 70.f, 30.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}

- (UILabel *)createHomeButtonView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    label.text = @"美图";
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor redColor];
    label.alpha = .5;
    label.clipsToBounds = YES;
    
    return label;
}

- (void)test:(UIButton *)sender
{
    //    NSLog(@"Button tapped, tag: %ld", (long)sender.tag);
    if ((long)sender.tag == 0) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"katp"]];
    } else if ((long)sender.tag == 1) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"wztp"]];
    } else if ((long)sender.tag == 2) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"omtp"]];
    } else if ((long)sender.tag == 3) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"qltp"]];
    } else if ((long)sender.tag == 4) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"dmtp"]];
    } else if ((long)sender.tag == 5) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"mxtp"]];
    } else if ((long)sender.tag == 6) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"jmdt"]];
    } else if ((long)sender.tag == 7) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"goodlife"]];
    } else if ((long)sender.tag == 8) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"syzp"]];
    } else if ((long)sender.tag == 9) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"mrmt"]];
    } else if ((long)sender.tag == 10) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self.sphereView removeFromSuperview];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kSee1 , @"yixinli"]];
    }
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

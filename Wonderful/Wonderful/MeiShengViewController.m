
//
//  MeiShengViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/18.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "MeiShengViewController.h"

#import "MeiShengDetailViewController.h"

#define kItemSpacing 5

@interface MeiShengViewController ()<UICollectionViewDataSource , UICollectionViewDelegate>

@property (nonatomic , retain) UIView *nav;

@property (nonatomic , retain) UICollectionView *collectionView;

@property (nonatomic , retain) NSMutableArray *sourceArray;

@end

@implementation MeiShengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD show];
    
    [self getDataFromNetwork];
    
    [self setCollectionView];
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
    label.text = @"美声";
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    [self.nav addSubview:label];
}

- (void)setCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemSizeWidth = (kScreenWidth - kItemSpacing) / 2;
    flowLayout.itemSize = CGSizeMake(itemSizeWidth, itemSizeWidth / 4 * 3);
    flowLayout.minimumInteritemSpacing = kItemSpacing / 3;
    flowLayout.minimumLineSpacing = kItemSpacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(kItemSpacing / 3, kItemSpacing / 3, kItemSpacing / 3, kItemSpacing / 3);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, self.view.frame.size.height - 44) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[MeiShengCollectionViewCell class] forCellWithReuseIdentifier:@"itemid"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeiShengCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemid" forIndexPath:indexPath];
    
    MeiShengModel *model = self.sourceArray[indexPath.row];
    
    [cell.cover sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"wonderful7.jpg"]];
    cell.title.text = model.title;
    cell.duration.text = [NSString stringWithFormat:@"时长：%@" , model.duration];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeiShengDetailViewController *MSDVC = [[MeiShengDetailViewController alloc] init];
    
    if ([self.sourceArray isMemberOfClass:[NSMutableArray class]]) {
        MSDVC.sourceArray = self.sourceArray;
    } else {
        MSDVC.sourceArray = [self.sourceArray mutableCopy];
    }
    
    MeiShengModel *model = self.sourceArray[indexPath.row];
    MSDVC.model = model;
    MSDVC.index = indexPath.row;
    [self.navigationController pushViewController:MSDVC animated:YES];
}

- (void)getDataFromNetwork
{
    [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"xinli"]];
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
        MeiShengModel *model = [[MeiShengModel alloc] init];
        for (NSString *key in miniDic) {
            if ([key isEqualToString:@"content"]) {
                model.content = miniDic[key];
            }
            if ([key isEqualToString:@"count"]) {
                model.count = [NSString stringWithFormat:@"%@" , miniDic[key]];
            }
            if ([key isEqualToString:@"date"]) {
                model.date = [miniDic[key] substringToIndex:16];;
            }
            if ([key isEqualToString:@"duration"]) {
                model.duration = miniDic[key];
            }
            if ([key isEqualToString:@"image"]) {
                model.image = miniDic[key];
            }
            if ([key isEqualToString:@"link"]) {
                model.link = miniDic[key];
            }
            if ([key isEqualToString:@"title"]) {
                model.title = miniDic[key];
            }
        }
        
        [self.sourceArray addObject:model];
    }
    
    [self.collectionView reloadData];
}

- (NSMutableArray *)sourceArray
{
    if (_sourceArray == nil) {
        self.sourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _sourceArray;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    for (NSString *title in @[@"耳朵", @"陌生", @"聆听", @"文艺", @"柠檬", @"吻安", @"豆豆", @"蔷薇", @"语录", @"岁月"]) {
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
    
    label.text = @"美声";
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
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"erduo"]];
    } else if ((long)sender.tag == 1) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"moofm"]];
    } else if ((long)sender.tag == 2) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"douzi"]];
    } else if ((long)sender.tag == 3) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"tian"]];
    } else if ((long)sender.tag == 4) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"xiang"]];
    } else if ((long)sender.tag == 5) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"xiaosu"]];
    } else if ((long)sender.tag == 6) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"doudou"]];
    } else if ((long)sender.tag == 7) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"qiangwei"]];
    } else if ((long)sender.tag == 8) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"nana"]];
    } else if ((long)sender.tag == 9) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kListen12 , @"syrg"]];
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

//
//  MeiWenViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/16.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "MeiWenViewController.h"

#import "MeiWenDetailViewController.h"

@interface MeiWenViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , retain) UIView *nav;

@property (nonatomic , retain) UITableView *tableView;

@property (nonatomic , retain) NSMutableArray *sourceArray;

@end

@implementation MeiWenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD show];
    
    [self getDataFromNetwork];
    
    [self setTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeiWenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    
    MeiWenModel *model = self.sourceArray[indexPath.row];
    
    [cell.mainView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"wonderful1"]];
    cell.titleLabel.text = model.title;
    cell.dateLabel.text = model.date;
    cell.scanLabel.text = [NSString stringWithFormat:@"浏览量：%@" , model.count];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeiWenDetailViewController *MWDVC = [[MeiWenDetailViewController alloc] init];
    MeiWenModel *model = self.sourceArray[indexPath.row];
    MWDVC.model = model;
    MWDVC.title = model.title;
    [self.navigationController pushViewController:MWDVC animated:YES];
//    [self presentViewController:nav animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight / 3;
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
    label.text = @"美文";
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    [self.nav addSubview:label];
}

- (void)setTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[MeiWenTableViewCell class] forCellReuseIdentifier:@"cellid"];
}

- (void)getDataFromNetwork
{
    [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"umeitime"]];
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
        MeiWenModel *model = [[MeiWenModel alloc] init];
        for (NSString *key in miniDic) {
            if ([key isEqualToString:@"aid"]) {
                model.aid = miniDic[key];
            }
            if ([key isEqualToString:@"count"]) {
                model.count = [NSString stringWithFormat:@"%@" , miniDic[key]];
            }
            if ([key isEqualToString:@"date"]) {
//                model.date = miniDic[key];
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
    
    [self.tableView reloadData];
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
    for (NSString *title in @[@"二更", @"不止", @"日赏", @"青春", @"左岸", @"文艺", @"诗歌", @"语录", @"陪你", @"佳人", @"美文", @"青年", @"小说", @"花边"]) {
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
    
    label.text = @"美文";
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
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"egst"]];
    } else if ((long)sender.tag == 1) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"bzds"]];
    } else if ((long)sender.tag == 2) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"meiwenrishang"]];
    } else if ((long)sender.tag == 3) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"banxia"]];
    } else if ((long)sender.tag == 4) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"zuoan"]];
    } else if ((long)sender.tag == 5) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"manwenyi"]];
    } else if ((long)sender.tag == 6) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"shige"]];
    } else if ((long)sender.tag == 7) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"yulu"]];
    } else if ((long)sender.tag == 8) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"lizhi"]];
    } else if ((long)sender.tag == 9) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"jiaren"]];
    } else if ((long)sender.tag == 10) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"meiwenshe"]];
    } else if ((long)sender.tag == 11) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"qnwz"]];
    } else if ((long)sender.tag == 12) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"zuibook"]];
    } else if ((long)sender.tag == 13) {
        [SVProgressHUD show];
        [self.sourceArray removeAllObjects];
        [self getDataFromNetworkingWithMainUrl:kMainUrl1 andParmUrl:[NSString stringWithFormat:kRead1 , @"huabian"]];
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

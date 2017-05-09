//
//  SheZhiViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/19.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "SheZhiViewController.h"

@interface SheZhiViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , retain) UITableView *tableView;

@property (nonatomic , retain) UIView *nav;

@property (nonatomic , retain) NSString *clearCacheString;

@end

@implementation SheZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shezhicellid" forIndexPath:indexPath];
    
    NSArray *array = @[[NSString stringWithFormat:@"清除缓存:%@" , self.clearCacheString] , @"" , @"夜间模式/日间模式" , @"" , @"关于我"];
    
    cell.backgroundColor = [UIColor clearColor];
    self.tableView.layer.contents = (id)[UIImage imageNamed:@"wonderful5"].CGImage;
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.layer.borderColor = [[UIColor orangeColor] CGColor];
    cell.textLabel.layer.borderWidth = 3;
    cell.textLabel.layer.cornerRadius = 10;
    cell.textLabel.clipsToBounds = YES;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:23];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:@"确定要清除缓存吗?亲" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self clearCache:[self getCachePath]];
            self.clearCacheString = @"0.00M";
            [self.tableView reloadData];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ;
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (indexPath.row == 2) {
        if ([UIApplication sharedApplication].keyWindow.alpha == 1.0) {
            [UIApplication sharedApplication].keyWindow.alpha = .5;
        } else {
            [UIApplication sharedApplication].keyWindow.alpha = 1.0;
        }
    }
    if (indexPath.row == 4) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关于我" message:@"本款APP仅作练习使用，数据均来自网络。---赵亚星  QQ：1228198159" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ;
        }]];
        [self presentViewController:alert animated:YES completion:nil];
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
    label.text = @"设置";
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    [self.nav addSubview:label];
    
    NSString *path = [self getCachePath];
    CGFloat cacheSize = [self folderSizeWithPath:path] / 1024.0 / 1024.0;
    self.clearCacheString = [NSString stringWithFormat:@"%.2lfM" , cacheSize];
}

- (NSString *)getCachePath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    return path;
}

- (CGFloat)folderSizeWithPath:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *enumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [enumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        float singleFileSize = 0.0;
        if ([manager fileExistsAtPath:fileAbsolutePath]) {
            singleFileSize = [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        }
        folderSize += singleFileSize;
    }
    return folderSize;
}

- (void)clearCache:(NSString *)floderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:floderPath]) {
        NSArray *childerFile = [manager subpathsAtPath:floderPath];
        for (NSString *fileName in childerFile) {
            NSString *absoultePath = [floderPath stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:absoultePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearDisk];
}

- (void)setTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"shezhicellid"];
    self.tableView.scrollEnabled = NO;
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

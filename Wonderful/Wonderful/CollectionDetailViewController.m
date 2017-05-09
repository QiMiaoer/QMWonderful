
//
//  CollectionDetailViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/21.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "CollectionDetailViewController.h"

#import "CollectionTableViewCell.h"
#import "MeiWenDetailViewController.h"
#import "MeiShengDetailViewController.h"
#import "MeiTuDetailViewController.h"

@interface CollectionDetailViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , retain) UIView *nav;

@property (nonatomic , retain) UITableView *tableView;

@property (nonatomic , retain) UIButton *clearButton;

@property (nonatomic , retain) NSMutableArray *titles;

@property (nonatomic , retain) UIButton *button;

@end

@implementation CollectionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTable];
}

- (NSMutableArray *)titles
{
    if (_titles == nil) {
        self.titles = [NSMutableArray arrayWithCapacity:0];
    }
    return _titles;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectioncellid" forIndexPath:indexPath];
    if ([self.collectionTitle isEqualToString:@"美文收藏"]) {
        MeiWen *model = self.sourceArray[indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        tableView.layer.contents = (id)[UIImage imageNamed:@"snow.jpg"].CGImage;
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"wonderful1"]];
        cell.cellTitle.text = model.title;
    }
    if ([self.collectionTitle isEqualToString:@"美声收藏"]) {
        MeiSheng *model = self.sourceArray[indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        tableView.layer.contents = (id)[UIImage imageNamed:@"snow.jpg"].CGImage;
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"wonderful7.jpg"]];
        cell.cellTitle.text = model.title;
    }
    if ([self.collectionTitle isEqualToString:@"美图收藏"]) {
        MeiTu *model = self.sourceArray[indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        tableView.layer.contents = (id)[UIImage imageNamed:@"snow.jpg"].CGImage;
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"wonderful6.jpg"]];
        cell.cellTitle.text = model.title;
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.tableView isEditing]) {
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([self.collectionTitle isEqualToString:@"美文收藏"]) {
            MeiWenDetailViewController *MWDVC = [[MeiWenDetailViewController alloc] init];
            MeiWen *model = self.sourceArray[indexPath.row];
            MWDVC.model = model;
            MWDVC.title = model.title;
            [self.navigationController pushViewController:MWDVC animated:YES];
        }
        if ([self.collectionTitle isEqualToString:@"美声收藏"]) {
            MeiShengDetailViewController *MWDVC = [[MeiShengDetailViewController alloc] init];
            MeiWen *model = self.sourceArray[indexPath.row];
            MWDVC.model = model;
            MWDVC.title = model.title;
            [self.navigationController pushViewController:MWDVC animated:YES];
        }
        if ([self.collectionTitle isEqualToString:@"美图收藏"]) {
            MeiTuDetailViewController *MWDVC = [[MeiTuDetailViewController alloc] init];
            MeiWen *model = self.sourceArray[indexPath.row];
            MWDVC.model = model;
            MWDVC.title = model.title;
            [self.navigationController pushViewController:MWDVC animated:YES];
        }
    } else {
        if ([self.collectionTitle isEqualToString:@"美文收藏"]) {
            MeiWen *model = self.sourceArray[indexPath.row];
            NSString *aTitle = model.title;
            [self.titles addObject:aTitle];
        }
        if ([self.collectionTitle isEqualToString:@"美声收藏"]) {
            MeiSheng *model = self.sourceArray[indexPath.row];
            NSString *aTitle = model.title;
            [self.titles addObject:aTitle];
        }
        if ([self.collectionTitle isEqualToString:@"美图收藏"]) {
            MeiTu *model = self.sourceArray[indexPath.row];
            NSString *aTitle = model.title;
            [self.titles addObject:aTitle];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)clearButtonAction:(UIButton *)sender
{
    if (![self.tableView isEditing]) {
        [self.tableView setEditing:YES];
        [self.clearButton setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    } else {
        [self.tableView setEditing:NO];
        [self.clearButton setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
        
        if ([self.collectionTitle isEqualToString:@"美文收藏"]) {
            
            for (NSString *title in self.titles) {
                for (int i = 0; i < self.sourceArray.count; i++) {
                    MeiWen *oneModel = self.sourceArray[i];
                    if ([oneModel.title isEqualToString:title]) {
                        [kGetContext deleteObject:oneModel];
                        [kGetAppDelegate saveContext];
                        
                        [self.sourceArray removeObject:oneModel];
                    }
                }
            }
        }
        if ([self.collectionTitle isEqualToString:@"美声收藏"]) {
            for (NSString *title in self.titles) {
                for (int i = 0; i < self.sourceArray.count; i++) {
                    MeiWen *oneModel = self.sourceArray[i];
                    if ([oneModel.title isEqualToString:title]) {
                        [kGetContext deleteObject:oneModel];
                        [kGetAppDelegate saveContext];
                        [self.sourceArray removeObject:oneModel];
                    }
                }
            }
        }
        if ([self.collectionTitle isEqualToString:@"美图收藏"]) {
            for (NSString *title in self.titles) {
                for (int i = 0; i < self.sourceArray.count; i++) {
                    MeiWen *oneModel = self.sourceArray[i];
                    if ([oneModel.title isEqualToString:title]) {
                        [kGetContext deleteObject:oneModel];
                        [kGetAppDelegate saveContext];
                        [self.sourceArray removeObject:oneModel];
                    }
                }
            }
        }
        [self.tableView reloadData];
    }
}

- (void)buttonAction:(UIButton *)sender
{
    [self.sourceArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTable
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[CollectionTableViewCell class] forCellReuseIdentifier:@"collectioncellid"];
    [self.tableView setEditing:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.button removeFromSuperview];
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
    label.text = self.collectionTitle;
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    [self.nav addSubview:label];
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.clearButton.frame = CGRectMake(kScreenWidth - kButtonWidthAndHeight, 0, kButtonWidthAndHeight - 10, kButtonWidthAndHeight - 10);
    [self.clearButton setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    [self.nav addSubview:self.clearButton];
    [self.clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(kScreenWidth - kButtonWidthAndHeight, kScreenHeight - kButtonWidthAndHeight, kButtonWidthAndHeight, kButtonWidthAndHeight);
    [self.button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:self.button];
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
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

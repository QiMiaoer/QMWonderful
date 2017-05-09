//
//  MeiWenTableViewCell.m
//  Wonderful
//
//  Created by laouhn on 15/12/17.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "MeiWenTableViewCell.h"

#define kViewWidth self.mainView.frame.size.width / 5 * 3.5
#define kViewHeight self.mainView.frame.size.height / 5 * 3

@implementation MeiWenTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.mainView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth - 10, kScreenHeight / 3 - 10)];
    self.mainView.layer.borderColor = [[UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0] CGColor];
    self.mainView.layer.borderWidth = 5;
    self.mainView.layer.cornerRadius = 20;
    self.mainView.clipsToBounds = YES;
    [self.contentView addSubview:self.mainView];
    
    UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(self.mainView.frame.size.width / 2 - kViewWidth / 2, self.mainView.frame.size.height / 2 - kViewHeight / 2, kViewWidth, kViewHeight)];
    aview.alpha = .6;
    aview.backgroundColor = [UIColor blackColor];
    aview.layer.cornerRadius = 20;
    [self.mainView addSubview:aview];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, aview.frame.size.height / 2)];
    self.titleLabel.font = [UIFont systemFontOfSize:23];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [aview addSubview:self.titleLabel];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, aview.frame.size.height / 2, kViewWidth, aview.frame.size.height / 4)];
    self.dateLabel.font = [UIFont systemFontOfSize:20];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [aview addSubview:self.dateLabel];
    
    self.scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, aview.frame.size.height / 4 * 3, kViewWidth, aview.frame.size.height / 4)];
    self.scanLabel.font = [UIFont systemFontOfSize:20];
    self.scanLabel.textColor = [UIColor whiteColor];
    self.scanLabel.textAlignment = NSTextAlignmentCenter;
    [aview addSubview:self.scanLabel];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

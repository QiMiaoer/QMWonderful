//
//  CollectionTableViewCell.m
//  Wonderful
//
//  Created by laouhn on 15/12/21.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "CollectionTableViewCell.h"

#define kCellSpace 3

@implementation CollectionTableViewCell

- (UIImageView *)cellImageView
{
    if (_cellImageView == nil) {
        self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kCellSpace, self.contentView.frame.size.width / 2, self.contentView.frame.size.height - kCellSpace * 2)];
        self.cellImageView.layer.borderColor = [[UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0] CGColor];
        self.cellImageView.layer.borderWidth = 5;
        self.cellImageView.layer.cornerRadius = 10;
        self.cellImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.cellImageView];
    }
    return _cellImageView;
}

- (UILabel *)cellTitle
{
    if (_cellTitle == nil) {
        self.cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width / 2, self.cellImageView.frame.origin.y + self.cellImageView.frame.size.height / 4, self.contentView.frame.size.width / 2, self.cellImageView.frame.size.height / 3 * 2)];
        self.cellTitle.numberOfLines = 0;
        self.cellTitle.font = [UIFont systemFontOfSize:22];
        [self.contentView addSubview:self.cellTitle];
    }
    return _cellTitle;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

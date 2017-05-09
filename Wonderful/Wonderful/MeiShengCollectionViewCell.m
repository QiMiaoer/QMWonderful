//
//  MeiShengCollectionViewCell.m
//  Wonderful
//
//  Created by laouhn on 15/12/18.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "MeiShengCollectionViewCell.h"

#define kLabelHeight 18

@implementation MeiShengCollectionViewCell

- (UIImageView *)cover
{
    if (_cover == nil) {
        self.cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - kLabelHeight * 2)];
        self.cover.layer.borderColor = [[UIColor orangeColor] CGColor];
        self.cover.layer.borderWidth = 3;
        self.cover.layer.cornerRadius = 10;
        self.cover.clipsToBounds = YES;
        [self.contentView addSubview:_cover];
    }
    return _cover;
}

- (UILabel *)title
{
    if (_title == nil) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, kLabelHeight)];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - kLabelHeight * 2, self.contentView.frame.size.width, kLabelHeight)];
        [toolBar addSubview:_title];
        [self.contentView addSubview:toolBar];
    }
    return _title;
}

- (UILabel *)duration
{
    if (_duration == nil) {
        self.duration = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, kLabelHeight)];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - kLabelHeight, self.contentView.frame.size.width, kLabelHeight)];
        [toolBar addSubview:_duration];
        [self.contentView addSubview:toolBar];
    }
    return _duration;
}

@end

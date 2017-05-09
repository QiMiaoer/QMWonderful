//
//  MeiShengDetailViewController.h
//  Wonderful
//
//  Created by laouhn on 15/12/18.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeiShengModel.h"

@interface MeiShengDetailViewController : UIViewController

@property (nonatomic , retain) NSMutableArray *sourceArray;

@property (nonatomic , assign) NSInteger index;

@property (nonatomic , retain) MeiShengModel *model;

@end

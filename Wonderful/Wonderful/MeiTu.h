//
//  MeiTu.h
//  Wonderful
//
//  Created by laouhn on 15/12/21.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MeiTu : NSManagedObject

@property (nonatomic , retain) NSString *aid;

@property (nonatomic , retain) NSString *count;

@property (nonatomic , retain) NSString *date;

@property (nonatomic , retain) NSString *image;

@property (nonatomic , retain) NSString *title;

@end

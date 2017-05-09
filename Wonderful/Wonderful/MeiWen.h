//
//  MeiWen.h
//  Wonderful
//
//  Created by laouhn on 15/12/21.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MeiWen : NSManagedObject

@property (nonatomic , retain) NSString *aid;

@property (nonatomic , retain) NSString *title;

@property (nonatomic , retain) NSString *date;

@property (nonatomic , retain) NSString *image;

@property (nonatomic , retain) NSString *count;

@end

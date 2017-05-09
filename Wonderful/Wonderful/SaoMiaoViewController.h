//
//  SaoMiaoViewController.h
//  Wonderful
//
//  Created by laouhn on 15/12/28.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

@interface SaoMiaoViewController : UIViewController

@property (nonatomic , strong) UIView *boxView;

@property (nonatomic , strong) CALayer *scanLayer;

@property (nonatomic , strong) AVCaptureSession *captureSession;

@property (nonatomic , strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic) BOOL isReading;

- (BOOL)startReading;

- (void)stopReading;

@end

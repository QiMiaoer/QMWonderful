
//
//  SaoMiaoViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/28.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "SaoMiaoViewController.h"

#import "SaoMiaoDetailViewController.h"

@interface SaoMiaoViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic , retain) UIView *viewPreview;

@property (nonatomic , retain) UIView *nav;

@end

@implementation SaoMiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _captureSession = nil;
    _isReading = NO;
    
    [self setViewPreview];
    
    [self startReading];
}

- (void)setViewPreview
{
    self.viewPreview = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - kScreenWidth * 2 / 3 / 2, kScreenHeight / 2 - kScreenWidth * 2 / 3 / 2, kScreenWidth * 2 / 3, kScreenWidth * 2 / 3)];
    self.viewPreview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.viewPreview];
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
    label.text = @"二维码扫描";
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    [self.nav addSubview:label];
}

- (BOOL)startReading
{
    NSError *error = nil;
    
    // 1、初始化捕捉设备 （AVCaptureDevice）， 类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"创建输入了出错，错误信息：%@", error.localizedDescription);
        return NO;
    }
    
    // 3、创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、实例化捕捉会话
    self.captureSession = [[AVCaptureSession alloc] init];
    // 4.1、将输入流添加到会话中
    [self.captureSession addInput:input];
    // 4.2 、将媒体输出流添加到会话
    [self.captureSession addOutput:captureMetadataOutput];
    
    // 5、创建串行队列，并将媒体输出流添加到队列中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create([@"myQueue" UTF8String], NULL);
    
    // 5.1、设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 5.2、设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 6、实例化预览图层
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    // 7、设置预览图层填充方式
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    // 8、设置图层的frame
    [self.videoPreviewLayer setFrame:self.viewPreview.layer.bounds];
    
    // 9、将图层添加到预览view图层上
    [self.viewPreview.layer addSublayer:self.videoPreviewLayer];
    
    // 10、设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    // 10.1 扫描框
    self.boxView = [[UIView alloc] initWithFrame:CGRectMake(self.viewPreview.bounds.size.width * 0.2f, self.viewPreview.bounds.size.height * 0.2f, self.viewPreview.bounds.size.width - self.viewPreview.bounds.size.width * 0.4f, self.viewPreview.bounds.size.height - self.viewPreview.bounds.size.height * 0.4f)];
    
    self.boxView.layer.borderColor = [[UIColor greenColor] CGColor];
    self.boxView.layer.borderWidth = 1.0f;
    [self.viewPreview addSubview:self.boxView];
    // 10.2、扫描线
    self.scanLayer = [[CALayer alloc] init];
    self.scanLayer.frame = CGRectMake(0, 0, self.boxView.bounds.size.width, 1);
    self.scanLayer.backgroundColor = [[UIColor brownColor] CGColor];
    [self.boxView.layer addSublayer:self.scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    // 11、开始扫描
    [self.captureSession startRunning];
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        // 判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {

            dispatch_sync(dispatch_get_main_queue(), ^(){
                // 这里的代码会在主线程执行                
                SaoMiaoDetailViewController *SMDVC = [[SaoMiaoDetailViewController alloc] init];
                SMDVC.url = [metadataObj stringValue];
                [self.navigationController pushViewController:SMDVC animated:YES];
            });
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            self.isReading = NO;
        }
    }
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = self.scanLayer.frame;
    if (self.boxView.frame.size.height < self.scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        self.scanLayer.frame = frame;
    } else {
        frame.origin.y += 5;
        [UIView animateWithDuration:0.11 animations:^{
            self.scanLayer.frame = frame;
        }];
    }
}

- (void)stopReading
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.scanLayer removeFromSuperlayer];
    [self.videoPreviewLayer removeFromSuperlayer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopReading];
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

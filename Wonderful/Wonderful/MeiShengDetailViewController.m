//
//  MeiShengDetailViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/18.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "MeiShengDetailViewController.h"

#import "DouFile.h"

#define kPlayOrPauseButtonWidthAndHeight 50

@interface MeiShengDetailViewController ()

@property (strong, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *progressTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *playorpause;

@property (weak, nonatomic) IBOutlet UIButton *on;

@property (weak, nonatomic) IBOutlet UIButton *next;

@property (nonatomic , strong) DOUAudioStreamer *streamer;

@property (nonatomic , retain) NSTimer *timer;

@property (nonatomic , retain) DouFile *file;

@property (nonatomic , assign) NSInteger jiShu;

@property (nonatomic , retain) UIButton *button;

@end

@implementation MeiShengDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setStreamer];
    
    [self setView];
    
    [self setBackButton];
}

- (void)setStreamer
{
    self.file = [[DouFile alloc] init];
    self.file.audioFileURL = [NSURL URLWithString:self.model.link];
    
    self.streamer = [DOUAudioStreamer streamerWithAudioFile:self.file];
    
    [self.streamer play];
    
    [self addMyTimer];
}

- (void)addMyTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
}

- (void)updateLabel
{
    CGFloat current = self.streamer.currentTime;
    CGFloat total = [[self.model.duration substringToIndex:2] floatValue] * 60 + [[self.model.duration substringWithRange:NSMakeRange(3, 2)] floatValue];
    NSInteger curr = (NSInteger)current;
//    if (self.streamer.volume <= 0.000000) {
//        self.streamer.volume = 1.000000;
//    } else {  // 音量设置
//        self.streamer.volume -= 0.1;
//        NSLog(@"%f" , self.streamer.volume);
//    }
    self.progressTimeLabel.text = [NSString stringWithFormat:@"%ld:%ld" , curr / 60 , curr % 60];
    self.progress.progress = current / total;
    if (current >= total - 3.0) {
        [self nextAction:nil];
    }
}

- (void)deleteMyTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self deleteMyTimer];
}

- (void)setView
{    
    self.backImage.alpha = .7;
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:self.model.image] placeholderImage:[UIImage imageNamed:@"wonderful1"]];
    
    [self.playorpause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.on setImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    [self.next setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        
    self.image.layer.cornerRadius = 100;
    self.image.clipsToBounds = YES;
    self.image.layer.borderColor = [[UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 225.0 alpha:1.0] CGColor];
    self.image.layer.borderWidth = 5;
    [self.image sd_setImageWithURL:[NSURL URLWithString:self.model.image] placeholderImage:[UIImage imageNamed:@"wonderful1"]];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(setTransformView) userInfo:nil repeats:YES];
    
    self.titleLabel.text = self.model.title;
    self.titleLabel.font = [UIFont systemFontOfSize:25];
    
    self.dateLabel.text = [NSString stringWithFormat:@"更新时间：%@" , self.model.date];
    self.dateLabel.font = [UIFont systemFontOfSize:20];
    
    self.contentLabel.text= self.model.content;
    self.contentLabel.numberOfLines = 0;
    
    self.totalTimeLabel.text = self.model.duration;
    
}

- (IBAction)playorpause:(id)sender {
    self.jiShu++;
    if (self.jiShu % 2 == 0) {
        [self.streamer play];
        [self.playorpause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    } else {
        [self.streamer pause];
        [self.playorpause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

- (IBAction)onAction:(id)sender {
    [self.streamer stop];
    if (self.index > 0) {
        MeiShengModel *onModel = self.sourceArray[self.index - 1];
        self.file.audioFileURL = [NSURL URLWithString:onModel.link];
        self.streamer = [DOUAudioStreamer streamerWithAudioFile:self.file];
        self.index--;
        self.progress.progress = 0;
        self.model = onModel;
        [self setView];
        [self.streamer play];
    } else {
        MeiShengModel *onModel = self.sourceArray[self.sourceArray.count - 1];
        self.file.audioFileURL = [NSURL URLWithString:onModel.link];
        self.streamer = [DOUAudioStreamer streamerWithAudioFile:self.file];
        self.index = self.sourceArray.count - 1;
        self.progress.progress = 0;
        self.model = onModel;
        [self setView];
        [self.streamer play];
    }
}

- (IBAction)nextAction:(id)sender {
    [self.streamer stop];
    if (self.index != self.sourceArray.count - 1) {
        MeiShengModel *nextModel = self.sourceArray[self.index + 1];
        self.file.audioFileURL = [NSURL URLWithString:nextModel.link];
        self.streamer = [DOUAudioStreamer streamerWithAudioFile:self.file];
        self.index ++;
        self.progress.progress = 0;
        self.model = nextModel;
        [self setView];
        [self.streamer play];
    } else {
        MeiShengModel *nextModel = self.sourceArray[0];
        self.file.audioFileURL = [NSURL URLWithString:nextModel.link];
        self.streamer = [DOUAudioStreamer streamerWithAudioFile:self.file];
        self.index = 0;
        self.progress.progress = 0;
        self.model = nextModel;
        [self setView];
        [self.streamer play];
    }
}

- (void)setTransformView
{
    self.image.transform = CGAffineTransformRotate(self.image.transform, M_PI/360);
}

- (void)setBackButton
{
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(kScreenWidth - kButtonWidthAndHeight, kScreenHeight - kButtonWidthAndHeight, kButtonWidthAndHeight, kButtonWidthAndHeight);
    [self.button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    collectionButton.frame = CGRectMake(0, kScreenHeight - kButtonWidthAndHeight, kButtonWidthAndHeight, kButtonWidthAndHeight);
    [collectionButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [self.view addSubview:collectionButton];
    [collectionButton addTarget:self action:@selector(collectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)collectionButtonAction:(UIButton *)sender
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MeiSheng" inManagedObjectContext:kGetContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortArray];
    
    NSArray *array = [kGetContext executeFetchRequest:request error:nil];
    
    BOOL isCollection = NO;
    for (MeiSheng *oneMeiWen in array) {
        
        if ([oneMeiWen.title isEqualToString:self.model.title]) {
            isCollection = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经收藏过了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    if (isCollection == NO) {
        [self collectionSave];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)collectionSave
{
    NSManagedObjectContext *context = kGetContext;
    MeiSheng *meiSheng = [NSEntityDescription insertNewObjectForEntityForName:@"MeiSheng" inManagedObjectContext:context];
    
    meiSheng.title = self.model.title;
    meiSheng.image = self.model.image;
    meiSheng.count = self.model.count;
    meiSheng.date = self.model.date;
    meiSheng.duration = self.model.duration;
    meiSheng.link = self.model.link;
    meiSheng.content = self.model.content;
    
    [kGetAppDelegate saveContext];
}

- (void)buttonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;

    self.view.backgroundColor = [UIColor orangeColor];
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


//
//  MeiWenDetailViewController.m
//  Wonderful
//
//  Created by laouhn on 15/12/17.
//  Copyright © 2015年 laouhn. All rights reserved.
//

#import "MeiWenDetailViewController.h"

@interface MeiWenDetailViewController ()<UIWebViewDelegate>

@property (nonatomic , retain) NSString *content;

@property (nonatomic , retain) UIWebView *webView;

@end

@implementation MeiWenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD show];
    
    [self getDataFromNetwork];
    
    [self setBackButton];

}

- (void)setBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(kScreenWidth - kButtonWidthAndHeight, kScreenHeight - kButtonWidthAndHeight, kButtonWidthAndHeight, kButtonWidthAndHeight);
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.webView addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    collectionButton.frame = CGRectMake(0, kScreenHeight - kButtonWidthAndHeight, kButtonWidthAndHeight, kButtonWidthAndHeight);
    [collectionButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    [self.webView addSubview:collectionButton];
    [collectionButton addTarget:self action:@selector(collectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)collectionButtonAction:(UIButton *)sender
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MeiWen" inManagedObjectContext:kGetContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortArray];
    
    NSArray *array = [kGetContext executeFetchRequest:request error:nil];
    
    BOOL isCollection = NO;
    for (MeiWen *oneMeiWen in array) {
        
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
    MeiWen *meiWen = [NSEntityDescription insertNewObjectForEntityForName:@"MeiWen" inManagedObjectContext:context];
    
    meiWen.title = self.model.title;
    meiWen.image = self.model.image;
    meiWen.count = self.model.count;
    meiWen.date = self.model.date;
    
    NSString *aidString = nil;
    if ([self.model.aid isKindOfClass:[NSNumber class]]) {
        aidString = [NSString stringWithFormat:@"%@" , self.model.aid];
    }
    if ([self.model.aid isKindOfClass:[NSString class]]) {
        meiWen.aid = self.model.aid;
    }
    if (aidString) {
        meiWen.aid = aidString;
    }
    
    [kGetAppDelegate saveContext];
}

- (void)buttonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
        self.webView.backgroundColor = [UIColor whiteColor];
        self.webView.delegate = self;
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;  // 关闭交互，例如网址点击
    }
    return _webView;
}

- (void)getDataFromNetwork
{
    [self getDataFromNetworkingWithMainUrl:kMainUrl2 andParmUrl:[NSString stringWithFormat:kRead2 , self.model.aid]];
}

- (void)getDataFromNetworkingWithMainUrl:(NSString *)mainUrl andParmUrl:(NSString *)parmUrl
{
    NSURL *url = [NSURL URLWithString:mainUrl];
    NSData *parm = [parmUrl dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:parm];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            [self parserJsonData:data];
            [SVProgressHUD dismiss];
        } else {
            NSLog(@"%@" , connectionError.localizedDescription);
        }
    }];
}

- (void)parserJsonData:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dic1 = [NSDictionary dictionary];
    for (NSString *key in dic) {
        if ([key isEqualToString:@"result"]) {
            NSDictionary *dic2 = dic[key];
            for (NSString *key1 in dic2) {
                if ([key1 isEqualToString:@"article"]) {
                    dic1 = dic2[key1];
                }
            }
        }
    }

    for (NSString *key in dic1) {
        if ([key isEqualToString:@"content"]) {
            self.content = dic1[key];
        }
    }
    
    self.content = [self.content stringByReplacingOccurrencesOfString:@"<p>欢迎订阅优美时光官方微信公众账号：umeitime</p>" withString:@"<p></p>"];
    self.content = [self.content stringByReplacingOccurrencesOfString:@"href" withString:@""];
    NSString *headstr = @"<!DOCTYPE html><!--STATUS OK--><html><head><meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=Edge\"></head><body bgcolor=\"blanchedalmond\">";
    NSString *bottomstr = @"</body></html>";
    
    NSString *html1 = [headstr stringByAppendingString:self.content];
    NSString *html2 = [html1 stringByAppendingString:bottomstr];
    
    NSString *html3 = [html2 stringByReplacingOccurrencesOfString:@"<imgb" withString:@"<img b"];

//    NSLog(@"%@" , html3);
    
    [self.webView loadHTMLString:html3 baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 设置网页中图片的大小
    NSString * script = [NSString stringWithFormat: @"var script = document.createElement('script');"
                         "script.type = 'text/javascript';"
                         "script.text = \"function ResizeImages() { "
                         "var myimg;"
                         "var maxwidth= %f;" //屏幕宽度
                         "for(i=0;i <document.images.length;i++){"
                         "myimg = document.images[i];"
                         "myimg.height = maxwidth / (myimg.width/myimg.height);"
                         "myimg.width = maxwidth;"
                         "}"
                         "}\";"
                         "document.getElementsByTagName('p')[0].appendChild(script);",kScreenWidth - 15];
    //添加JS
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    //添加调用JS执行的语句
    [self.webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
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

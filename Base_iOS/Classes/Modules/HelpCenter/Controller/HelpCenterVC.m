//
//  HelpCenterVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HelpCenterVC.h"

//Macro
#import "APICodeMacro.h"
//Framework
#import <WebKit/WebKit.h>
//Category
#import "UIBarButtonItem+convience.h"
////Extension
////M
//#import "QuestionModel.h"
////V
//#import "HelpCenterTableView.h"
////C
//#import "LinkServiceVC.h"

@interface HelpCenterVC ()<WKNavigationDelegate>
//
//@property (nonatomic, strong) HelpCenterTableView *tableView;
@property (nonatomic, copy) NSString *htmlStr;
//
@property (nonatomic, strong) WKWebView *webView;
//联系电话
@property (nonatomic, copy) NSString *mobile;

@end

@implementation HelpCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助中心";
    
    //联系客服
    [self initItem];
    //
    [self requestContent];
    //获取客服电话
    [self requestServiceMobile];
    //    //问题列表
    //    [self initTableView];
    //    //获取问题列表
    //    [self requestQuestionList];
}

#pragma mark - Init
- (void)initItem {

    [UIBarButtonItem addRightItemWithTitle:@"联系客服" titleColor:kWhiteColor frame:CGRectMake(0, 0, 70, 44) vc:self action:@selector(linkService)];
}
//
//- (void)initTableView {
//
//    self.tableView = [[HelpCenterTableView alloc] init];
//
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//
//    }];
//}

#pragma mark - Events
- (void)linkService {

    NSString *mobile = [NSString stringWithFormat:@"telprompt://%@", self.mobile];
    
    NSURL *url = [NSURL URLWithString:mobile];
    
    [[UIApplication sharedApplication] openURL:url];
}
//
//#pragma mark - Data
//- (void)requestQuestionList {
//
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i = 0; i < 4; i++) {
//
//        QuestionModel *question = [QuestionModel new];
//
//        question.title = @"美业销帮是什么?";
//        question.content = @"我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？我们有什么优势呢？";
//        [arr addObject:question];
//
//    }
//    self.tableView.questions = arr;
//
//}


#pragma mark - 富文本
#pragma mark - Data

- (void)requestContent {
    
    NSString *ckey = @"FAQ";
    
    NSString *name = @"帮助中心";
    
    self.navigationItem.titleView = [UILabel labelWithTitle:name frame:CGRectMake(0, 0, 200, 44)];
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CKEY_CVALUE;
    
    http.parameters[@"ckey"] = ckey;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.htmlStr = responseObject[@"data"][@"cvalue"];
        
        [self initWebView];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestServiceMobile {
    
    NSString *ckey = @"telephone";
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = USER_CKEY_CVALUE;
    
    http.parameters[@"ckey"] = ckey;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.mobile = responseObject[@"data"][@"cvalue"];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Init

- (void)initWebView {
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:_webView];
    
    [self loadWebWithString:self.htmlStr];
}

- (void)loadWebWithString:(NSString *)string {
    
    NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, string];
    
    [_webView loadHTMLString:html baseURL:nil];
}

#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        [self changeWebViewHeight:string];
    }];
    
}

- (void)changeWebViewHeight:(NSString *)heightStr {
    
    CGFloat height = [heightStr integerValue];
    
    // 改变webView和scrollView的高度
    
    _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, height);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

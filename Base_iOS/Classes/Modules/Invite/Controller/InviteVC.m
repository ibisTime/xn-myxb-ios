//
//  InviteVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/7.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InviteVC.h"

//Manager
#import "AppConfig.h"
#import "TLWXManager.h"
//Macro
#import "APICodeMacro.h"
//Category
#import "NSString+CGSize.h"
#import "UILabel+Extension.h"
#import "UIBarButtonItem+convience.h"
#import <UIScrollView+TLAdd.h>
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
//M
#import "BannerModel.h"
//V
#import "ShareView.h"
#import "TLBannerView.h"
#import "QRCodeView.h"
#import "DetailWebView.h"
//C
#import "TLUserLoginVC.h"
#import "NavigationController.h"

@interface InviteVC ()

//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//图片
@property (nonatomic,strong) NSMutableArray *bannerPics;
//说明
@property (nonatomic, copy) NSString *remark;
//
@property (nonatomic, strong) QRCodeView *qrCodeView;
//分享链接
@property (nonatomic, copy) NSString *shareUrl;
//活动规则
@property (nonatomic, strong) DetailWebView *activityRuleView;

//滚动图
@property (nonatomic, strong) UIScrollView *scrollView;
//邀请人数
@property (nonatomic, strong) UILabel *numLbl;
//收益
@property (nonatomic, strong) UILabel *profitLbl;

@end

@implementation InviteVC

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //获取活动规则
    [self requestActivityRule];
    //获取邀请人数和收益
//    [self requestInviteNumber];
    //获取分享链接
    [self getShareUrl];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请好友";
    
    //scrollview
    [self initScrollView];
    //
    [self initSubviews];
    //获取banner图
    [self getBanner];
    
}
#pragma mark - Init
- (QRCodeView *)qrCodeView {
    
    if (!_qrCodeView) {
        
        _qrCodeView = [[QRCodeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:_qrCodeView];
    }
    return _qrCodeView;
}

- (DetailWebView *)activityRuleView {

    if (!_activityRuleView) {

        BaseWeakSelf;
        
        _activityRuleView = [[DetailWebView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 50, 80)];
        
        [_activityRuleView setOpaque:NO];
        
        _activityRuleView.webViewBlock = ^(CGFloat height) {
            
            [weakSelf setSubViewLayoutWithHeight:height];
        };
        
    }
    return _activityRuleView;
}

- (void)initScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView adjustsContentInsets];
    
    [self.view addSubview:self.scrollView];
    
}

- (void)initBannerView {
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(146 + kNavigationBarHeight))];
    
    [self.scrollView addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initSubviews {
    
    self.view.backgroundColor = kWhiteColor;
    
    CGFloat leftMargin = 15;
    
    UIImageView *inviteIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(146 + kNavigationBarHeight))];
    
    inviteIV.image = kImage(@"邀请注册");
    
    [self.scrollView addSubview:inviteIV];
    
    //title
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(0, kNavigationBarHeight - 44, kScreenWidth, 44)
                                   textAligment:NSTextAlignmentCenter
                                backgroundColor:kClearColor
                                           font:Font(18)
                                      textColor:kWhiteColor];
    
    titleLbl.text = @"邀请好友";
    
    [self.scrollView addSubview:titleLbl];
    
    //提成收益
    UIView *profitView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, inviteIV.yy + 15, kScreenWidth - 2*leftMargin, .1/*100*/)];//暂时隐藏 高度为1
    profitView.clipsToBounds = YES;
    profitView.backgroundColor = [UIColor colorWithHexString:@"#fff9eb"];
    profitView.layer.shadowOffset = CGSizeMake(4, 4);
    profitView.layer.shadowOpacity = 1.0f;
    profitView.layer.shadowColor = kBackgroundColor.CGColor;
    
    [self.scrollView addSubview:profitView];
    
    //邀请人数
    UILabel *personTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kThemeColor
                                                          font:12.0];
    
    personTextLbl.text = @"成功邀请（人）";
    personTextLbl.textAlignment = NSTextAlignmentCenter;
    
    [profitView addSubview:personTextLbl];
    [personTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(profitView.mas_centerX).offset(-profitView.width/4.0);
        make.top.equalTo(@25);
        
    }];
    
    self.numLbl = [UILabel labelWithBackgroundColor:kClearColor
                                          textColor:kTextColor
                                               font:16.0];
    
    self.numLbl.textAlignment = NSTextAlignmentCenter;
    
    [profitView addSubview:self.numLbl];
    [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(personTextLbl.mas_bottom).offset(18);
        make.centerX.equalTo(profitView.mas_centerX).offset(-profitView.width/4.0);
        
    }];
    
    //收益
    UILabel *countTextLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kThemeColor
                                                         font:12.0];
    
    countTextLbl.text = @"提成收益（积分）";
    countTextLbl.textAlignment = NSTextAlignmentCenter;
    
    [profitView addSubview:countTextLbl];
    [countTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(profitView.mas_centerX).offset(profitView.width/4.0);
        make.top.equalTo(@25);
        
    }];
    
    self.profitLbl = [UILabel labelWithBackgroundColor:kClearColor
                                             textColor:kTextColor
                                                  font:16.0];
    
    self.profitLbl.textAlignment = NSTextAlignmentCenter;
    
    [profitView addSubview:self.profitLbl];
    [self.profitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(personTextLbl.mas_bottom).offset(18);
        make.centerX.equalTo(profitView.mas_centerX).offset(profitView.width/4.0);
        
    }];
    
    //分享链接
    UIButton *urlBtn = [UIButton buttonWithTitle:@"分享链接"
                                            titleColor:kWhiteColor
                                       backgroundColor:kThemeColor
                                             titleFont:kWidth(18)
                                          cornerRadius:21];
    
    [urlBtn addTarget:self action:@selector(shareLink) forControlEvents:UIControlEventTouchUpInside];
    urlBtn.frame = CGRectMake(kWidth(40), profitView.yy + 25, kWidth(130), 42);
    
    [self.scrollView addSubview:urlBtn];
    
    //分享二维码
    UIButton *qrCodeBtn = [UIButton buttonWithTitle:@"分享二维码"
                                            titleColor:kWhiteColor
                                       backgroundColor:kThemeColor
                                             titleFont:kWidth(18)
                                          cornerRadius:21];
    
    [qrCodeBtn addTarget:self action:@selector(shareQRCode) forControlEvents:UIControlEventTouchUpInside];
    qrCodeBtn.frame = CGRectMake(urlBtn.xx + kWidth(35), profitView.yy + kWidth(25), kWidth(130), 42);
    
    [self.scrollView addSubview:qrCodeBtn];
    //活动规则
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"活动规则")];
    
    iconIV.frame = CGRectMake(0, qrCodeBtn.yy + kWidth(35), 105, 12);
    iconIV.centerX = self.view.centerX;
    
    [self.scrollView addSubview:iconIV];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:kWidth(15)];
    
    textLbl.text = @"活动规则";
    textLbl.textAlignment = NSTextAlignmentCenter;
    textLbl.frame = CGRectMake(0, qrCodeBtn.yy + kWidth(35), 100, kWidth(15));
    textLbl.centerX = self.view.centerX;
    textLbl.centerY = iconIV.centerY;
    
    [self.scrollView addSubview:textLbl];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, textLbl.yy + kHeight(24), kScreenWidth, 100)];
    
    blueView.tag = 2200;
    blueView.hidden = YES;
    
    [self.scrollView addSubview:blueView];
    
    //活动规则
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftMargin, 0, kScreenWidth - 2*leftMargin, 100)];
    
    bgView.tag = 1200;
    bgView.backgroundColor = [UIColor colorWithHexString:@"#fff9eb"];
    bgView.layer.shadowOffset = CGSizeMake(4, 4);
    bgView.layer.shadowOpacity = 1.0f;
    bgView.layer.shadowColor = kBackgroundColor.CGColor;
    
    [blueView addSubview:bgView];
    //
    [bgView addSubview:self.activityRuleView];
    
}

#pragma mark - Setting
- (void)setRemark:(NSString *)remark {
    
    _remark = remark;
    
    [self.activityRuleView loadWebWithString:remark];
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    UIView *blueView = [self.scrollView viewWithTag:2200];
    UIView *bgView = [blueView viewWithTag:1200];

    self.activityRuleView.webView.scrollView.height = height;
    self.activityRuleView.webView.height = height;
    self.activityRuleView.height = height;

    blueView.height = height + 20;
    bgView.height = height + 20;
    blueView.hidden = NO;
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, blueView.yy);
}

#pragma mark - Events
//- (void)historyFriends {
//
//    BaseWeakSelf;
//
//    if (![TLUser user].isLogin) {
//
//        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
//
//        loginVC.loginSuccess = ^{
//
//            [weakSelf historyFriends];
//        };
//
//        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
//
//        [self presentViewController:nav animated:YES completion:nil];
//
//        return;
//    }
//
//    HistoryInviteVC *inviteVC = [HistoryInviteVC new];
//
//    [self.navigationController pushViewController:inviteVC animated:YES];
//}

- (void)shareLink {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf shareLink];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    //判断是否安装微信
    if (![TLWXManager judgeAndHintInstalllWX]) {
        
        return ;
    }
    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) shareBlock:^(BOOL isSuccess, int errorCode) {
        
        if (isSuccess) {
            
            [TLAlert alertWithSucces:@"分享成功"];
            
        } else {
            
            [TLAlert alertWithError:@"分享失败"];
        }
        
    }];
    
    shareView.shareTitle = @"邀请好友";
    shareView.shareDesc = @"快邀请好友来玩吧";
    shareView.shareURL = self.shareUrl;
    
    [self.view addSubview:shareView];
}

- (void)shareQRCode {
    
    BaseWeakSelf;
    
    if (![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [[TLUserLoginVC alloc] init];
        
        loginVC.loginSuccess = ^{
            
            [weakSelf shareQRCode];
        };
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    [self.qrCodeView show];
}

#pragma mark - Data
- (void)getBanner {
    
    //广告图
    __weak typeof(self) weakSelf = self;
    
    TLNetworking *http = [TLNetworking new];
    //806052
    http.code = @"805806";
    http.parameters[@"type"] = @"2";
    http.parameters[@"location"] = @"activity";
    
    [http postWithSuccess:^(id responseObject) {
        
        weakSelf.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //组装数据
        weakSelf.bannerPics = [NSMutableArray arrayWithCapacity:weakSelf.bannerRoom.count];
        
        //取出图片
        [weakSelf.bannerRoom enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf.bannerPics addObject:[obj.pic convertImageUrl]];
        }];
        
        weakSelf.bannerView.imgUrls = weakSelf.bannerPics;
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)requestInviteNumber {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805703";
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        //收益
        NSNumber *profit = responseObject[@"data"][@"totalAmount"];
        
        self.profitLbl.text = [profit convertToRealMoney];
        //邀请人数
        NSNumber *inviteNum = responseObject[@"data"][@"totalUser"];
        
        self.numLbl.text = [inviteNum stringValue];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestActivityRule {
    
    TLNetworking *http = [TLNetworking new];

    http.code = USER_CKEY_CVALUE;
    http.parameters[@"ckey"] = @"ACT_RULE";

    [http postWithSuccess:^(id responseObject) {

        self.remark = responseObject[@"data"][@"cvalue"];

    } failure:^(NSError *error) {

    }];
}

- (void)getShareUrl {
    
    NSString *shareStr = [NSString stringWithFormat:@"%@%@", [AppConfig config].shareBaseUrl, [TLUser user].userId];
    
    self.shareUrl = shareStr;
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    http.parameters[@"ckey"] = @"SHARE_URL";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *url = responseObject[@"data"][@"cvalue"];
        
        NSString *shareStr = [NSString stringWithFormat:@"%@?userReferee=%@&kind=%@", url, [TLUser user].mobile, [TLUser user].kind];
        //
        self.shareUrl = shareStr;
        
        self.qrCodeView.url = self.shareUrl;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

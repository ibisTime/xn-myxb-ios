//
//  HomeVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomeVC.h"

//Manager
#import "AppConfig.h"
//Macro
//Framework
//Category
#import "UIButton+EnLargeEdge.h"
//Extension
#import "MJRefresh.h"
//M
#import "BannerModel.h"
#import "NoticeModel.h"
//V
#import "HomeScrollView.h"
#import "TLBannerView.h"
#import "LoopScrollView.h"
//C
#import "WebVC.h"
#import "SystemNoticeVC.h"

@interface HomeVC ()<UIScrollViewDelegate>

//滚动视图
@property (nonatomic, strong) HomeScrollView *scrollView;
//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//图片
@property (nonatomic,strong) NSMutableArray *bannerPics;
//头条
@property (nonatomic, strong) UIView *headLineView;
@property (nonatomic, strong) UIButton *headBtn;
//系统消息
@property (nonatomic,strong) NSMutableArray <NoticeModel *>*notices;

@end

@implementation HomeVC

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //系统消息
    [self requestNoticeList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    
    [self initScrollView];
    //添加下拉刷新
    [self addDownRefresh];
    //轮播图
    [self initBannerView];
    //头条
    [self initHeadLineView];
    
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    
}

#pragma mark - Init
- (void)addDownRefresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(clickRefresh)];
    
    self.scrollView.mj_header = header;
}

- (void)initScrollView {
    
    self.scrollView = [[HomeScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kBottomInsetHeight - kTabBarHeight)];
    
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
}

- (void)initBannerView {
    
    BaseWeakSelf;
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(185))];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (!(weakSelf.bannerRoom[index].url && weakSelf.bannerRoom[index].url.length > 0)) {
            return ;
        }
        
        WebVC *webVC = [WebVC new];
        
        webVC.url = weakSelf.bannerRoom[index].url;
        
        [weakSelf.navigationController pushViewController:webVC animated:YES];
        
    };
    
    bannerView.imgUrls = @[@"健康专家"];
    
    [self.scrollView addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initHeadLineView {
    
    BaseWeakSelf;
    
    self.headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, 50)];
    
    self.headLineView.backgroundColor = kWhiteColor;
    
    //背景
    LoopScrollView *loopView = [LoopScrollView loopTitleViewWithFrame:CGRectMake(15, 0, kScreenWidth - 2*15, 50) titleImgArr:nil];
    
    loopView.timeinterval = 3.f;
    
    loopView.titlesArr = @[@"我淘网上线啦！！！", @"倍可盈上线啦！！！", @"九州宝上线啦！！！", @"健康e购上线啦！！！"];
    
    loopView.leftImage = kImage(@"我淘头条");
    
    loopView.loopBlock = ^{
        
        SystemNoticeVC *noticeVC = [SystemNoticeVC new];
        
        [weakSelf.navigationController pushViewController:noticeVC animated:YES];
    };
    
    loopView.layer.borderWidth = 0.5;
    loopView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    
    [self.headLineView addSubview:loopView];
    
    //更多
    UIImageView *moreIV = [[UIImageView alloc] init];
    
    moreIV.image = kImage(@"更多");
    
    moreIV.frame = CGRectMake(loopView.width - 17, 0, 7, 12);
    
    moreIV.centerY = loopView.centerY;
    
    [loopView addSubview:moreIV];
    
    UIButton *contentBtn = [UIButton buttonWithTitle:@"" titleColor:kTextColor backgroundColor:kClearColor titleFont:14.0];
    
    [loopView addSubview:contentBtn];
    
    self.headBtn = contentBtn;
    
    [self.scrollView addSubview:self.headLineView];
}

#pragma mark - Data
- (void)requestNoticeList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"804040";
    if ([TLUser user].token) {
        
        helper.parameters[@"token"] = [TLUser user].token;
    }
    helper.parameters[@"channelType"] = @"4";
    
    helper.parameters[@"pushType"] = @"41";
    helper.parameters[@"toKind"] = @"C";    //C端
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"20";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    [helper modelClass:[NoticeModel class]];
    
    //消息数据
    [helper refresh:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
        
        [self removePlaceholderView];
        
        weakSelf.notices = objs;
        
        if (weakSelf.notices.count > 0) {
            
            NoticeModel *notice = weakSelf.notices[0];
            
            [self.headBtn setTitle:notice.smsTitle forState:UIControlStateNormal];
            
        } else {
            
            [self.headBtn setTitle:@"无" forState:UIControlStateNormal];
            
        }
        
        [self.headBtn setTitleLeft];
        
    } failure:^(NSError *error) {
        
        [self addPlaceholderView];

    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

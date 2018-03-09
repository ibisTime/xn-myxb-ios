//
//  HomeHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomeHeaderView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//Category
#import "UIButton+EnLargeEdge.h"

//V
#import "LoopScrollView.h"
#import "CategoryItem.h"
#import "TLBannerView.h"

@interface HomeHeaderView()
//头条
@property (nonatomic, strong) UIView *headLineView;
@property (nonatomic, strong) LoopScrollView *loopView;
//分类
@property (nonatomic, strong) UIView *categoryView;
//推荐品牌
@property (nonatomic, strong) UIView *titleView;
//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;

@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //轮播图
        [self initBannerView];
        //头条
        [self initHeadLineView];
        //分类
        [self initCategoryView];
        //推荐品牌
        [self initTitleView];
    }
    return self;
}

#pragma mark - Init
- (void)initBannerView {
    
    BaseWeakSelf;
    
    //顶部轮播
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(185))];
    
    bannerView.selected = ^(NSInteger index) {
        
        if (weakSelf.headerBlock) {
            
            weakSelf.headerBlock(HomeEventsTypeBanner, index);
        }
    };
    
    [self addSubview:bannerView];
    
    self.bannerView = bannerView;
}

- (void)initHeadLineView {
    
    BaseWeakSelf;
    
    self.headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bannerView.yy, kScreenWidth, 50)];
    
    self.headLineView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.headLineView];
    //背景
    LoopScrollView *loopView = [LoopScrollView loopTitleViewWithFrame:CGRectMake(0, 0, kScreenWidth, 50)
                                                          titleImgs:nil];
    
    loopView.timeinterval = 3.f;
    loopView.leftImage = kImage(@"msg_logo");
    loopView.count = 3;
    loopView.loopBlock = ^{
        
        if (weakSelf.headerBlock) {
            
            weakSelf.headerBlock(HomeEventsTypeNotice, 0);
        }
    };
    
    loopView.layer.borderWidth = 0.5;
    loopView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    
    [self.headLineView addSubview:loopView];
    self.loopView = loopView;

    //更多
    UIImageView *moreIV = [[UIImageView alloc] init];
    
    moreIV.image = kImage(@"更多-灰色");
    moreIV.frame = CGRectMake(loopView.width - 17, 0, 7, 12);
    moreIV.centerY = loopView.centerY;
    
    [loopView addSubview:moreIV];

}

- (void)initCategoryView {
    
    self.categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headLineView.yy + 1, kScreenWidth, 105)];
    [self addSubview:self.categoryView];
    NSArray *titleArr = @[@"品牌", @"美导", @"讲师", @"专家"];
    NSArray *imgArr = @[@"品牌", @"美导", @"讲师", @"专家"];
    
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat w = kScreenWidth/4.0;
        CGFloat h = 105;
        CGFloat x = idx*w;
        
        CategoryItem *item = [[CategoryItem alloc] initWithFrame:CGRectMake(x, 0, w, h)];
        
        item.title = titleArr[idx];
        item.icon = imgArr[idx];
        item.tag = 1200 + idx;
        
        [self.categoryView addSubview:item];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        
        [item addGestureRecognizer:tapGR];
        
    }];
}

- (void)initTitleView {
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.categoryView.yy + 10, kScreenWidth, 50)];
    self.titleView.backgroundColor = kWhiteColor;
    
    [self addSubview:self.titleView];
    
    //
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentCenter
                            backgroundColor:kClearColor
                                       font:Font(17.0)
                                  textColor:kTextColor];
    
    titleLbl.text = @"推荐品牌";
    [self.titleView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@10);
        make.centerY.equalTo(@0);
    }];
    //
    UIView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"推荐品牌")];
    
    [self.titleView addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(titleLbl.mas_left).offset(-10);
        make.centerY.equalTo(@0);
    }];
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self.titleView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
}

#pragma mark - Setting
- (void)setNotices:(NSMutableArray<NoticeModel *> *)notices {
    
    _notices = notices;
    
    NSMutableArray *titleArr = [NSMutableArray array];
    
    if (notices.count == 0) {
        
        [titleArr addObject:@"无"];
    }
    [notices enumerateObjectsUsingBlock:^(NoticeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [titleArr addObject:obj.smsTitle];
    }];
    
    self.loopView.titles = titleArr;

}

- (void)setBanners:(NSMutableArray<BannerModel *> *)banners {
    
    _banners = banners;
    
    NSMutableArray *imgUrls = [NSMutableArray array];
    [banners enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.pic) {
            
            [imgUrls addObject:obj.pic];
        }
    }];
    self.bannerView.imgUrls = imgUrls;
    
}

#pragma mark - Events
- (void)clickItem:(UITapGestureRecognizer *)tapGR {
    
    NSInteger index = tapGR.view.tag - 1200;
    
    if (self.headerBlock) {
        
        self.headerBlock(HomeEventsTypeCategory, index);
    }
}

@end

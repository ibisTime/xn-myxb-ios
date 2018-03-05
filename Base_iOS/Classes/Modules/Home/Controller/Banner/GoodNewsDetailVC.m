//
//  GoodNewsDetailVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "GoodNewsDetailVC.h"
//Category
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "UILabel+Extension.h"
#import <UIImageView+WebCache.h>
#import "NSNumber+Extension.h"
//M
#import "BannerModel.h"
//V
#import "GoodNewsTableView.h"
#import "TLBannerView.h"
#import "DetailWebView.h"

@interface GoodNewsDetailVC ()
//轮播图
@property (nonatomic,strong) TLBannerView *bannerView;
//
@property (nonatomic, strong) GoodNewsTableView *tableView;
//图文详情
@property (nonatomic, strong) DetailWebView *detailWebView;

@end

@implementation GoodNewsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.type isEqualToString:kBannerTypeGoodNews] ? @"喜报详情": @"预报详情";
    //
    [self initTableView];
}

#pragma mark - Init

- (TLBannerView *)bannerView {
    
    if (!_bannerView) {
        
        _bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCarouselHeight)];
    }
    return _bannerView;
}

- (DetailWebView *)detailWebView {
    
    if (!_detailWebView) {
        
        BaseWeakSelf;
        
        _detailWebView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
        
        _detailWebView.webViewBlock = ^(CGFloat height) {
            
            [weakSelf setSubViewLayoutWithHeight:height];
        };
    }
    return _detailWebView;
}

- (void)initTableView {
    
    self.tableView = [[GoodNewsTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    
    self.tableView.newsList = @[self.news].mutableCopy;
    self.tableView.isDetail = YES;
    self.tableView.tableHeaderView = self.bannerView;
    [self.detailWebView loadWebWithString:self.news.desc];
    self.tableView.tableFooterView = self.detailWebView;

    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    self.detailWebView.webView.scrollView.height = height;
    self.detailWebView.height = height;
    
    self.tableView.tableFooterView = self.detailWebView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

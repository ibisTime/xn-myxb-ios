//
//  BaseCollectionView.m
//  ZhiYou
//
//  Created by 蔡卓越 on 16/1/13.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "BaseCollectionView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#define identifierDeafaultCollect @"identifierDeafaultCollect"

@implementation BaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        [self _initWithCollectionView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self _initWithCollectionView];
}

/**
 *  初始化 collectionview
 */
- (void)_initWithCollectionView {
    
    self.datas = [NSMutableArray array];
    self.dataArrays = [NSMutableArray array];
    self.selectGoods = [NSMutableArray array];
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = kWhiteColor;
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifierDeafaultCollect];
}

- (void)setRefreshDelegate:(id<RefreshCollectionViewDelegate>)refreshDelegate refreshHeadEnable:(BOOL)headEnable refreshFootEnable:(BOOL)footEnable autoRefresh:(BOOL)autoRefresh {
    
    self.refreshDelegate = refreshDelegate;
    self.refreshHeadEnable = headEnable;
    self.refreshFootEnable = footEnable;
    if (autoRefresh) {
        [self autoRefreshHead];
    }
}

- (void)setRefreshHeadEnable:(BOOL)refreshHeadEnable {
    _refreshHeadEnable = refreshHeadEnable;
    if (self.refreshHeadEnable) {
        __weak typeof(self) weakSelf = self;
        // 添加传统的下拉刷新
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshHeadCompelete];
        }];
        
    } else {
        if ([self.mj_header superview] != nil) {
            [self.mj_header removeFromSuperview];
        }
    }
}

- (void)setRefreshFootEnable:(BOOL)refreshFootEnable {
    _refreshFootEnable = refreshFootEnable;
    if (self.refreshFootEnable) {
        __weak typeof(self) weakSelf = self;
        
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf refreshFootCompelete];
        }];


//        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf refreshFootCompelete];
//        }];
        
        MJRefreshAutoFooter *autoFooter = (MJRefreshAutoFooter*)(self.mj_footer);
        autoFooter.automaticallyHidden = YES;
        
        
        MJRefreshBackNormalFooter *footer = (MJRefreshBackNormalFooter*)self.mj_footer;
        [footer setTitle:@"哎呀~~\n下面没有了" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.numberOfLines = 0;

    }
    else {
        if ([self.mj_footer superview] != nil) {
            [self.mj_footer removeFromSuperview];
        }
    }
}

/**
 *  自动下拉刷新
 */
- (void)autoRefreshHead {
    [self.mj_header beginRefreshing];
}

/**
 *  下拉刷新完成
 */
- (void)refreshHeadCompelete {
    [self.mj_header endRefreshing];
    if ([self.refreshDelegate respondsToSelector:@selector(refreshCollectionViewPullDown:)]) {
        [self.refreshDelegate refreshCollectionViewPullDown:self];
    }
}

/**
 *  上拉加载完成
 */
- (void)refreshFootCompelete {
    [self.mj_footer endRefreshing];
    if ([self.refreshDelegate respondsToSelector:@selector(refreshCollectionViewPullUp:)]) {
        [self.refreshDelegate refreshCollectionViewPullUp:self];
    }
}

/**
 * 上拉加载完成设置无数据的状态
 */
- (void)noDataTips {
    [self.mj_footer endRefreshingWithNoMoreData];
}

/**
 *  消除无数据的状态
 */
- (void)resetDataTips {
    
    [self.mj_footer resetNoMoreData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
   return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.refreshDelegate respondsToSelector:@selector(refreshCollectionView:didSelectRowAtIndexPath:)]) {
        [self.refreshDelegate refreshCollectionView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end

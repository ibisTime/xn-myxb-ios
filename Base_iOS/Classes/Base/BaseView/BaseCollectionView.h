//
//  BaseCollectionView.h
//  ZhiYou
//
//  Created by 蔡卓越 on 16/1/13.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

@class BaseCollectionView;


@protocol RefreshCollectionViewDelegate <NSObject>

@optional
/**
 *  下拉刷新
 */
- (void)refreshCollectionViewPullDown:(BaseCollectionView*)refreshCollectionView;
/**
 *  上拉刷新
 */
- (void)refreshCollectionViewPullUp:(id)refreshCollectionView;
/**
 *选中Cell时
 */
- (void)refreshCollectionView:(BaseCollectionView*)refreshCollectionview didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
/* 选中cell上的button时可使用 */
- (void)refreshCollectionViewButtonClick:(BaseCollectionView *)refreshCollectionView WithButton:(UIButton *)sender SelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface BaseCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *datas;  //数据源
@property (nonatomic, strong) NSMutableArray *dataArrays;  //数据源2
@property (nonatomic, strong) NSMutableArray *selectGoods;  //数据源3

@property (nonatomic, weak)   id<RefreshCollectionViewDelegate> refreshDelegate;  //代理

@property (nonatomic, assign) BOOL refreshHeadEnable;  //上拉刷新开关

@property (nonatomic, assign) BOOL refreshFootEnable;  //下拉刷新开关


/**
 *  设置collectionView刷新属性
 *
 *  @param refreshDelegate 刷新代理
 *  @param headEnable      是否开启下拉刷新
 *  @param footEnable      是否开启上拉加载
 *  @param autoRefresh     是否自动刷新
 */

- (void)setRefreshDelegate:(id<RefreshCollectionViewDelegate> _Nullable)refreshDelegate refreshHeadEnable:(BOOL)headEnable refreshFootEnable:(BOOL)footEnable autoRefresh:(BOOL)autoRefresh;

/**
 *  自动下拉刷新
 */
- (void)autoRefreshHead;
/**
 *  下拉刷新完成
 */
- (void)refreshHeadCompelete;
/**
 *  下拉刷新完成
 */
- (void)refreshFootCompelete;
/**
 *  上拉加载完成设置无数据状态
 */
- (void)noDataTips;

/**
 *  消除无数据状态
 */
- (void)resetDataTips;


@end

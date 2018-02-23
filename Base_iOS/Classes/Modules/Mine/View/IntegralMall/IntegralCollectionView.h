//
//  IntegralCollectionView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseCollectionView.h"
//V
#import "IntegralMallHeaderView.h"
//M
#import "IntegralModel.h"

@interface IntegralCollectionView : BaseCollectionView
//头部
@property (nonatomic, strong) IntegralMallHeaderView *headerView;
//
@property (nonatomic, strong) NSArray <IntegralModel *>*integralGoods;

@end

//
//  HomeCollectionView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BrandModel.h"
#import "HomeHeaderView.h"

typedef void(^HomeBlock)(NSIndexPath *indexPath);

@interface HomeCollectionView : UICollectionView
//
@property (nonatomic, strong) HomeHeaderView *headerView;
//品牌列表
@property (nonatomic, strong) NSArray <BrandModel *>*brands;
//
@property (nonatomic, copy) HomeBlock homeBlock;

@end

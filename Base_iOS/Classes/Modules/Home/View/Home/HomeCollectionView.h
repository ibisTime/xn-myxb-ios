//
//  HomeCollectionView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
//V
#import "BaseCollectionView.h"
#import "HomeHeaderView.h"

//M
#import "BrandModel.h"

typedef void(^HomeBlock)(NSIndexPath *indexPath);

@interface HomeCollectionView : BaseCollectionView
//
@property (nonatomic, strong) HomeHeaderView *headerView;
//品牌列表
@property (nonatomic, strong) NSArray <BrandModel *>*brands;
//
@property (nonatomic, copy) HomeBlock homeBlock;

@end

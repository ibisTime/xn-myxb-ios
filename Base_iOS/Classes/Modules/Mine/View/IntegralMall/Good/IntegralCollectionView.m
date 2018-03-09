//
//  IntegralCollectionView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralCollectionView.h"

//Category
#import "UIControl+Block.h"
//V
#import "IntegralGoodCell.h"

@interface IntegralCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation IntegralCollectionView

static NSString *integralGoodCellID = @"IntegralGoodCellID";
static NSString *headerViewID = @"IntegralMallHeaderViewID";
static NSString *placeholderViewID = @"placeholderViewID";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        [self registerClass:[IntegralGoodCell class] forCellWithReuseIdentifier:integralGoodCellID];
        
        [self registerClass:[IntegralMallHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:placeholderViewID];

        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //--//
    return self.integralGoods.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;
    
    IntegralGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:integralGoodCellID forIndexPath:indexPath];
    
    cell.integralModel = self.integralGoods[indexPath.row];
    
    [cell.exchangeBtn bk_addEventHandler:^(id sender) {
        
        if (weakSelf.refreshDelegate && [weakSelf.refreshDelegate respondsToSelector:@selector(refreshCollectionViewButtonClick:WithButton:SelectRowAtIndexPath:)]) {
            
            [weakSelf.refreshDelegate refreshCollectionViewButtonClick:weakSelf WithButton:sender SelectRowAtIndexPath:indexPath];
        };
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshCollectionView:didSelectRowAtIndexPath:)]) {
        
        [self.refreshDelegate refreshCollectionView:self didSelectRowAtIndexPath:indexPath];
    };
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    IntegralMallHeaderView *cell;

    if (kind == UICollectionElementKindSectionHeader) {
        
        cell = (IntegralMallHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        
        [cell changeInfo];

        self.headerView = cell;
        
        return cell;
    }
    
    CGFloat height = self.integralGoods.count == 0 ? 200: 0.1;

    if (self.reusableView) {
        
        return self.reusableView;
    }
    
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:placeholderViewID forIndexPath:indexPath];
    
    reusableView.frame = CGRectMake(0, 140, kScreenWidth, height);
    reusableView.hidden = YES;
    
    UIImageView *orderIV = [[UIImageView alloc] init];
    orderIV.image = kImage(@"暂无订单");
    orderIV.centerX = kScreenWidth/2.0;
    
    [reusableView addSubview:orderIV];
    [orderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@50);
        
    }];
    
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    textLbl.text = @"暂无积分商品";
    textLbl.textAlignment = NSTextAlignmentCenter;
    
    [reusableView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(orderIV.mas_bottom).offset(20);
        make.centerX.equalTo(orderIV.mas_centerX);
        
    }];
    
    self.reusableView = reusableView;
    
    return reusableView;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 140);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    CGFloat height = self.integralGoods.count == 0 ? 200: 0.1;

    return CGSizeMake(kScreenWidth, height);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    IntegralModel *good = self.integralGoods[indexPath.row];
//
//    return good.size;
//}

@end

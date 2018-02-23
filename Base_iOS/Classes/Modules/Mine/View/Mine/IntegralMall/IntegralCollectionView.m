//
//  IntegralCollectionView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "IntegralCollectionView.h"

//Macro
//Framework
//Category
#import "UIControl+Block.h"
//Extension
//M
//V
#import "IntegralGoodCell.h"

@interface IntegralCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation IntegralCollectionView

static NSString *integralGoodCellID = @"IntegralGoodCellID";
static NSString *headerViewID = @"IntegralMallHeaderViewID";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundColor = kClearColor;
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        [self registerClass:[IntegralGoodCell class] forCellWithReuseIdentifier:integralGoodCellID];
        
        [self registerClass:[IntegralMallHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
        
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
    
    IntegralMallHeaderView *cell = (IntegralMallHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
    
    self.headerView = cell;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 130);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    IntegralModel *good = self.integralGoods[indexPath.row];
//
//    return good.size;
//}

@end

//
//  HomeCollectionView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomeCollectionView.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//V
#import "BrandCell.h"

@interface HomeCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation HomeCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[BrandCell class] forCellWithReuseIdentifier:@"BrandCell"];
        
        [self registerClass:[HomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCellId"];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //--//
    return self.brands.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrandCell" forIndexPath:indexPath];
    
    cell.brandModel = self.brands[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_homeBlock) {
        
        _homeBlock(indexPath);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    NSString *HeaderCellId = @"HeaderCellId";

    HomeHeaderView *cell = (HomeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCellId forIndexPath:indexPath];

    cell.backgroundColor = kBackgroundColor;
    
    self.headerView = cell;

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 216 + kWidth(185));
}

@end

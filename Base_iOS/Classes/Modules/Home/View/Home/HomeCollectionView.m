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

static NSString *placeholderViewID = @"placeholderViewID";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[BrandCell class] forCellWithReuseIdentifier:@"BrandCell"];
        
        [self registerClass:[HomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCellId"];
        
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:placeholderViewID];

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

    HomeHeaderView *cell;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        cell = (HomeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCellId forIndexPath:indexPath];
        
        cell.backgroundColor = kBackgroundColor;
        
        self.headerView = cell;
        
        return cell;
        
    }
    
    CGFloat height = self.brands.count == 0 ? 200: 0.1;
    
    if (self.reusableView) {
        
        return self.reusableView;
    }
    
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:placeholderViewID forIndexPath:indexPath];
    
    reusableView.frame = CGRectMake(0, 216 + kWidth(185), kScreenWidth, height);
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
    
    textLbl.text = @"暂无品牌";
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
    
    return CGSizeMake(kScreenWidth, 216 + kWidth(185));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    CGFloat height = self.brands.count == 0 ? 200: 0.1;

    return CGSizeMake(kScreenWidth, height);
}

@end

//
//  PictureLibraryCollectionView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PictureLibraryCollectionView.h"
//V
#import "PictureLibraryCell.h"

@interface PictureLibraryCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation PictureLibraryCollectionView

static NSString *pictureLibraryCellID = @"PictureLibraryCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[PictureLibraryCell class] forCellWithReuseIdentifier:pictureLibraryCellID];
        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //--//
    return self.photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PictureLibraryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureLibraryCellID forIndexPath:indexPath];
    
    PictureModel *photo = self.photos[indexPath.row];
    
    cell.pictureModel = photo;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PictureModel *photo = self.photos[indexPath.row];
    
    [self.photos enumerateObjectsUsingBlock:^(PictureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.isSelected = obj == photo ? YES: NO;
    }];
    
    [collectionView reloadData];

    if (_photoBlock) {
        
        _photoBlock(indexPath);
    }
}


@end

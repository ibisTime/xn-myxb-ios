//
//  PictureLibraryView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "PictureModel.h"
//V
#import "PictureLibraryCollectionView.h"

typedef void(^PictureLibraryBlock)(NSIndexPath *indexPath);

@interface PictureLibraryView : BaseView
//
@property (nonatomic, strong) PictureLibraryCollectionView *collectionView;
@property (nonatomic, copy) PictureLibraryBlock pictureBlock;
//
@property (nonatomic, strong) NSArray <PictureModel *>*photos;

//显示
- (void)show;
//隐藏
- (void)hide;

@end

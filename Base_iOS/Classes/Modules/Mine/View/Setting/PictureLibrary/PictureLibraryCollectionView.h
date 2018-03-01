//
//  PictureLibraryCollectionView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/3/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseCollectionView.h"
//M
#import "PictureModel.h"

typedef void(^PhotoBlock)(NSIndexPath *indexPath);

@interface PictureLibraryCollectionView : BaseCollectionView
//
@property (nonatomic, strong) NSArray <PictureModel *>*photos;
//
@property (nonatomic, copy) PhotoBlock photoBlock;

@end

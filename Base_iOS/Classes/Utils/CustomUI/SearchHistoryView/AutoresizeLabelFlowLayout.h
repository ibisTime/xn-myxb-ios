//
//  AutoresizeLabelFlowLayout.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AutoresizeLabelFlowLayoutDelegate <NSObject>

@optional

- (void)layoutFinishWithNumberOfline:(NSInteger)number;

@end

@protocol AutoresizeLabelFlowLayoutDataSource <NSObject>

- (NSString *)titleForLabelAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface AutoresizeLabelFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id <AutoresizeLabelFlowLayoutDataSource> dataSource;
@property (nonatomic,weak) id <AutoresizeLabelFlowLayoutDelegate> delegate;

@end

//
//  BrandOrderGoodCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "BrandOrderModel.h"
@protocol BrandOrderGoodCellDelegate <NSObject>

- (void)cancelOrderWithIndexpath:(NSIndexPath *)indexpath;

@end

@interface BrandOrderGoodCell : BaseTableViewCell
//
@property (nonatomic, strong) BrandOrderModel *order;

@property (nonatomic)NSIndexPath *indexpath;
@property (nonatomic , weak)id<BrandOrderGoodCellDelegate>delegate;

@end

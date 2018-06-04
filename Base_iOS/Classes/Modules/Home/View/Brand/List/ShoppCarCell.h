//
//  ShoppCarCell.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCarModel.h"
@protocol ShoppCarCellDelegate <NSObject>

- (void)chouseThisCellWith:(NSIndexPath *)indexPth;
- (void)isAddWithThisGoods:(BOOL)isadd withIndexpath:(NSIndexPath *)indexpath;
- (void)deleteThisGoods:(NSIndexPath *)indexPath;
@end

@interface ShoppCarCell : UITableViewCell
@property (nonatomic, strong) ShopCarModel *brandModel;

@property (nonatomic)NSIndexPath *indexpath;

@property (nonatomic , weak)id<ShoppCarCellDelegate>delegate;
@end

//
//  BrandListCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BrandModel.h"
#import "ShopCarModel.h"
@interface BrandListCell : BaseTableViewCell
//
@property (nonatomic, strong) BrandModel *brandModel;

@property (nonatomic, strong)ShopCarModel *shopModel;

@end

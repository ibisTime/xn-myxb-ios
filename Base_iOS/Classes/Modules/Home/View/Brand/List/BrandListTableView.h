//
//  BrandListTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "BrandModel.h"

@interface BrandListTableView : TLTableView
//
@property (nonatomic, strong) NSArray <BrandModel *>*brands;

@end

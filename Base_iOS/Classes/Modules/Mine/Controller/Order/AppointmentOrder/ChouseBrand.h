//
//  ChouseBrand.h
//  Base_iOS
//
//  Created by zhangfuyu on 2018/6/6.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"
#import "BrandModel.h"

typedef void(^chouseBrand)(BrandModel *model);


@interface ChouseBrand : BaseViewController

@property (nonatomic , copy)chouseBrand brand;
@end

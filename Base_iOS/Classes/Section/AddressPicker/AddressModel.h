//
//  AddressModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class AddressProvince,AddressCity,AddressDistrict;

@interface AddressModel : BaseModel

@property (nonatomic, strong) NSArray<AddressProvince *> *province;

@end

@interface AddressProvince : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<AddressCity *> *city;

@end

@interface AddressCity : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<AddressDistrict *> *district;

@end

@interface AddressDistrict : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *zipcode;

@end

//
//  AddressModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"province" : [AddressProvince class]};
}
@end

@implementation AddressProvince

+ (NSDictionary *)objectClassInArray {
    
    return @{@"city" : [AddressCity class]};
}

@end


@implementation AddressCity

+ (NSDictionary *)objectClassInArray {
    
    return @{@"district" : [AddressDistrict class]};
}

@end


@implementation AddressDistrict

@end

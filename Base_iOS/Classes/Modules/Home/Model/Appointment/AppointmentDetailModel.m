//
//  AppointmentDetailModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "AppointmentDetailModel.h"
//Category
#import "UIColor+Extension.h"
//Macro
#import "AppColorMacro.h"

@implementation AppointmentDetailModel

- (NSArray<UIColor *> *)styleColor {
    
    //Color1
    //Color2
    UIColor *color2 = [UIColor colorWithHexString:@"#54e662"];
    //Color3
    UIColor *color3 = [UIColor colorWithHexString:@"#ffbe00"];
    
    return @[kAppCustomMainColor, color2, color3];
}

@end

//
//  NSNumber+Extension.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Extension)

- (NSString *)convertToRealMoney {
    
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    long long m = [self longLongValue];
    double value = m/1000.0;
    
    NSString *tempStr =  [NSString stringWithFormat:@"%.3f",value];
    NSString *subStr = [tempStr substringWithRange:NSMakeRange(0, tempStr.length - 1)];
    
    //  return [NSString stringWithFormat:@"%.2f",value];
    return subStr;
    
}

- (NSString *)convertToSimpleRealMoney {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
        
    }
    
    long long m = [self longLongValue];
    
    if (m%10 > 0) { //有厘
        
        double value = m/1000.0;
        return [NSString stringWithFormat:@"%.2f",value];
        
    } else if (m%100 > 0) {//有分
        
        double value = m/1000.0;
        return [NSString stringWithFormat:@"%.2f",value];
        
    } else if(m%1000 > 0) { //有角
        
        double value = m/1000.0;
        return [NSString stringWithFormat:@"%.1f",value];
        
    } else {//元
        
        double value = m/1000.0;
        return [NSString stringWithFormat:@"%.0f",value];
    }
    
}

//折扣
- (NSString *)convertToCountMoney {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
        
    }
    
    long long m = [self doubleValue]*10000;
    
    double value = m*10.0/10000.0;
    
    if (m%10 > 0) { //有厘
        
        return [NSString stringWithFormat:@"%.2f",value];
        
    } else if (m%100 > 0) {//有分
        
        return [NSString stringWithFormat:@"%.2f",value];
        
    } else if(m%1000 > 0) { //有角
        
        return [NSString stringWithFormat:@"%.1f",value];
        
    } else {//元
        
        return [NSString stringWithFormat:@"%.0f",value];
    }
}

@end

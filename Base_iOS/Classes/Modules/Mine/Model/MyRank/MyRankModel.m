//
//  MyRankModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "MyRankModel.h"

@implementation MyRankModel

- (NSString *)rankImg {
    
    NSString *img = @"";
    
    switch (_rank) {
        case 1:
        {
            img = @"第一名";
        }break;
            
        case 2:
        {
            img = @"第二名";
        }break;
            
        case 3:
        {
            img = @"第三名";
        }break;
            
        default:
            break;
    }
    
    return img;
}

@end

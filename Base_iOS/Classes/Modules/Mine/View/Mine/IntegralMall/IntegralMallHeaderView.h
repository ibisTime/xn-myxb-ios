//
//  IntegralMallHeaderView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IntegralType) {
    
    IntegralTypeGetIntegral = 0,    //赚积分
    IntegralTypeIntegralOrder,      //积分订单
    IntegralTypeIntegralRecord,     //积分记录
};
typedef void(^IntegralEventBlock)(IntegralType integralType);

@interface IntegralMallHeaderView : UICollectionReusableView

@property (nonatomic, copy) IntegralEventBlock block;
//积分
@property (nonatomic, copy) NSString *jfNum;

- (void)changeInfo;

@end

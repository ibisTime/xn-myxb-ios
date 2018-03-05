//
//  HomeHeaderView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
//M
#import "BannerModel.h"
#import "NoticeModel.h"

typedef NS_ENUM(NSInteger, HomeEventsType) {
    
    HomeEventsTypeBanner = 0,   //Banner图
    HomeEventsTypeNotice,       //系统公告
    HomeEventsTypeCategory,     //分类
};

typedef void(^HomeHeaderEventsBlock)(HomeEventsType type, NSInteger index);

@interface HomeHeaderView : UICollectionReusableView

@property (nonatomic, copy) HomeHeaderEventsBlock headerBlock;
//系统消息
@property (nonatomic,strong) NSMutableArray <NoticeModel *>*notices;
//
@property (nonatomic, strong) NSMutableArray <BannerModel *>*banners;

@end

//
//  AppointmentContentCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "AppointmentDetailModel.h"

typedef NS_ENUM(NSInteger, AppointmentType) {
    
    AppointmentTypeLookAllComment = 0,  //查看全部评论
    AppointmentTypeShowTitle,           //展示文字
    
};

@protocol AppointmentDetailCellDelegate <NSObject>

- (void)didSelectActionWithType:(AppointmentType)type index:(NSInteger)index;

@end

@interface AppointmentContentCell : BaseTableViewCell

@property (nonatomic, assign) BOOL isCurrentUser;
//
@property (nonatomic, weak) id <AppointmentDetailCellDelegate>delegate;
//
@property (nonatomic, strong) AppointmentDetailModel *detailModel;


@end

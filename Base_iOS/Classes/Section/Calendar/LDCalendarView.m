//
//  LDCalendarView.m
//
//  Created by lidi on 15/9/1.
//  Copyright (c) 2015年 lidi. All rights reserved.
//

#import "LDCalendarView.h"
//Category
#import "NSDate+Extend.h"
#import "UIColor+Extend.h"
#import "NSString+Date.h"

//Macro
#import "TLUIHeader.h"
#import "AppColorMacro.h"
//V
#import "TripListView.h"

#define UNIT_WIDTH  35 * SCREEN_RAT

//行 列 每小格宽度 格子总数
static const NSInteger kRow         = 1 + 6;//一,二,三... 1行 日期6行
static const NSInteger kCol         = 7;
static const NSInteger kBtnStartTag = 100;

@interface LDCalendarView()
//UI
@property (nonatomic, strong) UIView         *contentBgView,*dateBgView;
@property (nonatomic, strong) UILabel        *titleLab;//标题
@property (nonatomic, strong) UIButton       *doneBtn;//确定按钮
//Data
@property (nonatomic, assign) int32_t        year,month;
@property (nonatomic, strong) NSDate         *today,*firstDay; //今天 当月第一天
@property (nonatomic, strong) NSMutableArray *currentMonthDaysArray,*selectArray;
@property (nonatomic, assign) CGRect         touchRect;//可操作区域
//当月的天数
@property (nonatomic, assign) NSInteger kTotalNum;
//行程
@property (nonatomic, strong) TripListView *tripView;
//向前
@property (nonatomic, weak) UIButton *leftArrowBtn;
//向后
@property (nonatomic, weak) UIButton *rightArrowBtn;
//目前显示的月份
@property (nonatomic, strong) NSDate *currentDate;
//服务器的月份
@property (nonatomic, strong) NSDate *serviceDate;

@end

@implementation LDCalendarView

#pragma mark - LazyLoad
- (TripListView *)tripView {
    
    if (!_tripView) {
        
        _tripView = [[TripListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        [self addSubview:_tripView];
    }
    return _tripView;
}

- (NSDate *)today {
    
    if (!_today) {
        NSDate *currentDate = [NSDate date];

        //字符串转换为日期,今天0点的时间
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        _today = [dateFormat dateFromString:self.todayDate];

//        _today = [dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@",@(currentDate.year),@(currentDate.month),@(currentDate.day)]];
    }
    return _today;
}

- (NSDate *)firstDay {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *firstDay =[dateFormat dateFromString:[NSString stringWithFormat:@"%@-%@-%@",@(self.year),@(self.month),@(1)]];
    return firstDay;
}

- (NSInteger)getNumberOfDaysInMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSGregorianCalendar - ios 8
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
                                   inUnit: NSCalendarUnitMonth //NSMonthCalendarUnit - ios 8
                                  forDate:_currentDate];
    return range.length;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.dateBgView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
            
            view;
        });

        self.contentBgView = ({
            //内容区的背景
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(29, 0, self.width - 58, self.height)];
            view.layer.cornerRadius     = 2.0;
            view.layer.masksToBounds    = YES;
            view.userInteractionEnabled = YES;
            view.backgroundColor        = [UIColor whiteColor];
            [self addSubview:view];
            
            ({
                UIImageView *leftImage = [UIImageView new];
                leftImage.image        = [UIImage imageNamed:@"com_arrows_right"];
                leftImage.image        = [UIImage imageWithCGImage:leftImage.image.CGImage scale:1 orientation:UIImageOrientationDown];
                [view addSubview:leftImage];
                leftImage.frame        = CGRectMake(CGRectGetWidth(view.frame)/3.0 - 8 - 10, (42-13)/2.0, 8, 13);
            });
            
            ({
                UIImageView *rightImage = [UIImageView new];
                rightImage.image        = [UIImage imageNamed:@"com_arrows_right"];
                [view addSubview:rightImage];
                rightImage.frame        = CGRectMake(CGRectGetWidth(view.frame)*2/3.0 + 8, (42-13)/2.0, 8, 13);
            });
            
            view;
        });

        self.titleLab = ({
            UILabel *lab               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentBgView.frame), 42)];
            lab.backgroundColor        = [UIColor clearColor];
            lab.textColor              = kTextColor;
            lab.font                   = [UIFont systemFontOfSize:14];
            lab.textAlignment          = NSTextAlignmentCenter;
            lab.userInteractionEnabled = YES;
            [_contentBgView addSubview:lab];
            
            ({
//                UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchMonthTap:)];
//                [lab addGestureRecognizer:titleTap];
                
//                UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame) - 0.5, CGRectGetWidth(_contentBgView.frame), 0.5)];
//                line.backgroundColor = [UIColor hexColorWithString:@"dddddd"];
//                [_contentBgView addSubview:line];
            });
            
            lab;
        });
        
        self.dateBgView = ({
            UIView *view                = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLab.frame), CGRectGetWidth(_contentBgView.frame), UNIT_WIDTH*kRow)];
            view.userInteractionEnabled = YES;
            view.backgroundColor = kWhiteColor;
            
            [_contentBgView addSubview:view];
            
            ({
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                [view addGestureRecognizer:tap];
            });
            view;
        });

//        self.doneBtn = ({
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [btn setFrame:CGRectMake((CGRectGetWidth(_contentBgView.frame) - 150) / 2.0, CGRectGetHeight(_contentBgView.frame) - 40, 150, 30)];
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//            [btn setBackgroundImage:[[UIImage imageNamed:@"b_com_bt_blue_normal"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateNormal];
//            [btn setBackgroundImage:[[UIImage imageNamed:@"b_com_bt_blue_normal"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateSelected];
//            [btn setBackgroundImage:[[UIImage imageNamed:@"com_bt_gray_normal"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateDisabled];
//            [btn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [btn setTitle:@"确定" forState:UIControlStateNormal];
//            [_contentBgView addSubview:btn];
//
//            btn;
//        });
        
        [self initArrowView];
    }
    return self;
}

- (void)setTodayDate:(NSString *)todayDate {
    
    _todayDate = todayDate;
    //服务器显示的月份
    if (!_serviceDate) {
        
        _serviceDate = [NSString dateFromString:todayDate formatter:@"yyyy-MM-dd"];
    }
    
    _currentDate = [NSString dateFromString:todayDate formatter:@"yyyy-MM-dd"];
    //判断是不是当前月份
    self.leftArrowBtn.hidden = _serviceDate.month == _currentDate.month ? YES: NO;

    [self initData];
    
    if (self.clickMounteh) {
        self.clickMounteh(todayDate);
    }

}

- (void)initData {
    
    _selectArray        = @[].mutableCopy;
    //当月天数
    self.kTotalNum = [self getNumberOfDaysInMonth];
    //获取当前年月
    NSDate *currentDate = [NSString dateFromString:_todayDate formatter:@"yyyy-MM-dd"];
    self.month          = (int32_t)currentDate.month;
    self.year           = (int32_t)currentDate.year;
    [self refreshDateTitle];

    _currentMonthDaysArray = [NSMutableArray array];
    for (int i = 0; i < self.kTotalNum; i++) {
        [_currentMonthDaysArray addObject:@(0)];
    }

    [self showDateView];
}

- (void)switchMonthTap:(UITapGestureRecognizer *)tap {
   CGPoint loc =  [tap locationInView:_titleLab];
    CGFloat titleLabWidth = CGRectGetWidth(_titleLab.frame);
    if (loc.x <= titleLabWidth/3.0) {
        [self leftSwitch];
    }else if(loc.x >= titleLabWidth/3.0*2.0){
        [self rightSwitch];
    }
}

- (void)leftSwitch{
    if (self.month > 1) {
        self.month -= 1;
    }else {
        self.month = 12;
        self.year -= 1;
    }
    
    [self refreshDateTitle];
}

- (void)rightSwitch {
    if (self.month < 12) {
        self.month += 1;
    }else {
        self.month = 1;
        self.year += 1;
    }
    
    [self refreshDateTitle];
}

- (void)refreshDateTitle {
    _titleLab.text = [NSString stringWithFormat:@"%@年%@月",@(self.year),@(self.month)];
    
    [self showDateView];
}

- (void)drawTitleView {
    
    CGRect baseRect = CGRectMake(0.0,0.0, (self.width - 58)/7.0, 21);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - 58, 21)];
    
    bgView.layer.cornerRadius = 21/2.0;
    bgView.clipsToBounds = YES;
    
    bgView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    [_dateBgView addSubview:bgView];
    
    NSArray *tmparr = @[@"日", @"一",@"二",@"三",@"四",@"五",@"六"];
    
    for(int i = 0 ;i < 7; i++)
    {
        UILabel *lab        = [[UILabel alloc] initWithFrame:baseRect];
        lab.textColor       = [UIColor hexColorWithString:@"848484"];
        lab.textAlignment   = NSTextAlignmentCenter;
        lab.font            = [UIFont systemFontOfSize:12];
        lab.backgroundColor = [UIColor clearColor];
        lab.text            = [tmparr objectAtIndex:i];
        [bgView addSubview:lab];
        
        baseRect.origin.x   += baseRect.size.width;
    }
}

- (CGFloat)calculateStartIndex:(NSDate *)firstDay {
    
    CGFloat startDayIndex = [NSDate acquireWeekDayFromDate:firstDay];
    //第一天是今天，特殊处理
//    if (startDayIndex == 1) {
//        //星期天（对应一）
//        startDayIndex = 6;
//    }else {
//        //周一到周六（对应2-7）
//        startDayIndex -= 2;
//    }
    return startDayIndex - 1;
}

- (void)createBtn:(NSInteger)i frame:(CGRect)baseRect {
    
    UIView *bgView = [[UIView alloc] initWithFrame:baseRect];

    [_dateBgView addSubview:bgView];
    
    CGFloat startDayIndex = [self calculateStartIndex:self.firstDay];
    NSDate * date = [self.firstDay dateByAddingTimeInterval: (i - startDayIndex)*24*60*60];
    _currentMonthDaysArray[i] = @([date timeIntervalSince1970]);
    
    NSString *title = INTTOSTR(date.day);

    UIButton *btn = [UIButton buttonWithTitle:title titleColor:kTextColor backgroundColor:kClearColor titleFont:10];
    
    btn.frame = CGRectMake(0, 0, 25, 25);
    
    btn.center = bgView.center;
    
    btn.tag                    = kBtnStartTag + i;
    btn.userInteractionEnabled = NO;
    
    [btn setTitleColor:kAppCustomMainColor forState:UIControlStateSelected];

    [_dateBgView addSubview:btn];

    //添加小图标
//    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"签到-打勾")];
//
//    iconIV.tag = 2000 + i;
//
//    iconIV.frame = CGRectMake(btn.xx - 7, btn.y, 10, 10);
//
//    iconIV.hidden = YES;
//
//    [_dateBgView addSubview:iconIV];

}

- (void)showDateView {
    //移除之前子视图
    [_dateBgView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    //一，二，三，四...
    [self drawTitleView];

    CGFloat startDayIndex       = [self calculateStartIndex:self.firstDay];
    CGFloat btnW = (kScreenWidth - 58)/7.0;
    
    CGRect baseRect             = CGRectMake(btnW * startDayIndex,UNIT_WIDTH, btnW, UNIT_WIDTH);
    //设置触摸区域
    self.touchRect = ({
        CGRect rect = CGRectZero;
        rect.origin      = baseRect.origin;
        rect.origin.x    = 0;
        rect.size.width  = kScreenWidth - 58;
        rect.size.height = kRow * UNIT_WIDTH;
        
        rect;
    });
    
    for(int i = startDayIndex; i < (self.kTotalNum + startDayIndex);i++) {
        //需要换行且不在第一行
        if (i % kCol == 0 && i != 0) {
            baseRect.origin.y += (baseRect.size.height);
            baseRect.origin.x = 0.0;
        }
        
        [self createBtn:i frame:baseRect];

        baseRect.origin.x += (baseRect.size.width);
    }
    
    //高亮选中的
    [self refreshDateView];
}

- (void)setDefaultDays:(NSArray *)defaultDays {
    _defaultDays = defaultDays;
    
    if (defaultDays) {
        _selectArray = [defaultDays mutableCopy];
    }else {
        _selectArray = @[].mutableCopy;
    }
}

- (void)refreshDateView {
    
    for(int i = 0; i < self.kTotalNum; i++) {
        UIButton *btn = (UIButton *)[_dateBgView viewWithTag:kBtnStartTag + i];
        NSNumber *interval = [_currentMonthDaysArray objectAtIndex:i];

        if (i < [_currentMonthDaysArray count] && btn) {
            if ([_selectArray containsObject:interval]) {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor hexColorWithString:@"77d2c5"]];
            }
        }
    }
}

-(void)tap:(UITapGestureRecognizer *)gesture{
    
    CGPoint point = [gesture locationInView:_dateBgView];
    if (CGRectContainsPoint(_touchRect, point)) {
        CGFloat w       = (CGRectGetWidth(_dateBgView.frame)) / kCol;
        CGFloat h       = (CGRectGetHeight(_dateBgView.frame)) / kRow;
        int row         = (int)((point.y - _touchRect.origin.y) / h);
        int col         = (int)((point.x) / w);

        NSInteger index = row * kCol + col;
        
        [self lookTripForIndex:index];
    }
}
//点击查看行程
- (void)lookTripForIndex:(NSInteger)index {
    
    CGFloat startDayIndex       = [self calculateStartIndex:self.firstDay];

    NSInteger day = index + 1 - startDayIndex;
    
    NSMutableArray <TripInfoModel *>*arr = [NSMutableArray array];
    
    [self.dateArr enumerateObjectsUsingBlock:^(TripInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDate *startDate = [NSString dateFromString:obj.startDatetime formatter:kDateFormmatter];
        
        NSDate *endDate = [NSString dateFromString:obj.endDatetime formatter:kDateFormmatter];
        
        if (day >= startDate.day && day <= endDate.day) {
            
            [arr addObject:obj];
        }
    }];
    //如果没有行程就结束
    if (arr.count == 0) {
        
        return ;
    }
    //展示行程
    self.tripView.trips = arr.copy;
    
    [self.tripView show];
}

- (void)clickForIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[_dateBgView viewWithTag:kBtnStartTag + index];
    
    //已安排行程的日期
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = btn.width/2.0;
    btn.clipsToBounds = YES;
    btn.backgroundColor = kAppCustomMainColor;
    
    UIImageView *iconIV = [_dateBgView viewWithTag:2000 + index];
    
    iconIV.hidden = NO;

}
- (void)clickWithType:(NSInteger)type withTag:(NSInteger)inTage
{
    UIButton *btn = (UIButton *)[_dateBgView viewWithTag:kBtnStartTag + inTage];
    
    //已安排行程的日期
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = btn.width/2.0;
    btn.clipsToBounds = YES;
    if (type == 1) {
        btn.backgroundColor = [UIColor greenColor];

    }
    else if (type == 2)
    {
        btn.backgroundColor = [UIColor redColor];

    }
    else
    {
        btn.backgroundColor = [UIColor yellowColor];

    }
//    btn.backgroundColor = kAppCustomMainColor;
    
    UIImageView *iconIV = [_dateBgView viewWithTag:2000 + inTage];
    
    iconIV.hidden = NO;
}
- (void)show {
    
    self.hidden = NO;
}

#pragma mark - Setting
- (void)setDateArr:(NSArray *)dateArr {
    
    _dateArr = dateArr;
    
    [self loadDataArr];
}

- (void)loadDataArr {
    
    CGFloat startDayIndex       = [self calculateStartIndex:self.firstDay];
    
    [_dateArr enumerateObjectsUsingBlock:^(TripInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        NSArray *arry = [obj.date componentsSeparatedByString:@"-"];
        
        NSDate *startDate = [NSString dateFormeTimeString:obj.date formatter:kDateFormmatter];//[NSString dateFromString:obj.date formatter:kDateFormmatter];
        
        NSDate *endDate = [NSString dateFromString:obj.date formatter:kDateFormmatter];
        
        NSInteger dayNumber = [arry.lastObject integerValue];
        
        
        for (int i = 1; i < self.kTotalNum+1; i++) {
            
            if (i == dayNumber) {
                [self clickWithType:[obj.color integerValue] withTag:i - 1 + startDayIndex];
            }
            
            
//            if (i >= startDate.day && i <= endDate.day) {
//
//                [self clickForIndex:i - 1 + startDayIndex];
//            }
        }
    }];
}

#pragma mark -
// 上个月
- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

// 下个月
- (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma mark - Events
- (void)preBtnClick {
    
    NSDate *preDate = [self lastMonth:_currentDate];
    
    self.todayDate = [NSString stringFromDate:preDate formatter:@"yyyy-MM-dd"];
    
    [self setNeedsLayout];
    
}

- (void)nextBtnClick {
    
    NSDate *nextDate = [self nextMonth:_currentDate];
    
    self.todayDate = [NSString stringFromDate:nextDate formatter:@"yyyy-MM-dd"];

    [self setNeedsLayout];
}

- (void)initArrowView {
    
    CGFloat arrowW = 40;
    CGFloat arrowH = 40;
    
    //左箭头
    UIButton *leftArrowBtn = [UIButton buttonWithImageName:@"更多-灰色"];
    
    leftArrowBtn.frame = CGRectMake(kScreenWidth/2.0 - arrowW - 25, 15, arrowW, arrowH);
    
    leftArrowBtn.centerY = self.titleLab.centerY;
    
    [leftArrowBtn addTarget:self action:@selector(preBtnClick) forControlEvents:UIControlEventTouchUpInside];
    leftArrowBtn.transform = CGAffineTransformMakeRotation(M_PI);
    
    [self addSubview:leftArrowBtn];
    
    self.leftArrowBtn = leftArrowBtn;
    //右箭头
    UIButton *rightArrowBtn = [UIButton buttonWithImageName:@"更多-灰色"];
    
    rightArrowBtn.frame = CGRectMake(kScreenWidth/2.0 + 25, 15, arrowW, arrowH);
    
    rightArrowBtn.centerY = self.titleLab.centerY;

    [rightArrowBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:rightArrowBtn];
    
    self.rightArrowBtn = rightArrowBtn;
}

@end

//
//  AppDelegate.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppDelegate.h"

//Category
#import "AppConfig.h"
//Extension
#import "IQKeyboardManager.h"
#import "TLWXManager.h"
#import "WXApi.h"
//M
#import "TLUser.h"
//C
#import "NavigationController.h"
#import "TabbarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - App Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //服务器环境
    [self configServiceAddress];
    //配置微信
    [self configWeChat];
    //键盘
    [self configIQKeyboard];
    //配置根控制器
    [self configRootViewController];
    
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"---->%@",log);
    }];
    //向微信注册,发起支付必须注册
    [WXApi registerApp:@"wxd0c1725a396dada6" enableMTA:YES];
    return YES;
}

// iOS9 NS_AVAILABLE_IOS
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
}

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
}

#pragma mark - Config
- (void)configWeChat {
    
    [[TLWXManager manager] registerApp];
}

- (void)configServiceAddress {
    
    //配置环境
    [AppConfig config].runEnv = RunEnvTest;
}

- (void)configIQKeyboard {
    
    //
//    [IQKeyboardManager sharedManager].enable = YES;
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[ComposeVC class]];
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[SendCommentVC class]];
    
}

- (void)configRootViewController {
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
    self.window.rootViewController = tabbarCtrl;
    
    //重新登录
    if([TLUser user].isLogin) {
        
        [[TLUser user] reLogin];
    };
    
    //登出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
}

#pragma mark- 退出登录
- (void)loginOut {
    
    //user 退出
    [[TLUser user] loginOut];
    
}

#pragma mark - 用户登录
- (void)userLogin {
    
}

@end

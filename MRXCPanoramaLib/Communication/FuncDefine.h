//
//  FuncDefine.h
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/21.
//  Copyright © 2016年 never88gone. All rights reserved.
//

typedef void(^MRXCCompletionBlock)(id aResponseObject, NSError* anError);
#define CustomErrorDomain @"com.mrxc.pano"

//weak strong self for retain cycle
#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf

// 单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once(&once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

//判断ios版本
#define IOS_SDK_MORE_THAN_OR_EQUAL(__num) [UIDevice currentDevice].systemVersion.floatValue >= (__num)
#define IOS_SDK_MORE_THAN(__num) [UIDevice currentDevice].systemVersion.floatValue > (__num)
#define IOS_SDK_LESS_THAN(__num) [UIDevice currentDevice].systemVersion.floatValue < (__num)

//判断设备
#define IS_IPAD_DEVICE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_IPHONE_DEVICE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

#define ISIPHONE3_5  CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE4_0  CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE4_7  CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE5_5  CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE9_7  CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE9_7_LAND  CGSizeEqualToSize(CGSizeMake(1024, 768), [[UIScreen mainScreen] bounds].size)

//判断横竖屏
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)

//获取当前屏幕尺寸
#define SCREEN_SIZE (((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))?CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width):[UIScreen mainScreen].bounds.size)

// 本地化
#define OTSSTRING(_str)  NSLocalizedString((_str),(_str))

//pad横竖屏比率
#define UI_PAD_LAND_RATIO (IS_LANDSCAPE?(1024.0/768):1)


//
//  QLDefaultConstants.h
//  QLCustomAlertView
//
//  Created by qianlei on 2019/7/26.
//  Copyright © 2019 qianlei. All rights reserved.
//  定义工程内使用的 全局常量

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QLCustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 操作按钮的高度
 */
UIKIT_EXTERN CGFloat QLDefaultButtonHeight;

/**
 弹框视图的高度
 */
UIKIT_EXTERN CGFloat QLDefaultPopViewHeight;

/**
 alert弹窗的左右预留边距
 */
UIKIT_EXTERN CGFloat QLPopAlertWidthInterval;

/**
 alert相对于屏幕的宽度, default is 270.0f
 */
UIKIT_EXTERN CGFloat QLPopAlertWidth;

/**
 弹框剧中显示的背景最大高度，便于适配有弹出键盘的情况
 */
UIKIT_EXTERN CGFloat QLContainerMaxHeight;

/**
 默认title文案颜色
 */
#define QLDefaultTextColor ([UIColor blackColor])

/**
 默认背景色
 */
#define QLDefaultBackgroundColor ([UIColor whiteColor])

/**
 默认分割线颜色
 */
#define QLDefaultSeparatorLineColor ([UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0])


@interface QLDefaultConstants : NSObject

/**
 屏幕宽
 */
UIKIT_EXTERN CGFloat QLScreenWidth(void);

/**
 屏幕高
 */
UIKIT_EXTERN CGFloat QLScreenHeight(void);

/**
 导航条高度
 */
UIKIT_EXTERN CGFloat QLNavigationBarHeight(void);

/**
 状态栏高度
 */
UIKIT_EXTERN CGFloat QLStatusBarHeight(void);

/**
 tabbar高度
 */
UIKIT_EXTERN CGFloat QLTabBarHeight(void);

/**
 alert的最大高度

 @param mode 区分不同的模式; alert与actionSheet模式等
 */
UIKIT_EXTERN CGFloat QLAlertViewMaxHeight(QLAlertViewStyle mode);

/**
 弹框的popView部分的最大高度

 @param mode 区分不同的模式; alert与actionSheet模式等
 */
UIKIT_EXTERN CGFloat QLPopViewMaxHeight(QLAlertViewStyle mode);

/**
 弹框的左边留空间距
 
 @param mode 区分不同的模式; alert与actionSheet模式等
 @param fixedEdgeDistance 是否固定边距显示
 */
UIKIT_EXTERN CGFloat QLCalculatePopIntervalWidth(QLAlertViewStyle mode, BOOL fixedEdgeDistance);

/**
 安全区域
 */
UIKIT_EXTERN UIEdgeInsets QLScreenSafeInsets(void);

/**
 安全区域刘海高度
 */
UIKIT_EXTERN CGFloat QLScreenSafeTop(void);

/**
 安全区域homeBar高度
 */
UIKIT_EXTERN CGFloat QLScreenSafeBottom(void);

/**
 在弹框销毁时，需要充值默认全局变量的值
 */
UIKIT_EXTERN void QLResetDefaultParameterValues(void);

@end

NS_ASSUME_NONNULL_END

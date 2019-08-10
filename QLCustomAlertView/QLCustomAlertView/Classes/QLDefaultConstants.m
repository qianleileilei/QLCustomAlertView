//
//  QLDefaultConstants.m
//  QLCustomAlertView
//
//  Created by qianlei on 2019/7/26.
//  Copyright © 2019 qianlei. All rights reserved.
//

#import "QLDefaultConstants.h"

/**
 默认操作按钮的高度
 */
CGFloat QLDefaultButtonHeight = 50.0f;

/**
 弹框视图的内容高度，出去操作按钮之外的高度
 */
CGFloat QLDefaultPopViewHeight = 250.0f;

/**
 alert弹窗的左右预留边距
 */
CGFloat QLPopAlertWidthInterval = 25.0f;

/**
 alert相对于屏幕的宽度, default is 270.0f
 */
CGFloat QLPopAlertWidth = 270.0f;

/**
 弹框剧中显示的背景最大高度，便于适配有弹出键盘的情况
 */
CGFloat QLContainerMaxHeight = 300;

@implementation QLDefaultConstants

//屏幕宽
inline CGFloat QLScreenWidth(void) {
    return [UIScreen mainScreen].bounds.size.width;
}

//屏幕高
inline CGFloat QLScreenHeight(void) {
    return [UIScreen mainScreen].bounds.size.height;
}

//导航条高度
inline CGFloat QLNavigationBarHeight(void) {
    return QLStatusBarHeight() + 44;
}

//状态栏高度
inline CGFloat QLStatusBarHeight(void) {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

//tabbar高度
inline CGFloat QLTabBarHeight(void) {
    return 49 + QLScreenSafeBottom();
}

//alert的最大高度
inline CGFloat QLAlertViewMaxHeight(QLAlertViewStyle mode) {
    UIInterfaceOrientation screenOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (screenOrientation == UIInterfaceOrientationPortrait || screenOrientation == UIInterfaceOrientationPortraitUpsideDown) { //竖屏
        if (mode == QLAlertViewStyleActionSheet) {    //系统actionSheet
            if (QLScreenSafeBottom() > 1) {
                return QLContainerMaxHeight - QLNavigationBarHeight() - QLScreenSafeBottom();
            } else {
                return QLContainerMaxHeight - QLNavigationBarHeight() - 10;
            }
        } else if (mode == QLAlertViewStyleListSheet) { //listSheet
            return QLContainerMaxHeight - QLNavigationBarHeight();
        } else { //alert模式
            return QLContainerMaxHeight - QLStatusBarHeight() * 2;
        }
    } else {    //横屏，上下各留20
        return QLContainerMaxHeight - 40;
    }
}

//alert的popView部分的最大高度
inline CGFloat QLPopViewMaxHeight(QLAlertViewStyle mode) {
    if (mode == QLAlertViewStyleActionSheet) {    //系统actionSheet
        return QLAlertViewMaxHeight(mode) - QLDefaultButtonHeight * 2.5 - QLScreenSafeBottom() - 10;
    } else if (mode == QLAlertViewStyleListSheet) {    //ListSheet模式
        return QLAlertViewMaxHeight(mode) - QLDefaultButtonHeight * 2.5 - 10;
    } else if (mode == QLAlertViewStyleListStyle) { //模式alert模式
        return QLAlertViewMaxHeight(mode) - QLDefaultButtonHeight * 1.5;
    } else {
        return QLAlertViewMaxHeight(mode) - QLDefaultButtonHeight;
    }
}

//弹框的左边留空间距
inline CGFloat QLCalculatePopIntervalWidth(QLAlertViewStyle mode, BOOL fixedEdgeDistance) {
    if (mode == QLAlertViewStyleActionSheet) {
        QLPopAlertWidthInterval = 10;
    } else if (mode == QLAlertViewStyleListSheet) {
        QLPopAlertWidthInterval = 0;
    } else if (fixedEdgeDistance) { //弹框需要与屏幕固定边距显示
        QLPopAlertWidthInterval = 25;
    } else {
        QLPopAlertWidthInterval = (QLScreenWidth() - 270.0f) / 2.0;
    }
    return QLPopAlertWidthInterval;
}

inline UIEdgeInsets QLScreenSafeInsets(void) {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

inline CGFloat QLScreenSafeTop(void) {
    return QLScreenSafeInsets().top;
}

inline CGFloat QLScreenSafeBottom(void) {
    return QLScreenSafeInsets().bottom;
}

inline void QLResetDefaultParameterValues(void) {
    QLDefaultButtonHeight = 50.0f;
    QLDefaultPopViewHeight = 250.0f;
    QLPopAlertWidthInterval = 25.0f;
    QLPopAlertWidth = 270.0f;
    QLContainerMaxHeight = 300;
}

@end

//
//  QLPopCustomBaseView.h
//  QLCustomAlertView
//
//  Created by qianlei on 2019/7/26.
//  Copyright © 2019 qianlei. All rights reserved.
//  弹出框视图基类

#import <UIKit/UIKit.h>
#import "QLCustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLPopCustomBaseView : UIView

/**
 设置弹框的显示样式
 */
@property (nonatomic, assign) QLAlertViewStyle alertStyle;

/**
 设置标题内容
 */
@property (nonatomic, copy) NSString *title;

/**
 设置message内容
 */
@property (nonatomic, copy) NSString *message;

/**
 设置title的颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 设置title的字体
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 设置message的颜色
 */
@property (nonatomic, strong) UIColor *messageColor;

/**
 设置message的字体
 */
@property (nonatomic, strong) UIFont *messageFont;

/**
 textField与textView模式下，对应输入框的placeHolder
 */
@property (nullable, nonatomic, copy) NSString *placeHolderString;

/**
 是否通过点击return键 让键盘消失；当是QLAlertViewStyleTextField模式时， default is YES；当是QLAlertViewStyleTextView模式时，default is NO
 
 @warning 只对QLAlertViewStyleTextField与QLAlertViewStyleTextView生效
 */
@property (nonatomic, assign) BOOL returnKeyHideKeyboard;

/**
 标题内容的高度
 */
@property (nonatomic, assign) CGFloat titleHeight;

/**
 内容是否需要滚动才能显示完全，方便在建立约束时增加判断
 */
@property (nonatomic, assign) BOOL contentShouldScroll;

/**
 用户自定义view
 */
@property (nullable, nonatomic, strong) UIView *customView;

/**
 回传输入框的text内容
 */
@property (nullable, nonatomic, copy) void (^inputTextChanged)(NSString *text);

/**
 根据类型初始化弹出框

 @param frame 弹出框的frame
 @param style 弹框的类型
 @return 返回对象实例
 */
- (instancetype)initWithFrame:(CGRect)frame alertViewStyle:(QLAlertViewStyle)style;

/**
 让内容滚动到底部显示
 */
- (void)contentShouldScrollToBottom;

@end

NS_ASSUME_NONNULL_END

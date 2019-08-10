//
//  QLCustomAlertView.h
//  QLCustomAlertView
//
//  Created by qianlei on 2019/7/25.
//  Copyright © 2019 qianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UITextField.h>
#import <UIKit/UIView.h>
#import "QLAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

/**
 alertView的显示样式

 - QLAlertViewStyleDefault: 默认样式，效果类似于系统的alertView
 - QLAlertViewStyleListStyle: 列表样式，操作按键以“竖直”排列方式显示
 - QLAlertViewStyleActionSheet: 类似于系统的actionsheet样式
 - QLAlertViewStyleListSheet: 全屏显示的列表样式（规则类似于系统actionsheet）
 - QLAlertViewStyleTextField: 弹框的内容显示为textField
 - QLAlertViewStyleTextView: 弹框的内容显示为textView
 - QLAlertViewStyleCustomView: 使用自定义视图显示弹框内容
 */
typedef NS_ENUM(NSInteger, QLAlertViewStyle) {
    QLAlertViewStyleDefault = 0,
    QLAlertViewStyleListStyle,
    QLAlertViewStyleActionSheet,
    QLAlertViewStyleListSheet,
    QLAlertViewStyleTextField,
    QLAlertViewStyleTextView,
    QLAlertViewStyleCustomView
};

@protocol QLCustomAlertViewDelegate;

@interface QLCustomAlertView : NSObject

/**
 alertView事件回调代理
 */
@property (nullable, nonatomic, weak) id<QLCustomAlertViewDelegate> delegate;

/**
 Alert view style - defaults to QLAlertViewStyleDefault
 */
@property (nonatomic, assign) QLAlertViewStyle alertViewStyle;

/**
 alertView的标题，默认加粗显示
 */
@property (nullable, nonatomic, copy) NSString *title;

/**
 alertView的正文内容
 */
@property (nullable, nonatomic, copy) NSString *message;

/**
 textField与textView模式下，对应输入框的placeHolder
 */
@property (nullable, nonatomic, copy) NSString *placeHolderString;

/**
 在QLAlertViewStyleTextField或QLAlertViewStyleTextView 模式下，实时同步输入框的内容；可以通过监听这个属性的内容变化 获取输入框的实时值
 */
@property (nullable, nonatomic, copy, readonly) NSString *inputViewText;

/**
 用户自定义view
 */
@property (nullable, nonatomic, strong) UIView *customView;

/**
 是否支持 通过点击背景让弹窗消失（ActionSheet样式默认支持）
 */
@property (nonatomic, assign) BOOL touchBackgroundDismiss;

/**
 是否通过点击背景让键盘消失；default is NO (don`t hide Keyborad when click background)
 
 @warning 只对QLAlertViewStyleTextField与QLAlertViewStyleTextView生效，且优先级低于touchBackgroundDismiss属性
 */
@property (nonatomic, assign) BOOL hideKeyboradForClickBackground;

/**
 是否通过点击return键 让键盘消失；当是QLAlertViewStyleTextField模式时， default is YES；当是QLAlertViewStyleTextView模式时，default is NO
 
 @warning 只对QLAlertViewStyleTextField与QLAlertViewStyleTextView生效
 */
@property (nonatomic, assign) BOOL returnKeyHideKeyboard;

/**
 是否显示分割线，包括操作按钮之间的分割线 与 popView之间的分割线
 */
@property (nonatomic, assign) BOOL showSperatorLine;

/**
 default is YES; 控制与屏幕左右边界按固定间距显示，如果为NO则弹框固定宽度270剧中；当设置为YES时，会按与屏幕间距相差25显示
 
 @warning 这个属性对于QLAlertViewStyleActionSheet与QLAlertViewStyleListSheet模式不生效，这两种模式下有固定边距
 */
@property (nonatomic, assign) BOOL showAsFixedEdgeDistance;

/**
 返回当前alertView的 button个数，包括Cancel
 */
@property (nonatomic, readonly) NSUInteger numberOfButtons;


/**
 初始化方法

 @param title 弹框标题
 @param message 弹框内容
 @return 返回弹框对象
 */
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message alertStyle:(QLAlertViewStyle)style;

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id<QLCustomAlertViewDelegate>)delegate;

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message alertStyle:(QLAlertViewStyle)style delegate:(nullable id<QLCustomAlertViewDelegate>)delegate;

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message alertStyle:(QLAlertViewStyle)style delegate:(nullable id<QLCustomAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSArray <NSString *> *)otherButtonTitles;


/**
 链式语法设置title的颜色
 */
- (QLCustomAlertView *(^)(UIColor *))titleColor;

/**
 设置title的font
 */
- (QLCustomAlertView *(^)(UIFont *))titleFont;

/**
 设置message的颜色
 */
- (QLCustomAlertView *(^)(UIColor *))messageColor;

/**
 设置message的font
 */
- (QLCustomAlertView *(^)(UIFont *))messageFont;

/**
 设置textField与textView模式下的 placeHolder
 */
- (QLCustomAlertView *(^)(NSString *))placeHolder;

/**
 设置弹框的显示样式
 */
- (QLCustomAlertView *(^)(QLAlertViewStyle))alertStyle;

/**
 设置弹框的内容显示为customView
 */
- (QLCustomAlertView *(^)(UIView *))customViewDeatil;

/**
 设置cancel按钮的颜色
 */
- (QLCustomAlertView *(^)(UIColor *))cancelTitleColor;

/**
 设置cancel按钮的font
 */
- (QLCustomAlertView *(^)(UIFont *))cancelTitleFont;

/**
 设置其他按钮的颜色
 */
- (QLCustomAlertView *(^)(NSArray <UIColor *> *))otherTitlesColor;

/**
 设置其他按钮的font
 */
- (QLCustomAlertView *(^)(NSArray <UIFont *> *))otherTitlesFont;

/**
 添加单个操作button
 */
- (QLCustomAlertView *(^)(QLAlertAction *))addAlertAction;

/**
 添加多个操作button
 */
- (QLCustomAlertView *(^)(NSArray <QLAlertAction *> *))addAlertActionsFromArray;

/**
 根据index返回对应button上的文案；（从0开始从左到右计数，或从0开始从上到下计数）
 
 @param buttonIndex 根据这个值 获取对应位置的button
 @return 返回title
 */
- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

/**
 shows popup alert animated.
 */
- (void)show;

/**
 hides popup alert animated.
 */
- (void)dismiss;

/**
 hides popup alert

 @param animated 是否需要使用动画
 @param completion alert消失完成后的回调
 */
- (void)dismissWithAnimated:(BOOL)animated completionHandle:(nullable dispatch_block_t)completion;

/**
 调用这个方法让弹框自动消失（不需要用户手动点击某个button），并执行某一个button下的事件回调

 @param buttonIndex 弹框消失时需要执行哪一个回调，默认cancelButton的index为0，其他button的index从1开始
 @param animated 是否需要动画
 */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end


/**
 alertView的回调代理
 */
@protocol QLCustomAlertViewDelegate <NSObject>

@optional

/**
 Called when a button is clicked. The view will be automatically dismissed after this call returns

 @param alertView current showed alertView
 @param buttonIndex index of clicked button
 */
- (void)alertView:(QLCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

/**
 before animation and showing view

 @param alertView current showed alertView
 */
- (void)willPresentAlertView:(QLCustomAlertView *)alertView;

/**
 after animation

 @param alertView current showed alertView
 */
- (void)didPresentAlertView:(QLCustomAlertView *)alertView;

/**
 before animation and hiding view
 */
- (void)willDismissAlertView:(QLCustomAlertView *)alertView;

/**
 after animation
 */
- (void)didDismissAlertView:(QLCustomAlertView *)alertView;

@end

NS_ASSUME_NONNULL_END

//
//  QLAlertAction.h
//  QLCustomAlertView
//
//  Created by qianlei on 2019/7/25.
//  Copyright © 2019 qianlei. All rights reserved.
//  控制“操作按钮”的UI与事件回调

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlertAction)(void);   //单个按钮的事件回调

@interface QLAlertAction : NSObject

/**
 按钮title文案
 */
@property (nonatomic, copy, nullable) NSString *text;

/**
 区分不同的action
 */
@property (nonatomic, assign) NSUInteger tag;

/**
 按钮背景色，default is “white”
 */
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/**
 text的颜色，default is “black”
 */
@property (nonatomic, strong, nullable) UIColor *textColor;

/**
 text高亮的颜色，default is “black”
 */
@property (nonatomic, strong, nullable) UIColor *textHighlightColor;

/**
 default is system 15.0
 */
@property (nonatomic, strong, nullable) UIFont *textFont;

/**
 文案对齐方式，default is ‘NSTextAlignmentCenter’
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;

/**
 设置image，default is nil
 */
@property (nonatomic, strong, nullable) UIImage *image;

/**
 设置highlightImage，default is nil
 */
@property (nonatomic, strong, nullable) UIImage *highlightImage;

/**
 设置backgroundImage，default is nil
 */
@property (nonatomic, strong, nullable) UIImage *backgroundImage;

/**
 设置backgroundHighlightImage，default is nil
 */
@property (nonatomic, strong, nullable) UIImage *backgroundHighlightImage;

/**
 事件回调的block，直接在初始化方法里添加的回调
 */
@property (nonatomic, copy, nullable) AlertAction alertAction;


/**
 设置不同方向button的圆角显示

 @param direction 1:全部圆角、2:上边圆角、3:下边圆角
 */
- (void)serCornerRadiusWithDirection:(NSInteger)direction;

/**
 获取出关联的button

 @return 返回对象
 */
- (UIButton *)optainActionButton;

/**
 初始化方法

 @param text title的文案
 @param action 回调block
 @return 返回实例
 */
+ (QLAlertAction *)actionWithText:(nullable NSString *)text
                      alertAction:(nullable AlertAction)action;

/**
 初始化方法

 @param text title的文案
 @param color title的颜色
 @param font title的font
 @param action 回调block
 @return 返回实例
 */
+ (QLAlertAction *)actionWithText:(nullable NSString *)text
                        textColor:(nullable UIColor *)color
                         textFont:(nullable UIFont *)font
                      alertAction:(nullable AlertAction)action;

/**
 初始化方法

 @param image button的image
 @param action 回调block
 @return 返回实例
 */
+ (QLAlertAction *)actionWithImage:(nullable UIImage *)image
                       alertAction:(nullable AlertAction)action;

/**
 初始化方法

 @param backgroundImage button的backgroundImage
 @param action 回调block
 @return 返回实例
 */
+ (QLAlertAction *)actionWithBackgroundImage:(nullable UIImage *)backgroundImage
                                 alertAction:(nullable AlertAction)action;

/**
 初始化方法

 @param text title的文案
 @param color title的颜色
 @param highlightColor highlightColor颜色
 @param backGroundColor title的backGroundColor颜色
 @param font title的字体
 @param aligment title的对齐方式
 @param action 回调block
 @return 返回实例
 */
+ (QLAlertAction *)actionWithText:(nullable NSString *)text
                        textColor:(nullable UIColor *)color
               textHighlightColor:(nullable UIColor *)highlightColor
                  backGroundColor:(nullable UIColor *)backGroundColor
                         textFont:(nullable UIFont *)font
                     textAligment:(NSTextAlignment)aligment
                      alertAction:(nullable AlertAction)action;

@end

NS_ASSUME_NONNULL_END

//
//  QLCustomAlertView.m
//  QLCustomAlertView
//
//  Created by qianlei on 2019/7/25.
//  Copyright © 2019 qianlei. All rights reserved.
//

#import "QLCustomAlertView.h"
#import <UIKit/UIKit.h>
#import "QLAlertAction.h"
#import "QLPopCustomBaseView.h"
#import "QLDefaultConstants.h"
#import "Masonry.h"

#define AnimationTimeInterval 0.25  //动画时延

@interface QLCustomAlertView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIWindow *alertWindow;    //弹窗的window
@property (nonatomic, strong) UIView *backgroundView;   //全屏的背景view
@property (nonatomic, strong) UIView *containerView;    //弹出框容器
@property (nonatomic, strong) QLPopCustomBaseView *popView;   //弹出框主视图
@property (nonatomic, strong) UIScrollView *alertActionScrollView;  //多个按钮的滑动显示
@property (nonatomic, strong) UIView *alertActionBackgroundView;    //alertActionScrollView的背景view
@property (nonatomic, strong) UIView *contentSperatorLineView;   //内容与操作按钮分割线
@property (nonatomic, strong) QLAlertAction *cancelButton;   //cancel按钮
@property (nonatomic, strong) NSMutableArray <QLAlertAction *> *otherButtonArray;    //其他按钮
@property (nonatomic, strong) NSMutableArray *alertActionSperatorLineArray;  //操作按钮之间的分割线
@property (nonatomic, assign, readwrite) NSUInteger numberOfButtons; //返回当前button个数
@property (nullable, nonatomic, copy, readwrite) NSString *inputViewText;   //输入框的内容

@end

static QLCustomAlertView *currentAlertView = nil;   //当前显示弹框

@implementation QLCustomAlertView

#pragma mark - Init Method

//初始化方法
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message {
    return [self initWithTitle:title message:message alertStyle:QLAlertViewStyleDefault delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message alertStyle:(QLAlertViewStyle)style {
    return [self initWithTitle:title message:message alertStyle:style delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id<QLCustomAlertViewDelegate>)delegate {
    return [self initWithTitle:title message:message alertStyle:QLAlertViewStyleDefault delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil];
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message alertStyle:(QLAlertViewStyle)style delegate:(nullable id<QLCustomAlertViewDelegate>)delegate {
    return [self initWithTitle:title message:message alertStyle:style delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil];
}

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                   alertStyle:(QLAlertViewStyle)style
                     delegate:(nullable id<QLCustomAlertViewDelegate>)delegate
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
            otherButtonTitles:(nullable NSArray <NSString *> *)otherButtonTitles {
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.alertViewStyle = style;
        self.delegate = delegate;
        self.touchBackgroundDismiss = (style == QLAlertViewStyleActionSheet || style == QLAlertViewStyleListSheet) ? YES : NO;
        self.returnKeyHideKeyboard = (style == QLAlertViewStyleTextField) ? YES : NO;
        self.showSperatorLine = YES;    //默认显示分割线
        self.showAsFixedEdgeDistance = YES;
        QLContainerMaxHeight = QLScreenHeight();
        if (cancelButtonTitle) {
            self.cancelButton.text = cancelButtonTitle;
        }
        if (otherButtonTitles) {
            __weak __typeof__(self) weakSelf = self;
            for (NSInteger i = 0; i < otherButtonTitles.count; i++) {
                QLAlertAction *alertAction = [QLAlertAction actionWithText:otherButtonTitles[i] alertAction:^{
                    __strong __typeof__(weakSelf) strongSelf = weakSelf;
                    [strongSelf alertButtonClickedAtIndex:i + 1];
                }];
                alertAction.tag = i + (_cancelButton ? 1 : 0);
                [self.otherButtonArray addObject:alertAction];
            }
        }
        [self.alertWindow addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.containerView];
        [self.containerView addSubview:self.popView];
        [self.containerView addSubview:self.alertActionBackgroundView];
        [self.alertActionBackgroundView addSubview:self.alertActionScrollView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"QLCustomAlertView dealloc");
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.containerView]) { //避免点击弹框内容导致弹出框消失
        return NO;
    }
    return YES;
}


#pragma mark - event response
- (void)alertButtonClickedAtIndex:(NSUInteger)index {
    __weak __typeof__(self) weakSelf = self;
    [self dismissWithAnimated:YES completionHandle:^{
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
            [strongSelf.delegate alertView:strongSelf clickedButtonAtIndex:index];
        }
    }];
}

//触摸背景的回调
- (void)tapBackground {
    if (self.touchBackgroundDismiss) {
        [self dismissWithAnimated:YES completionHandle:nil];
    } else if (self.hideKeyboradForClickBackground && (self.alertViewStyle == QLAlertViewStyleTextField || self.alertViewStyle == QLAlertViewStyleTextView)) {
        [self.popView endEditing:YES];
    }
}

//键盘出现
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *notificationUserInfo = notification.userInfo;
    CGFloat keyboardHeight = (notificationUserInfo[UIKeyboardFrameEndUserInfoKey] ? CGRectGetHeight([notificationUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]) : 0.0);
    
    if (keyboardHeight <= 1.0
        || self.alertWindow.hidden
        || !self.alertWindow.isKeyWindow
        || (self.alertViewStyle != QLAlertViewStyleTextField && self.alertViewStyle != QLAlertViewStyleTextView)) { //不满足弹出键盘的模式，不执行适配操作
        return;
    }
    QLContainerMaxHeight = QLScreenHeight() - keyboardHeight;
    [self adaptKeyboardAnimationWithInfor:notificationUserInfo keyboradShow:YES];
}

//键盘消失
- (void)keyboardWillHide:(NSNotification *)notification {
    QLContainerMaxHeight = QLScreenHeight();
    NSDictionary *notificationUserInfo = notification.userInfo;
    [self adaptKeyboardAnimationWithInfor:notificationUserInfo keyboradShow:NO];
}

//弹出框适配键盘出现的动画
- (void)adaptKeyboardAnimationWithInfor:(NSDictionary *)infor keyboradShow:(BOOL)show {
    NSTimeInterval animationDuration = [infor[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int animationCurve = [infor[UIKeyboardAnimationCurveUserInfoKey] intValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self makeAlertViewConstraintsShouldShowKeyBoard:show];
    [self.popView contentShouldScrollToBottom];
    [UIView commitAnimations];
}

//销毁弹出框视图
- (void)alertViewDestroy {
    [self.alertWindow resignKeyWindow];
    _popView = nil;
    _alertActionScrollView = nil;
    _containerView = nil;
    _alertWindow = nil;
    currentAlertView = nil;
    QLResetDefaultParameterValues();    //弹框销毁时，需要全局变量的默认值重制
}

#pragma mark - Show or Hide
//shows popup alert animated.
- (void)show {
    if (self.alertViewStyle == QLAlertViewStyleListSheet) {
        self.containerView.layer.cornerRadius = 0;
        self.containerView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    } else if (self.alertViewStyle == QLAlertViewStyleActionSheet) {
        self.containerView.backgroundColor = [UIColor clearColor];
    }
    [self setupAlertPopViewStyle];
    currentAlertView = self;
    CGRect containerRect = self.containerView.frame;
    if (self.alertViewStyle == QLAlertViewStyleActionSheet || self.alertViewStyle == QLAlertViewStyleListSheet) {
        self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.containerView.frame = CGRectMake(containerRect.origin.x, CGRectGetMaxY(containerRect), containerRect.size.width, containerRect.size.height);
        [UIView animateWithDuration:AnimationTimeInterval animations:^{
            self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            self.containerView.frame = containerRect;
        }];
    } else {
//        [self animationWithView:self.backgroundView duration:0.3];
    }
    [self.alertWindow makeKeyAndVisible];
    [self.popView contentShouldScrollToBottom];
}

//hides popup alert animated.
- (void)dismiss {
    [self dismissWithAnimated:YES completionHandle:nil];
}

//hides popup alert
- (void)dismissWithAnimated:(BOOL)animated completionHandle:(nullable dispatch_block_t)completion {
    [self.popView resignFirstResponder];
    if (self.alertViewStyle == QLAlertViewStyleActionSheet || self.alertViewStyle == QLAlertViewStyleListSheet) {
        CGRect containerRect = self.containerView.frame;
        [UIView animateWithDuration:AnimationTimeInterval animations:^{
            self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
            self.containerView.frame = CGRectMake(containerRect.origin.x, CGRectGetMaxY(containerRect) + 10, containerRect.size.width, containerRect.size.height);
        } completion:^(BOOL finished) {
            [self alertViewDestroy];
            if (completion) {
                completion();
            }
        }];
    } else {
        [self alertViewDestroy];
        if (completion) {
            completion();
        }
    }
}

//调用这个方法让弹框自动消失（不需要用户手动点击某个button），并执行某一个button下的事件回调
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    __weak __typeof__(self) weakSelf = self;
    [self dismissWithAnimated:animated completionHandle:^{
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        if (buttonIndex == 0) {
            if (strongSelf.cancelButton.alertAction) {
                strongSelf.cancelButton.alertAction();
            } else {
                [strongSelf alertButtonClickedAtIndex:0];
            }
        } else if (buttonIndex > 0 && buttonIndex > strongSelf.otherButtonArray.count) {
            QLAlertAction *action = strongSelf.otherButtonArray[buttonIndex - 1];
            if (action.alertAction) {
                action.alertAction();
            } else {
                [strongSelf alertButtonClickedAtIndex:buttonIndex];
            }
        }
    }];
}

#pragma mark - 动画效果
//仿系统alertView的弹出效果
- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [view.layer addAnimation:animation forKey:nil];
}

- (void)animationWithView {
    
}

#pragma mark - 链式调用
//链式语法设置title的颜色
- (QLCustomAlertView *(^)(UIColor *))titleColor {
    return ^id(UIColor *titleColor) {
        self.popView.titleColor = titleColor;
        return self;
    };
}

//设置title的font
- (QLCustomAlertView *(^)(UIFont *))titleFont {
    return ^id(UIFont *titleFont) {
        self.popView.titleFont = titleFont;
        return self;
    };
}

//设置message的颜色
- (QLCustomAlertView *(^)(UIColor *))messageColor {
    return ^id(UIColor *messageColor) {
        self.popView.messageColor = messageColor;
        return self;
    };
}

//设置message的font
- (QLCustomAlertView *(^)(UIFont *))messageFont {
    return ^id(UIFont *messageFont) {
        self.popView.messageFont = messageFont;
        return self;
    };
}

//设置textField与textView模式下的 placeHolder
- (QLCustomAlertView *(^)(NSString *))placeHolder {
    return ^id(NSString *placeHolder) {
        self.placeHolderString = placeHolder;
        return self;
    };
}

//设置弹框的显示样式
- (QLCustomAlertView *(^)(QLAlertViewStyle))alertStyle {
    return ^id(QLAlertViewStyle alertStyle) {
        self.alertViewStyle = alertStyle;
        self.popView.alertStyle = alertStyle;
        return self;
    };
}

//设置弹框的内容显示为customView
- (QLCustomAlertView *(^)(UIView *))customViewDeatil {
    return ^id(UIView *customViewDeatil) {
        self.customView = customViewDeatil;
        self.popView.customView = customViewDeatil;
        self.alertViewStyle = QLAlertViewStyleCustomView;
        return self;
    };
}

//设置cancel按钮的颜色
- (QLCustomAlertView *(^)(UIColor *))cancelTitleColor {
    return ^id(UIColor *cancelTitleColor) {
        self.cancelButton.textColor = cancelTitleColor;
        return self;
    };
}

//设置cancel按钮的font
- (QLCustomAlertView *(^)(UIFont *))cancelTitleFont {
    return ^id(UIFont *cancelTitleFont) {
        self.cancelButton.textFont = cancelTitleFont;
        return self;
    };
}

//设置其他按钮的颜色
- (QLCustomAlertView *(^)(NSArray <UIColor *> *))otherTitlesColor {
    return ^id(NSArray <UIColor *> *otherTitlesColor) {
        for (NSInteger i = 0; i < self.otherButtonArray.count; i++) {
            QLAlertAction *action = self.otherButtonArray[i];
            if (otherTitlesColor.count > i) {
                action.textColor = [otherTitlesColor objectAtIndex:i];
            }
        }
        return self;
    };
}

//设置其他按钮的font
- (QLCustomAlertView *(^)(NSArray <UIFont *> *))otherTitlesFont {
    return ^id(NSArray <UIFont *> *otherTitlesFont) {
        for (NSInteger i = 0; i < self.otherButtonArray.count; i++) {
            QLAlertAction *action = self.otherButtonArray[i];
            if (otherTitlesFont.count > i) {
                action.textFont = [otherTitlesFont objectAtIndex:i];
            }
        }
        return self;
    };
}

//添加单个操作button
- (QLCustomAlertView *(^)(QLAlertAction *))addAlertAction {
    return ^id(QLAlertAction *addAlertAction) {
        if (addAlertAction.alertAction) {
            AlertAction ac = addAlertAction.alertAction;
            __weak __typeof__(self) weakSelf = self;
            addAlertAction.alertAction = ^() {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf dismiss]; //添加dismiss的回调
                ac();
            };
        }
        [self.otherButtonArray addObject:addAlertAction];
        return self;
    };
}

//添加多个操作button
- (QLCustomAlertView *(^)(NSArray <QLAlertAction *> *))addAlertActionsFromArray {
    return ^id(NSArray <QLAlertAction *> * addAlertActionsFromArray) {
        for (QLAlertAction *alertAction in addAlertActionsFromArray) {
            AlertAction ac = alertAction.alertAction;
            __weak __typeof__(self) weakSelf = self;
            alertAction.alertAction = ^() {
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf dismiss]; //添加dismiss的回调
                ac();
            };
        }
        [self.otherButtonArray addObjectsFromArray:addAlertActionsFromArray];
        return self;
    };
}

#pragma mark - private
//添加弹出view的显示
- (void)setupAlertPopViewStyle {
    self.popView.alertStyle = self.alertViewStyle;
    [self setAlertContentValueToShow];
    [self makeAlertViewConstraintsShouldShowKeyBoard:NO];    //控制alertView的约束显示
    [self addAllAlertActionToShow];
}

//设置弹框的内容显示
- (void)setAlertContentValueToShow {
    self.popView.title = self.title;
    self.popView.message = self.message;
    self.popView.placeHolderString = self.placeHolderString;
}

//计算并控制弹出框的内容位置显示
- (void)makeAlertViewConstraintsShouldShowKeyBoard:(BOOL)show {
    CGFloat popViewHeight = QLDefaultPopViewHeight;
    if (!show) popViewHeight = [self calculatePopViewHeight];
    CGFloat containerViewHeight = 0;    //记录弹框的总高度
    if (self.alertViewStyle == QLAlertViewStyleListStyle) {  //alertAction上下排列
        containerViewHeight = popViewHeight + QLDefaultButtonHeight * self.numberOfButtons;
    } else if (self.alertViewStyle == QLAlertViewStyleActionSheet || self.alertViewStyle == QLAlertViewStyleListSheet) {    //actionSheet模式
        containerViewHeight = popViewHeight + QLDefaultButtonHeight * self.numberOfButtons + 10;
    } else {    //左右排列
        containerViewHeight = popViewHeight + QLDefaultButtonHeight;
    }
    //是否超过弹框最大长度限制
    if (containerViewHeight > QLAlertViewMaxHeight(self.alertViewStyle)) {
        if (popViewHeight > QLPopViewMaxHeight(self.alertViewStyle)) {
            popViewHeight = QLPopViewMaxHeight(self.alertViewStyle);
            self.popView.contentShouldScroll = YES; //内容视图可以滑动
        }
        containerViewHeight = QLAlertViewMaxHeight(self.alertViewStyle);
    }
    QLDefaultPopViewHeight = popViewHeight; //记录popView的高度
    if (self.alertViewStyle == QLAlertViewStyleActionSheet) { //sheet模式，这种样式下Cancel按钮不包含在scrollView内，固定在底部
        self.containerView.frame = CGRectMake(QLPopAlertWidthInterval, QLContainerMaxHeight - containerViewHeight - (QLScreenSafeBottom() > 1 ? QLScreenSafeBottom() : 10), QLPopAlertWidth, containerViewHeight);
        self.alertActionBackgroundView.frame = CGRectMake(0, popViewHeight, QLPopAlertWidth, containerViewHeight - popViewHeight - (_cancelButton ? (QLDefaultButtonHeight + 10) : 0));
    } else if (self.alertViewStyle == QLAlertViewStyleListSheet) {
        self.containerView.frame = CGRectMake(QLPopAlertWidthInterval, QLScreenHeight() - containerViewHeight - QLScreenSafeBottom(), QLPopAlertWidth, containerViewHeight);
        self.alertActionBackgroundView.frame = CGRectMake(0, popViewHeight, QLPopAlertWidth, containerViewHeight - popViewHeight - (_cancelButton ? (QLDefaultButtonHeight + 10) : 0));
    } else {
        self.containerView.frame = CGRectMake(QLPopAlertWidthInterval, (QLContainerMaxHeight - containerViewHeight) / 2, QLPopAlertWidth, containerViewHeight);
        self.alertActionBackgroundView.frame = CGRectMake(0, popViewHeight, QLPopAlertWidth, containerViewHeight - popViewHeight);
    }
    self.popView.frame = CGRectMake(0, 0, QLPopAlertWidth, popViewHeight);
    self.alertActionScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.alertActionBackgroundView.frame), CGRectGetHeight(self.alertActionBackgroundView.frame));
}

//计算popView部分的高度
- (CGFloat)calculatePopViewHeight {
    QLCalculatePopIntervalWidth(self.alertViewStyle, self.showAsFixedEdgeDistance);
    QLPopAlertWidth = QLScreenWidth() - QLPopAlertWidthInterval * 2;
    CGFloat popViewHeight = 40;
    CGFloat titleHeight = 0, messageHeight = 0;
    if (self.title && self.title.length > 0) {
        titleHeight = [self.title boundingRectWithSize:CGSizeMake(QLPopAlertWidth - 40, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.popView.titleFont} context:nil].size.height;
    }
    if (self.message && self.message.length > 0) {
        messageHeight = [self.message boundingRectWithSize:CGSizeMake(QLPopAlertWidth - 40, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.popView.messageFont} context:nil].size.height;
    }
    self.popView.titleHeight = titleHeight;
    CGFloat contentHeight = titleHeight + messageHeight;    //内容高度
    if (self.alertViewStyle == QLAlertViewStyleDefault) {
        popViewHeight = contentHeight + 50;
    } else if (self.alertViewStyle == QLAlertViewStyleListStyle || self.alertViewStyle == QLAlertViewStyleActionSheet || self.alertViewStyle == QLAlertViewStyleListSheet) {
        popViewHeight = contentHeight + ((contentHeight > 1) ? 50 : 0);
    } else if (self.alertViewStyle == QLAlertViewStyleTextField) {  //TextField模式
        popViewHeight = contentHeight + ((contentHeight > 1) ? 90 : 80);
    } else if (self.alertViewStyle == QLAlertViewStyleTextView) {    //TextView模式
        popViewHeight = contentHeight + ((contentHeight > 1) ? 160 : 140);
    } else if (self.alertViewStyle == QLAlertViewStyleCustomView) {    //自定义view
        popViewHeight = CGRectGetHeight(self.customView.frame);
    }
    return popViewHeight;
}

//添加控制操作按钮的显示
- (void)addAllAlertActionToShow {
    CGFloat alertActionWidth = [self calculateAlertActionWidth];
    if (self.alertViewStyle == QLAlertViewStyleListStyle) {  //上下排列
        self.alertActionScrollView.contentSize = CGSizeMake(QLPopAlertWidth, QLDefaultButtonHeight * self.numberOfButtons);
    } else if (self.alertViewStyle == QLAlertViewStyleActionSheet || self.alertViewStyle == QLAlertViewStyleListSheet) {    //actionSheet模式
        self.alertActionScrollView.contentSize = CGSizeMake(QLPopAlertWidth, QLDefaultButtonHeight * self.otherButtonArray.count);
    } else {    //左右排列
        self.alertActionScrollView.contentSize = CGSizeMake(alertActionWidth * self.numberOfButtons, QLDefaultButtonHeight);
    }
    [self addSperatorLineForAction:_cancelButton buttonWidth:alertActionWidth atIndex:0];
    for (NSInteger i = 0; i < self.otherButtonArray.count; i++) {
        [self addSperatorLineForAction:self.otherButtonArray[i] buttonWidth:alertActionWidth atIndex:i];
    }
    if (self.showSperatorLine) {    //添加popView与alertAction分割线
        self.contentSperatorLineView.frame = CGRectMake(0, CGRectGetMinY(self.alertActionBackgroundView.frame), QLPopAlertWidth, 1);
        [self.containerView addSubview:self.contentSperatorLineView];
    }
}

//计算操作按钮的长度
- (CGFloat)calculateAlertActionWidth {
    CGFloat buttonWidth = QLPopAlertWidth;
    if (self.alertViewStyle != QLAlertViewStyleListStyle && self.alertViewStyle != QLAlertViewStyleActionSheet && self.alertViewStyle != QLAlertViewStyleListSheet) {  //左右排列样式
        if (self.numberOfButtons == 2) {
            buttonWidth = buttonWidth / 2.0;
        } else if (self.numberOfButtons > 2) {
            buttonWidth = buttonWidth / 3.0;
        }
    }
    return buttonWidth;
}

//给按钮添加speratorLine分割线
- (void)addSperatorLineForAction:(QLAlertAction *)alertAction buttonWidth:(CGFloat)width atIndex:(NSInteger)index {
    if (alertAction == nil) return;
    UIButton *button = [alertAction optainActionButton];
    if (alertAction == _cancelButton) {
        if (self.alertViewStyle == QLAlertViewStyleListStyle) {  //列表排列样式
            button.frame = CGRectMake(0, self.otherButtonArray.count * QLDefaultButtonHeight, width, QLDefaultButtonHeight);
        } else if (self.alertViewStyle == QLAlertViewStyleActionSheet || self.alertViewStyle == QLAlertViewStyleListSheet) {
            button.frame = CGRectMake(0, CGRectGetHeight(self.containerView.frame) - QLDefaultButtonHeight, width, QLDefaultButtonHeight);
        } else {
            button.frame = CGRectMake(0, 0, width, QLDefaultButtonHeight);
        }
    } else {
        NSInteger offset = (_cancelButton ? 1 : 0) + index;
        UIView *lineView = nil; //分割线
        if (self.showSperatorLine && index < self.otherButtonArray.count) {
            lineView = self.alertActionSperatorLineArray[index];
            [button addSubview:lineView];
        }
        if (self.alertViewStyle == QLAlertViewStyleListStyle || self.alertViewStyle == QLAlertViewStyleActionSheet || self.alertViewStyle == QLAlertViewStyleListSheet) {  //列表排列样式
            button.frame = CGRectMake(0, index * QLDefaultButtonHeight, width, QLDefaultButtonHeight);
            lineView.frame = CGRectMake(0, QLDefaultButtonHeight - 1, width, 1);
            if (self.alertViewStyle == QLAlertViewStyleActionSheet) {
                [self cornerRadiusForAlertActionScrollView];
            }
        } else {    //水平分割线
            button.frame = CGRectMake(offset * width, 0, width, QLDefaultButtonHeight);
            lineView.frame = CGRectMake(0, 1, 1, QLDefaultButtonHeight - 1);
        }
    }
    if ((self.alertViewStyle == QLAlertViewStyleActionSheet || self.alertViewStyle == QLAlertViewStyleListSheet) && alertAction == _cancelButton) {
        [self.containerView addSubview:button];
        if (self.alertViewStyle == QLAlertViewStyleActionSheet) {
            [alertAction serCornerRadiusWithDirection:1];
        }
    } else {
        [self.alertActionScrollView addSubview:button];
    }
}

//设置操作按键scrollView的圆角
- (void)cornerRadiusForAlertActionScrollView {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.alertActionBackgroundView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.alertActionBackgroundView.bounds;
    layer.path = path.CGPath;
    self.alertActionBackgroundView.layer.mask = layer;
}

//根据index返回对应button上的文案
- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return  self.cancelButton.text;
    } else {
        if (self.otherButtonArray.count > buttonIndex) {
            return self.otherButtonArray[buttonIndex].text;
        }
    }
    return nil;
}

#pragma mark - setter and getter
- (void)setCustomView:(UIView *)customView {
    if (_customView != customView) {
        _customView = customView;
        self.popView.customView = _customView;
        self.alertViewStyle = QLAlertViewStyleCustomView;
    }
}

- (void)setReturnKeyHideKeyboard:(BOOL)returnKeyHideKeyboard {
    if (_returnKeyHideKeyboard != returnKeyHideKeyboard) {
        _returnKeyHideKeyboard = returnKeyHideKeyboard;
        self.popView.returnKeyHideKeyboard = _returnKeyHideKeyboard;
    }
}

- (NSUInteger)numberOfButtons {
    return self.otherButtonArray.count + ((_cancelButton == nil) ? 0 : 1);
}

- (UIWindow *)alertWindow {
    if (!_alertWindow) {
        _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertWindow.windowLevel = UIWindowLevelAlert;
        _alertWindow.hidden = YES;
        _alertWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _alertWindow.opaque = NO;
    }
    return _alertWindow;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
        tap.delegate = self;
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 13.0;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (QLPopCustomBaseView *)popView {
    if (!_popView) {
        _popView = [[QLPopCustomBaseView alloc] initWithFrame:CGRectMake(0, 0, QLPopAlertWidth, QLDefaultPopViewHeight - QLDefaultButtonHeight) alertViewStyle:QLAlertViewStyleDefault];
        __weak __typeof__(self) weakSelf = self;
        _popView.inputTextChanged = ^(NSString * _Nonnull text) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            strongSelf.inputViewText = text;
        };
    }
    return _popView;
}

- (UIScrollView *)alertActionScrollView {
    if (!_alertActionScrollView) {
        _alertActionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, QLDefaultPopViewHeight - QLDefaultButtonHeight, QLPopAlertWidth, QLDefaultButtonHeight)];
        _alertActionScrollView.contentSize = CGSizeMake(QLPopAlertWidth, QLDefaultButtonHeight);
        _alertActionScrollView.showsVerticalScrollIndicator = NO;
        _alertActionScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _alertActionScrollView;
}

- (UIView *)alertActionBackgroundView {
    if (!_alertActionBackgroundView) {
        _alertActionBackgroundView = [[UIView alloc] init];
        _alertActionBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _alertActionBackgroundView;
}

- (UIView *)contentSperatorLineView {
    if (!_contentSperatorLineView) {
        _contentSperatorLineView = [[UIView alloc] init];
        _contentSperatorLineView.backgroundColor = QLDefaultSeparatorLineColor;
    }
    return _contentSperatorLineView;
}

- (QLAlertAction *)cancelButton {
    if (!_cancelButton) {
        __weak __typeof__(self) weakSelf = self;
        _cancelButton = [QLAlertAction actionWithText:nil alertAction:^{
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf alertButtonClickedAtIndex:0];
        }];
        _cancelButton.tag = 0;
    }
    return _cancelButton;
}

- (NSMutableArray <QLAlertAction *> *)otherButtonArray {
    if (!_otherButtonArray) {
        _otherButtonArray = [NSMutableArray new];
    }
    return _otherButtonArray;
}

- (NSMutableArray *)alertActionSperatorLineArray {
    if (!_alertActionSperatorLineArray) {
        _alertActionSperatorLineArray = [NSMutableArray new];
        for (NSInteger i = 0; i < self.numberOfButtons; i++) {
            UIView *speratorLineView = [UIView new];
            speratorLineView.backgroundColor = QLDefaultSeparatorLineColor;
            [_alertActionSperatorLineArray addObject:speratorLineView];
        }
    }
    return _alertActionSperatorLineArray;
}

@end

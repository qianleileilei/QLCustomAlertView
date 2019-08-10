//
//  QLAlertAction.m
//  QLCustomAlertView
//
//  Created by qianlei on 2019/7/25.
//  Copyright © 2019 qianlei. All rights reserved.
//

#import "QLAlertAction.h"
#import "QLDefaultConstants.h"

@interface QLAlertAction ()

@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation QLAlertAction

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        self.text = nil;
        self.backgroundColor = QLDefaultBackgroundColor;
        self.textColor = [UIColor colorWithRed:0/255.0f green:89/255.0f blue:255/255.0f alpha:1.0];
        self.textHighlightColor = [UIColor colorWithRed:0/255.0f green:86/255.0f blue:255/255.0f alpha:1.0];
        self.textFont = [UIFont systemFontOfSize:17.0];
        self.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

//初始化方法
+ (QLAlertAction *)actionWithText:(nullable NSString *)text
                      alertAction:(nullable AlertAction)action {
    return [self actionWithText:text textColor:nil textHighlightColor:nil backGroundColor:nil textFont:nil textAligment:NSTextAlignmentCenter alertAction:action];
}

+ (QLAlertAction *)actionWithText:(nullable NSString *)text
                        textColor:(nullable UIColor *)color
                         textFont:(nullable UIFont *)font
                      alertAction:(nullable AlertAction)action {
    return [self actionWithText:text textColor:color textHighlightColor:nil backGroundColor:nil textFont:font textAligment:NSTextAlignmentCenter alertAction:action];
}

+ (QLAlertAction *)actionWithImage:(nullable UIImage *)image
                       alertAction:(nullable AlertAction)action {
    QLAlertAction *alertAction = [[QLAlertAction alloc] init];
    alertAction.image = image;
    alertAction.alertAction = action;
    [alertAction buttonInfo];
    
    return alertAction;
}

+ (QLAlertAction *)actionWithBackgroundImage:(nullable UIImage *)backgroundImage
                                 alertAction:(nullable AlertAction)action {
    QLAlertAction *alertAction = [[QLAlertAction alloc] init];
    alertAction.backgroundImage = backgroundImage;
    alertAction.alertAction = action;
    [alertAction buttonInfo];
    
    return alertAction;
}

+ (QLAlertAction *)actionWithText:(nullable NSString *)text
                        textColor:(nullable UIColor *)color
               textHighlightColor:(nullable UIColor *)highlightColor
                  backGroundColor:(nullable UIColor *)backGroundColor
                         textFont:(nullable UIFont *)font
                     textAligment:(NSTextAlignment)aligment
                      alertAction:(nullable AlertAction)action {
    QLAlertAction *alertAction = [[QLAlertAction alloc] init];
    alertAction.text = text;
    if (color) {
        alertAction.textColor = color;
        alertAction.textHighlightColor = color;
    }
    if (highlightColor) {
        alertAction.textHighlightColor = highlightColor;
    }
    if (backGroundColor) {
        alertAction.backgroundColor = backGroundColor;
    }
    if (font) {
        alertAction.textFont = font;
    }
    alertAction.textAlignment = aligment;
    alertAction.alertAction = action;
    [alertAction buttonInfo];
    
    return alertAction;
}

#pragma mark - event response
- (void)buttonClicked:(UIButton *)sender {
    if (self.alertAction) {
        self.alertAction();
    }
}

//设置不同方向button的圆角显示 (direction 1:全部圆角、2:上边圆角、3:下边圆角)
- (void)serCornerRadiusWithDirection:(NSInteger)direction {
    if (direction == 1) {
        self.actionButton.layer.cornerRadius = 13.0;
        self.actionButton.layer.masksToBounds = YES;
    } else if (direction == 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.actionButton.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = self.actionButton.bounds;
        layer.path = path.CGPath;
        self.actionButton.layer.mask = layer;
    } else if (direction == 3) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.actionButton.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(13, 13)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = self.actionButton.bounds;
        layer.path = path.CGPath;
        self.actionButton.layer.mask = layer;
    }
}

//获取出关联的button
- (UIButton *)optainActionButton {
    return self.actionButton;
}

//设置button对象
- (void)buttonInfo {
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setTitle:self.text forState:UIControlStateNormal];
    [actionButton setBackgroundColor:self.backgroundColor];
    [actionButton setTitleColor:self.textColor forState:UIControlStateNormal];
    [actionButton setTitleColor:self.textHighlightColor forState:UIControlStateHighlighted];
    [actionButton.titleLabel setFont:self.textFont];
    if (self.textAlignment == NSTextAlignmentLeft) {
        actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    } else if (self.textAlignment == NSTextAlignmentCenter) {
        actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else if (self.textAlignment == NSTextAlignmentRight) {
        actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    if (self.image) {
        [actionButton setImage:self.image forState:UIControlStateNormal];
    }
    if (self.highlightImage) {
        [actionButton setImage:self.highlightImage forState:UIControlStateHighlighted];
    }
    if (self.backgroundImage) {
        [actionButton setBackgroundImage:self.backgroundImage forState:UIControlStateNormal];
    }
    if (self.backgroundHighlightImage) {
        [actionButton setBackgroundImage:self.backgroundHighlightImage forState:UIControlStateHighlighted];
    }
    [actionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton = actionButton;
}

#pragma mark - setter and getter
- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        [self.actionButton setTitle:_text forState:UIControlStateNormal];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (_backgroundColor != backgroundColor) {
        _backgroundColor = backgroundColor;
        [self.actionButton setBackgroundColor:_backgroundColor];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        _textColor = textColor;
        [self.actionButton setTitleColor:_textColor forState:UIControlStateNormal];
    }
}

- (void)setTextHighlightColor:(UIColor *)textHighlightColor {
    if (_textHighlightColor != textHighlightColor) {
        _textHighlightColor = textHighlightColor;
        [self.actionButton setTitleColor:_textHighlightColor forState:UIControlStateHighlighted];
    }
}

- (void)setTextFont:(UIFont *)textFont {
    if (_textFont != textFont) {
        _textFont = textFont;
        [self.actionButton.titleLabel setFont:_textFont];
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment != textAlignment) {
        _textAlignment = textAlignment;
        if (_textAlignment == NSTextAlignmentLeft) {
            self.actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        } else if (_textAlignment == NSTextAlignmentCenter) {
            self.actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        } else if (_textAlignment == NSTextAlignmentRight) {
            self.actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
    }
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        [self.actionButton setImage:_image forState:UIControlStateNormal];
    }
}

- (void)setHighlightImage:(UIImage *)highlightImage {
    if (_highlightImage != highlightImage) {
        _highlightImage = highlightImage;
        [self.actionButton setImage:_highlightImage forState:UIControlStateHighlighted];
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
        [self.actionButton setBackgroundImage:_backgroundImage forState:UIControlStateNormal];
    }
}

- (void)setBackgroundHighlightImage:(UIImage *)backgroundHighlightImage {
    if (_backgroundHighlightImage != backgroundHighlightImage) {
        _backgroundHighlightImage = backgroundHighlightImage;
        [self.actionButton setBackgroundImage:_backgroundImage forState:UIControlStateHighlighted];
    }
}

- (void)setAlertAction:(AlertAction)alertAction {
    if (_alertAction != alertAction) {
        _alertAction = alertAction;
    }
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

@end

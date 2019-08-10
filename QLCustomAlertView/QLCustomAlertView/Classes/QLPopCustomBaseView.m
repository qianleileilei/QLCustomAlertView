//
//  QLPopCustomBaseView.m
//  QLCustomAlertView
//
//  Created by qianlei on 2019/7/26.
//  Copyright © 2019 qianlei. All rights reserved.
//

#import "QLPopCustomBaseView.h"
#import "Masonry.h"
#import "QLDefaultConstants.h"

@interface QLPopCustomBaseView () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView; //页面容器，在内容过长时可以滚动显示
@property (nonatomic, strong) UIView *contentView;  //内容容器
@property (nonatomic, strong) UILabel *titleLabel;  //标题label
@property (nonatomic, strong) UILabel *messageLabel;    //弹框正文内容
@property (nonatomic, strong) UITextField *textField;   //用于QLAlertViewStyleTextField模式
@property (nonatomic, strong) UITextView *textView; //用于QLAlertViewStyleTextView模式

@end

@implementation QLPopCustomBaseView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame alertViewStyle:(QLAlertViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        _titleColor = [UIColor blackColor];
        _titleFont = [UIFont boldSystemFontOfSize:16.0];
        _messageColor = [UIColor grayColor];
        _messageFont = [UIFont systemFontOfSize:14.0];
        _alertStyle = style;
        _contentShouldScroll = NO;  //默认不需要滚动显示
        [self setupSubviews];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.returnKeyHideKeyboard) {
        [textField resignFirstResponder];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if (self.returnKeyHideKeyboard && [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - event response
//根据类型设置subView
- (void)setupSubviews {
    if (self.alertStyle == QLAlertViewStyleCustomView) {
        self.customView.hidden = NO;
    } else {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.contentView];
        self.scrollView.hidden = NO;
        self.contentView.hidden = NO;
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.hidden = NO;
        [self.contentView addSubview:self.messageLabel];
        self.messageLabel.hidden = NO;
        if (self.alertStyle == QLAlertViewStyleTextField) {
            [self.contentView addSubview:self.textField];
            self.textField.hidden = NO;
        } else if (self.alertStyle == QLAlertViewStyleTextView) {
            [self.contentView addSubview:self.textView];
            self.textView.hidden = NO;
        }
    }
    [self layoutSubviews];
}

- (void)layoutSubviews {
    if (_scrollView) {  //当为QLAlertViewStyleCustomView模式时，可能不存在scrollView
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.removeExisting = YES;
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            if (!self.contentShouldScroll) {
                make.height.equalTo(self.scrollView);
            }
        }];
    }
    if (self.alertStyle == QLAlertViewStyleCustomView) {
        [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else  {
        self.titleLabel.frame = CGRectMake(20, 15, CGRectGetWidth(self.contentView.frame) - 40, self.titleHeight + 10);
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(self.titleLabel);
            if (self.contentShouldScroll && self.alertStyle != QLAlertViewStyleTextField && self.alertStyle != QLAlertViewStyleTextView) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }
        }];
        if (self.alertStyle == QLAlertViewStyleTextField || self.alertStyle == QLAlertViewStyleTextView) {
            UIView *inputView = (self.alertStyle == QLAlertViewStyleTextField) ? self.textField : self.textView;
            [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.messageLabel.mas_bottom).offset(15);
                make.centerX.equalTo(self.contentView);
                make.width.equalTo(self.titleLabel);
                make.height.mas_equalTo((self.alertStyle == QLAlertViewStyleTextField) ? 30 : 115);
                make.bottom.equalTo(self.contentView.mas_bottom).mas_equalTo(-14);
            }];
        }
    }
}

//textField相关的回调方法
- (void)textFieldDidChange {
    if (self.inputTextChanged) {
        self.inputTextChanged(self.textField.text);
    }
}

//textView相关的回调方法
- (void)textViewTextDidChange {
    if (self.inputTextChanged) {
        self.inputTextChanged(self.textView.text);
    }
}

//让内容滚动到底部显示
- (void)contentShouldScrollToBottom {
    if (self.contentShouldScroll && (self.alertStyle == QLAlertViewStyleTextField || self.alertStyle == QLAlertViewStyleTextView)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGPoint bottomOffset = CGPointMake(0, self.contentView.frame.size.height - self.scrollView.frame.size.height);
            [self.scrollView setContentOffset:bottomOffset animated:YES];
        });
    }
}

//让subViews不可见
- (void)hideAllSubViews {
    if (_scrollView) self.scrollView.hidden = YES;
    if (_contentView) self.contentView.hidden = YES;
    if (_titleLabel)  self.titleLabel.hidden = YES;
    if (_messageLabel)  self.messageLabel.hidden = YES;
    if (_textField)  self.textField.hidden = YES;
    if (_textView)  self.textView.hidden = YES;
    if (_customView) self.customView.hidden = YES;
}

#pragma mark - setter and getter
- (void)setAlertStyle:(QLAlertViewStyle)alertStyle {
    if (_alertStyle != alertStyle) {
        _alertStyle = alertStyle;
        [self hideAllSubViews];
        [self setupSubviews];
    }
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        self.titleLabel.text = _title;
    }
}

- (void)setMessage:(NSString *)message {
    if (_message != message) {
        _message = message;
        self.messageLabel.text = _message;
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (_titleColor != titleColor) {
        _titleColor = titleColor;
        self.titleLabel.textColor = _titleColor;
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        self.titleLabel.font = _titleFont;
    }
}

- (void)setMessageColor:(UIColor *)messageColor {
    if (_messageColor != messageColor) {
        _messageColor = messageColor;
        self.messageLabel.textColor = messageColor;
    }
}

- (void)setMessageFont:(UIFont *)messageFont {
    if (_messageFont != messageFont) {
        _messageFont = messageFont;
        self.messageLabel.font = _messageFont;
    }
}

- (void)setPlaceHolderString:(NSString *)placeHolderString {
    if (_placeHolderString != placeHolderString) {
        _placeHolderString = placeHolderString;
        if (self.alertStyle == QLAlertViewStyleTextField) {
            self.textField.placeholder = _placeHolderString;
        } else if (self.alertStyle == QLAlertViewStyleTextView) {
            
        }
    }
}

- (void)setCustomView:(UIView *)customView {
    if (_customView != customView) {
        _customView = customView;
        [self addSubview:_customView];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = nil;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = nil;
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:14.0];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _messageLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.layer.borderWidth = 1;
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.font = [UIFont systemFontOfSize:14.0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
        [_textField becomeFirstResponder];
    }
    return _textField;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.delegate = self;
        _textView.layer.borderWidth = 1.0;
        _textView.layer.cornerRadius = 4.0;
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.layer.masksToBounds = YES;
        [_textView becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return _textView;
}

@end

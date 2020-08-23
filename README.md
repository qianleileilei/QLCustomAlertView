# QLCustomAlertView

A Custom AlertView for easy handle UI

`QLCustomAlertView`支持多种不同样式的弹框，包括六种常见样式和自定义样式；可以方便的对系统**UIAlertController**进行UI扩展


### Objective-C 引用

```objective-c

pod "QLCustomAlertView"

```

### 当前支持以下几种不同的显示样式

```objective-c

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

```

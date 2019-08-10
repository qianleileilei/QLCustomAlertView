//
//  DemoAlertViewController.m
//  QLCustomAlertView
//
//  Created by qianlei on 2019/8/6.
//  Copyright © 2019 qianlei. All rights reserved.
//

#import "DemoAlertViewController.h"
#import "QLCustomAlertView.h"

@interface DemoAlertViewController () <QLCustomAlertViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DemoAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
////        [alert show];
//
//        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"Title" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Destructive" otherButtonTitles:@"Confirm", nil];
//        [ac showInView:self.view];
//    });

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.alertType == 1) {
            [self testDefaultAlertView];
        } else if (self.alertType == 2) {
            [self testListAlertView];
        } else if (self.alertType == 3) {
            [self testActionSheet];
        } else if (self.alertType == 4) {
            [self testListSheet];
        } else if (self.alertType == 5) {
            [self testAlertTextField];
        } else if (self.alertType == 6) {
            [self testAlertTextView];
        } else if (self.alertType == 7) {
            [self testAlertCustomView];
        }
    });
}

#pragma mark - QLCustomAlertViewDelegate
- (void)alertView:(QLCustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex = %li", buttonIndex);
}

#pragma mark - Default AlertView
- (void)testDefaultAlertView {
    QLCustomAlertView *alert = [[QLCustomAlertView alloc] initWithTitle:self.title message:@"The dust receives insult and in return offers her flowers" alertStyle:QLAlertViewStyleDefault delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObjects:@"Confirm", nil]];
//    //放开注释可以看到多个按钮的效果
//    QLAlertAction *a1 = [QLAlertAction actionWithText:@"Next" alertAction:^{
//        NSLog(@"next clicked");
//    }];
//    QLAlertAction *a2 = [QLAlertAction actionWithText:@"Finish" alertAction:^{
//        NSLog(@"finish clicked");
//    }];
//    alert.addAlertActionsFromArray([NSArray arrayWithObjects:a1, a2, nil]);
    [alert show];
}


#pragma mark - List AlertView
- (void)testListAlertView {
    QLCustomAlertView *alert = [[QLCustomAlertView alloc] initWithTitle:self.title message:@"The dust receives insult and in return offers her flowers" alertStyle:QLAlertViewStyleListStyle delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObjects:@"Confirm", nil]];
    QLAlertAction *a1 = [QLAlertAction actionWithText:@"Next" alertAction:^{
        NSLog(@"list Next clicked");
    }];
    QLAlertAction *a2 = [QLAlertAction actionWithText:@"Finish" alertAction:^{
        NSLog(@"list Finish clicked");
    }];
    alert.addAlertActionsFromArray([NSArray arrayWithObjects:a1, a2, nil]).otherTitlesColor([NSArray arrayWithObjects:[UIColor redColor], [UIColor orangeColor], [UIColor blueColor], nil]);
    alert.touchBackgroundDismiss = YES;
    [alert show];
}


#pragma mark - ActionSheet
- (void)testActionSheet {
    QLCustomAlertView *alert = [[QLCustomAlertView alloc] initWithTitle:self.title message:@"The dust receives insult and in return offers her flowers" alertStyle:QLAlertViewStyleActionSheet delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObjects:@"Confirm", nil]];
    QLAlertAction *a1 = [QLAlertAction actionWithText:@"Next" alertAction:^{
        NSLog(@"ActionSheet Next clicked");
    }];
    QLAlertAction *a2 = [QLAlertAction actionWithText:@"Finish" alertAction:^{
        NSLog(@"ActionSheet Finish clicked");
    }];
    alert.addAlertActionsFromArray([NSArray arrayWithObjects:a1, a2, nil]).cancelTitleColor([UIColor blueColor]).otherTitlesColor([NSArray arrayWithObjects:[UIColor redColor], [UIColor orangeColor], [UIColor blueColor], nil]);
    [alert show];
}

#pragma mark - ListSheet
- (void)testListSheet {
    QLCustomAlertView *alert = [[QLCustomAlertView alloc] initWithTitle:@"" message:nil alertStyle:QLAlertViewStyleListSheet delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObjects:@"Confirm1", @"Confirm2", @"Confirm3", @"Confirm4", @"Confirm5", nil]];
    alert.otherTitlesColor([NSArray arrayWithObjects:[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor blueColor], [UIColor greenColor], nil]);
    [alert show];
}

#pragma mark - Alert TextField
- (void)testAlertTextField {
    QLCustomAlertView *alert = [[QLCustomAlertView alloc] initWithTitle:self.title message:@"The dust receives insult and in return offers her flowers! The dust receives insult and in return offers her flowers! The dust receives insult and in return offers her flowers! The dust receives insult and in return offers her flowers! The dust receives insult and in return offers her flowers! " alertStyle:QLAlertViewStyleTextField delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObjects:@"Confirm", nil]];
    alert.otherTitlesColor([NSArray arrayWithObjects:[UIColor redColor], nil]);
    alert.placeHolderString = @"input.....";
    alert.hideKeyboradForClickBackground = YES;
    [alert show];
}

#pragma mark - Alert TextView
- (void)testAlertTextView {
    QLCustomAlertView *alert = [[QLCustomAlertView alloc] initWithTitle:self.title message:nil alertStyle:QLAlertViewStyleTextView delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObjects:@"Confirm", nil]];
    alert.otherTitlesColor([NSArray arrayWithObjects:[UIColor redColor], nil]);
    [alert show];
}

#pragma mark - Alert CustomView
- (void)testAlertCustomView {
    QLCustomAlertView *alert = [[QLCustomAlertView alloc] initWithTitle:self.title message:@"The dust receives insult and in return offers her flowers" alertStyle:QLAlertViewStyleDefault delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    QLAlertAction *a1 = [QLAlertAction actionWithText:@"Done" alertAction:^{
        NSLog(@"Done Clicked");
    }];
    alert.addAlertAction(a1).otherTitlesColor([NSArray arrayWithObjects:[UIColor redColor], nil]).otherTitlesFont([NSArray arrayWithObjects:[UIFont boldSystemFontOfSize:15.0], nil]).customViewDeatil(self.imageView);
    [alert show];
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleMonk"]];
        _imageView.frame = CGRectMake(0, 0, 200, 200);
    }
    return _imageView;
}

@end

//
//  ViewController.m
//  QLCustomAlertView
//
//  Created by qianlei on 2019/7/25.
//  Copyright © 2019 qianlei. All rights reserved.
//

#import "ViewController.h"
#import "DemoAlertViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Custom Alert View";
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoAlertViewController *vc = [[DemoAlertViewController alloc] init];
    vc.alertType = indexPath.row + 1;
    vc.title = self.titleArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"Default AlertView", @"List AlertView", @"ActionSheet", @"ListSheet", @"Alert TextField", @"Alert TextView", @"Alert CustomView", nil];
    }
    
    return _titleArray;
}

@end

//
//  ResultViewController.m
//  RefuseClassification
//
//  Created by wei.z on 2019/7/17.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import "ResultViewController.h"
#import "SearchTableViewCell.h"
#import <SafariServices/SafariServices.h>
@interface ResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"识别结果";
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell=[SearchTableViewCell  cellWithTableView:tableView];
    NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
    cell.label.text = [NSString stringWithFormat:@"%@  |  匹配度:%.1f%%",dic[@"name"],[dic[@"score"] floatValue]*100];
    cell.pimageView.image=[UIImage imageNamed:@"icon2"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[self.dataArray objectAtIndex:indexPath.row];
    NSString *str=dic[@"name"];
    if([str containsString:@"http://"] || [str containsString:@"https://"]){
        NSURL *url = [NSURL URLWithString:str];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
        [self presentViewController:safariVC animated:YES completion:nil];
    }
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NAV_HEIGHT)];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}
@end

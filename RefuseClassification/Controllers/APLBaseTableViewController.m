/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Base or common view controller to share a common UITableViewCell prototype between subclasses.
 */

#import "APLBaseTableViewController.h"
#import "APLProduct.h"
#import "SearchTableViewCell.h"
NSString *const kCellIdentifier = @"cellID";
NSString *const kTableCellNibName = @"TableCell";

@implementation APLBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[SearchTableViewCell class]
		 forCellReuseIdentifier:kCellIdentifier];
}

- (void)configureCell:(SearchTableViewCell *)cell forProduct:(APLProduct *)product {
    cell.label.text = [NSString stringWithFormat:@"%@  |  %@",product.title,product.type];
    cell.pimageView.image=[UIImage imageNamed:product.hardwareType];
}

@end

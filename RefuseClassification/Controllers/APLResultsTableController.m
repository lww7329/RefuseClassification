/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The table view controller responsible for displaying the filtered products as the user types in the search field.
 */

#import "APLResultsTableController.h"
#import "APLProduct.h"
#import "SearchTableViewCell.h"
@implementation APLResultsTableController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell=[SearchTableViewCell  cellWithTableView:tableView];
    APLProduct *product=[self.filteredProducts objectAtIndex:indexPath.row];
    cell.label.text = [NSString stringWithFormat:@"%@  |  %@",product.title,product.type];
    cell.pimageView.image=[UIImage imageNamed:product.hardwareType];
    return cell;
}

@end

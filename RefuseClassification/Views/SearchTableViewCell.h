//
//  SearchTableViewCell.h
//  RefuseClassification
//
//  Created by wei.z on 2019/7/17.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)UIImageView *pimageView;
@property(nonatomic,strong)UILabel *label;
@end

NS_ASSUME_NONNULL_END

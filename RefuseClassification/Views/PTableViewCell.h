//
//  PTableViewCell.h
//  FileDownloadPro
//
//  Created by wei.z on 2019/7/5.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PModel.h"
#import "UIImageView+WebCache.h"
NS_ASSUME_NONNULL_BEGIN

@interface PTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)PModel *model;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@end

NS_ASSUME_NONNULL_END

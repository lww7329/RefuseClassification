//
//  ResultViewController.h
//  RefuseClassification
//
//  Created by wei.z on 2019/7/17.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultViewController : UIViewController
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;
@end

NS_ASSUME_NONNULL_END

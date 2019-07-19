//
//  VCollectionCell.m
//  RefuseClassification
//
//  Created by wei.z on 2019/7/16.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import "VCollectionCell.h"

@implementation VCollectionCell
-(UILabel *)dataLabel{
    if(_dataLabel==nil){
         CGRect rect=self.bounds;
        _dataLabel = [[UILabel alloc] initWithFrame:rect];
        [_dataLabel setTextAlignment:NSTextAlignmentCenter];
        [_dataLabel setFont:[UIFont systemFontOfSize:12]];
        _dataLabel.textColor=[UIColor whiteColor];
        [self addSubview:_dataLabel];
    }
    return _dataLabel;
}
@end

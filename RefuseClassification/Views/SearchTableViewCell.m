//
//  SearchTableViewCell.m
//  RefuseClassification
//
//  Created by wei.z on 2019/7/17.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import "SearchTableViewCell.h"
@interface SearchTableViewCell()

@end
@implementation SearchTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *topicCellId = @"SearchTableViewCell";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellId];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    [self.contentView addSubview:self.pimageView];
    [self.contentView addSubview:self.label];
}
-(UIImageView *)pimageView{
    if(!_pimageView){
        _pimageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    }
    return _pimageView;
}
-(UILabel *)label{
    if(!_label){
        _label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pimageView.frame)+10, 10, kScreenWidth, 20)];
    }
    return _label;
}
@end

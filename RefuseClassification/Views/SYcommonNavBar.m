//
//  SYcommonNavBar.m
//  huazhen
//
//  Created by 刘伟伟 on 16/9/2.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYcommonNavBar.h"
@interface SYcommonNavBar()
@property(nonatomic,assign) int adaptHeight;
@end
@implementation SYcommonNavBar

-(instancetype)initWithFrame:(CGRect)frame{
    if(self==[super initWithFrame:frame]){
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.adaptHeight=0;
    if(iphoneX){
        self.adaptHeight=24;
    }
    [self addSubview:self.navView];
    [self addSubview:self.backButton];
    [self addSubview:self.textLabel];
    [self addSubview:self.rightButton];
    [self addSubview:self.lineView];
}
-(UIView *)navView{
    if(_navView==nil){
        _navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NAV_HEIGHT)];
        _navView.backgroundColor=[UIColor whiteColor];
    }
    return _navView;
}
-(UIButton *)backButton{
    if(_backButton==nil){
        _backButton = [[UIButton alloc]initWithFrame:CGRectMake(0,self.adaptHeight,30+13+10,20+30+10)];
        _backButton.imageEdgeInsets=UIEdgeInsetsMake(22, -10, 0, 0);
        [_backButton setImage:[UIImage imageNamed:@"backBack"]forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backClick)forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
-(UIButton *)rightButton{
    if(_rightButton==nil){
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-53,self.adaptHeight,30+13+10,20+30+10)];
        _rightButton.titleEdgeInsets=UIEdgeInsetsMake(22, -10, 0, 0);
        _rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [_rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(UILabel *)textLabel{
    if(_textLabel==nil){
        _textLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, 30+self.adaptHeight, 200, 20)];
        _textLabel.textColor=UIColorWithRGB(0x012250);
        _textLabel.font=[UIFont systemFontOfSize:18];
        _textLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _textLabel;
}
-(UIView *)lineView{
    if(_lineView==nil){
        _lineView=[[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT-1, kScreenWidth, 1)];
        _lineView.backgroundColor=UIColorWithRGB(0xd3d5d6);
    }
    return _lineView;
}
-(void)backClick{
    if([self.delegate respondsToSelector:@selector(goBack)]){
        [self.delegate goBack];
    }
}
-(void)rightClick{
    if([self.delegate respondsToSelector:@selector(goRight)]){
        [self.delegate goRight];
    }
}
@end

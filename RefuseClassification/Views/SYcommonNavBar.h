//
//  SYcommonNavBar.h
//  huazhen
//
//  Created by 刘伟伟 on 16/9/2.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol SYcommonNavBarDelegate <NSObject>
-(void)goBack;
@optional
-(void)goRight;
@end
@interface SYcommonNavBar : UIView
@property(nonatomic,strong)UIView *navView;
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UIView *loginView;
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)UIView *lineView;
@property (nonatomic, weak) id<SYcommonNavBarDelegate> delegate;
@end

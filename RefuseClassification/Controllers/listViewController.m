//
//  listViewController.m
//  RefuseClassification
//
//  Created by wei.z on 2019/7/16.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import "listViewController.h"
#import "VDetailViewController.h"
@interface listViewController ()

@end

@implementation listViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}


-(void)initUI{
    CGFloat w=120*1.3;
    CGFloat h=w/2*3;
    CGFloat mw=(kScreenWidth-2*w)/3;
    CGFloat mh=(kScreenHeight-2*h-NAV_HEIGHT-BAR_HEIGHT)/3;
    NSArray *array=@[@"kehui",@"youhai",@"canchu",@"qita"];
    for(int i=0;i<4;i++){
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(mw+i%2*(mw+w), mh+i/2*(mh+h), w, h)];
        imageView.image=[UIImage imageNamed:[array objectAtIndex:i]];
        imageView.userInteractionEnabled=YES;
        imageView.tag=i;
        UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(investButtonClick:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.view addSubview:imageView];
    }
    self.view.backgroundColor=[UIColor whiteColor];
}

-(void)investButtonClick:(UITapGestureRecognizer *)gest{
    int i=(int)gest.view.tag;
    VDetailViewController *v=[[VDetailViewController alloc] init];
    v.tag=i;
    v.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:v animated:YES];
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

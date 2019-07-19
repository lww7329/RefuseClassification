//
//  VTabBarViewController.m
//  RefuseClassification
//
//  Created by wei.z on 2019/7/16.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import "VTabBarViewController.h"
#import "ViewController.h"
#import "listViewController.h"
#import "APLMainTableViewController.h"
#import "APLProduct.h"
#import "CheckViewController.h"
#import <objc/runtime.h>
@interface VTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation VTabBarViewController

#pragma mark -  -----------------以下两个方法解决ios12.1tabbar图标位移问题，如以后IOS12.1解决则可移除--------------

/**
 *  用 block 重写某个 class 的指定方法
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做
 *  @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现，所以要在内部自己处理对 super 的调用，以及对当前调用方法的 self 的 class 的保护判断（因为如果 targetClass 的 targetSelector 是继承自父类的，targetClass 内部并没有重写这个方法，则我们这个函数最终重写的其实是父类的 targetSelector，所以会产生预期之外的 class 的影响，例如 targetClass 传进来  UIButton.class，则最终可能会影响到 UIView.class），implementationBlock 的参数里第一个为你要修改的 class，也即等同于 targetClass，第二个参数为你要修改的 selector，也即等同于 targetSelector，第三个参数是 targetSelector 原本的实现，由于 IMP 可以直接当成 C 函数调用，所以可利用它来实现“调用 super”的效果，但由于 targetSelector 的参数个数、参数类型、返回值类型，都会影响 IMP 的调用写法，所以这个调用只能由业务自己写。
 */
CG_INLINE BOOL
OverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP originIMP)) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!originMethod) {
        return NO;
    }
    IMP originIMP = method_getImplementation(originMethod);
    method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMP)));
    return YES;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 12.1, *)) {
            OverrideImplementation(NSClassFromString(@"UITabBarButton"), @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP originIMP) {
                return ^(UIView *selfObject, CGRect firstArgv) {
                    
                    if ([selfObject isKindOfClass:originClass]) {
                        // 如果发现即将要设置一个 size 为空的 frame，则屏蔽掉本次设置
                        if (!CGRectIsEmpty(selfObject.frame) && CGRectIsEmpty(firstArgv)) {
                            return;
                        }
                    }
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, CGRect);
                    originSelectorIMP = (void (*)(id, SEL, CGRect))originIMP;
                    originSelectorIMP(selfObject, originCMD, firstArgv);
                };
            });
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAllTabbarItems];
}

- (void)initAllTabbarItems{
    NSMutableArray *vcArray = [NSMutableArray array];
    NSArray *tabbarTitleArray = @[@"环保", @"分类", @"查询", @"识别"];
    NSArray *tabbarNormalArray = @[@"knowed", @"list",@"selected", @"search"];
    NSArray *tabbarHighlightArray = @[@"know", @"listed", @"select",@"searched"];
    UIViewController *controller = nil;
    for(int i=0;i<4;i++){
        switch (i) {
            case 0:{
                ViewController *con = [[ViewController alloc ] init];
                controller=con;
            }
                break;
            case 1:{
                listViewController *con = [[listViewController alloc ] init];
                controller=con;
            }
                break;
            case 2:{
                APLMainTableViewController *con=[[APLMainTableViewController alloc] init];
                con.products=[self loadMainData];
                controller=con;
            }
                break;
            case 3:{
                CheckViewController *con = [[CheckViewController alloc ] init];
                [con view];
                controller=con;
            }
            default:
                break;
        }
        if(controller){
            [vcArray addObject:[[UINavigationController alloc] initWithRootViewController:controller]];
            controller.title=tabbarTitleArray[i];
            UITabBarItem *item=[[UITabBarItem alloc] initWithTitle:tabbarTitleArray[i] image:[[UIImage imageNamed:tabbarNormalArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:tabbarHighlightArray[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            item.tag=i;
            controller.tabBarItem=item;
        }
    }
    self.viewControllers=vcArray;
    self.delegate=self;
    [self.tabBar setClipsToBounds:YES];
    
    self.tabBar.barTintColor=UIColorWithRGB(0xffffff);
    self.tabBar.tintColor=[UIColor clearColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       UIColorWithRGB(0x2b2b2b), NSForegroundColorAttributeName,[UIFont systemFontOfSize:11],NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       UIColorWithRGB(0x0c74ef), NSForegroundColorAttributeName,[UIFont systemFontOfSize:11],NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
}


-(NSMutableArray *)loadMainData{
    NSMutableArray *parray=[NSMutableArray array];
     NSArray *array=[NSArray arrayWithObjects:@"KFC纸袋",@"MP3",@"MP4",@"PET熟料瓶",@"PS费胶片",@"SMI卡",@"不锈钢被子",@"主板",@"乐高积木",@"书本",@"书包",@"二手手机",@"亚力克板",@"交通卡",@"会员卡",@"传真机",@"作业本",@"保温瓶",@"信封",@"充电器",@"充电牙刷",@"公文包",@"养乐多瓶",@"刀",@"剪刀",@"剃须刀片",@"办公桌",@"动感单车",@"包装纸",@"包装盒",@"台灯",@"台布",@"吸铁石",@"台式电脑",@"地毯",@"地板砖",@"啤酒罐",@"啤酒盖",@"可乐罐", nil];
    NSArray *array1=[NSArray arrayWithObjects:@"LED灯",@"X光片",@"一次性注射器",@"中性笔",@"保健品",@"充电电池",@"农药瓶",@"冻干粉",@"医用手套",@"医用棉签",@"医用纱布",@"医用针管",@"卤素灯",@"卸甲水",@"卸甲膜",@"口服液",@"口服液瓶",@"工业胶水",@"废农药",@"废弃灯泡",@"废弃药瓶",@"废旧小家电",@"废水银温度计",@"废水银血压计",@"废油漆",@"废矿物油",@"废节能灯",@"废荧光灯管",@"染发剂",@"染发剂壳",@"染发手套",@"树脂",@"氧化汞电池",@"水银体温计",@"油漆桶",@"注射器",@"眼药水",@"照片",@"老鼠药", nil];
    NSArray *array2=[NSArray arrayWithObjects:@"三文鱼",@"丝瓜皮",@"中药包",@"中药渣",@"乌龙茶",@"兔子粪便",@"八宝粥",@"八角",@"冬枣",@"冬瓜",@"冬瓜皮",@"凋谢的鲜花",@"凤梨皮",@"凤梨酥",@"剩菜剩饭",@"动物内脏",@"动物尸体",@"动物粪便",@"包子",@"午餐肉",@"南瓜皮",@"南瓜子",@"压缩饼干",@"叉烧",@"叉烧肉",@"味精",@"咸菜",@"咖喱粉",@"咸蛋",@"咸蛋壳",@"咸蛋黄",@"哈密瓜",@"哈密瓜皮",@"喜糖",@"土豆",@"奶油",@"奶粉",@"姜",@"姜糖", nil];
    NSArray *array3=[NSArray arrayWithObjects:@"1号电池(无汞)",@"5号电池(无汞)",@"7号电池(无汞)",@"A4包装纸",@"KFC纸盒",@"PH试纸",@"U盘",@"一次性保鲜膜",@"一次性口罩",@"一次性咖啡纸杯",@"一次性塑料勺子",@"一次性塑料手套",@"一次性塑料浴帽",@"一次性塑料盘",@"一次性塑料袋",@"一次性塑料调羹",@"一次性塑料餐盘",@"一次性手套",@"一次性打火机",@"一次性用品",@"一次性筷子",@"一次性纸杯",@"一次性餐具",@"三角裤",@"下水道杂物",@"丝袜",@"中药袋",@"便利贴",@"便纸",@"保冷剂",@"保鲜袋",@"信用卡",@"修正带",@"修正液",@"假发",@"假睫毛",@"储奶袋",@"光盘",@"内衣", nil];
    for(int i=0;i<array.count;i++){
        APLProduct *p=[[APLProduct alloc] init];
        p.title=[array objectAtIndex:i];
        p.type=@"可回收物";
        p.hardwareType=@"icon2";
        [parray addObject:p];
    }
    for(int i=0;i<array1.count;i++){
        APLProduct *p=[[APLProduct alloc] init];
        p.title=[array1 objectAtIndex:i];
        p.type=@"有害垃圾";
        p.hardwareType=@"icon3";
        [parray addObject:p];
    }
    for(int i=0;i<array2.count;i++){
        APLProduct *p=[[APLProduct alloc] init];
        p.title=[array2 objectAtIndex:i];
        p.type=@"厨余垃圾";
        p.hardwareType=@"icon4";
        [parray addObject:p];
    }
    for(int i=0;i<array3.count;i++){
        APLProduct *p=[[APLProduct alloc] init];
        p.title=[array3 objectAtIndex:i];
        p.type=@"其他垃圾";
        p.hardwareType=@"icon5";
        [parray addObject:p];
    }
    return parray;
}
@end

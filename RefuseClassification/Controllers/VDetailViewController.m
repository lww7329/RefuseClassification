//
//  VDetailViewController.m
//  RefuseClassification
//
//  Created by wei.z on 2019/7/16.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import "VDetailViewController.h"
#import "VCollectionCell.h"
NSString *const SZCalendarCellIdentifier = @"SZCalendarCellIdentifier";
@interface VDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *array;
@end

@implementation VDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
}

-(NSArray *)array{
    if(!_array){
        if(self.tag==0){
            self.title=@"可回垃圾";
            _array=[NSArray arrayWithObjects:@"KFC纸袋",@"MP3",@"MP4",@"PET熟料瓶",@"PS费胶片",@"SMI卡",@"不锈钢被子",@"主板",@"乐高积木",@"书本",@"书包",@"二手手机",@"亚力克板",@"交通卡",@"会员卡",@"传真机",@"作业本",@"保温瓶",@"信封",@"充电器",@"充电牙刷",@"公文包",@"养乐多瓶",@"刀",@"剪刀",@"剃须刀片",@"办公桌",@"动感单车",@"包装纸",@"包装盒",@"台灯",@"台布",@"吸铁石",@"台式电脑",@"地毯",@"地板砖",@"啤酒罐",@"啤酒盖",@"可乐罐", nil];
        }else if(self.tag==1){
            self.title=@"有害垃圾";
            _array=[NSArray arrayWithObjects:@"LED灯",@"X光片",@"一次性注射器",@"中性笔",@"保健品",@"充电电池",@"农药瓶",@"冻干粉",@"医用手套",@"医用棉签",@"医用纱布",@"医用针管",@"卤素灯",@"卸甲水",@"卸甲膜",@"口服液",@"口服液瓶",@"工业胶水",@"废农药",@"废弃灯泡",@"废弃药瓶",@"废旧小家电",@"废水银温度计",@"废水银血压计",@"废油漆",@"废矿物油",@"废节能灯",@"废荧光灯管",@"染发剂",@"染发剂壳",@"染发手套",@"树脂",@"氧化汞电池",@"水银体温计",@"油漆桶",@"注射器",@"眼药水",@"照片",@"老鼠药", nil];
        }else if(self.tag==2){
            self.title=@"厨余垃圾";
            _array=[NSArray arrayWithObjects:@"三文鱼",@"丝瓜皮",@"中药包",@"中药渣",@"乌龙茶",@"兔子粪便",@"八宝粥",@"八角",@"冬枣",@"冬瓜",@"冬瓜皮",@"凋谢的鲜花",@"凤梨皮",@"凤梨酥",@"剩菜剩饭",@"动物内脏",@"动物尸体",@"动物粪便",@"包子",@"午餐肉",@"南瓜皮",@"南瓜子",@"压缩饼干",@"叉烧",@"叉烧肉",@"味精",@"咸菜",@"咖喱粉",@"咸蛋",@"咸蛋壳",@"咸蛋黄",@"哈密瓜",@"哈密瓜皮",@"喜糖",@"土豆",@"奶油",@"奶粉",@"姜",@"姜糖", nil];
        }else{
            self.title=@"其他垃圾";
            _array=[NSArray arrayWithObjects:@"1号电池(无汞)",@"5号电池(无汞)",@"7号电池(无汞)",@"A4包装纸",@"KFC纸盒",@"PH试纸",@"U盘",@"一次性保鲜膜",@"一次性口罩",@"一次性咖啡纸杯",@"一次性塑料勺子",@"一次性塑料手套",@"一次性塑料浴帽",@"一次性塑料盘",@"一次性塑料袋",@"一次性塑料调羹",@"一次性塑料餐盘",@"一次性手套",@"一次性打火机",@"一次性用品",@"一次性筷子",@"一次性纸杯",@"一次性餐具",@"三角裤",@"下水道杂物",@"丝袜",@"中药袋",@"便利贴",@"便纸",@"保冷剂",@"保鲜袋",@"信用卡",@"修正带",@"修正液",@"假发",@"假睫毛",@"储奶袋",@"光盘",@"内衣", nil];
        }
    }
    return _array;
}

-(UICollectionView *)collectionView{
    if(_collectionView==nil){
        CGFloat itemWidth = (kScreenWidth-60) / 2;
        CGFloat itemHeight = 30;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 0, 20);
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        CGRect rect=CGRectMake(0, 0, kScreenWidth, kScreenHeight-NAV_HEIGHT);
        _collectionView=[[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor=[UIColor clearColor];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerClass:[VCollectionCell class] forCellWithReuseIdentifier:SZCalendarCellIdentifier];
    }
    return _collectionView;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SZCalendarCellIdentifier forIndexPath:indexPath];
    if(self.tag==0){
        cell.backgroundColor=UIColorWithRGBA(41, 55, 126, 1);
    }else if(self.tag==1){
        cell.backgroundColor=UIColorWithRGBA(188, 41, 39, 1);
    }else if(self.tag==2){
        cell.backgroundColor=UIColorWithRGBA(78, 138, 67, 1);
    }else{
        cell.backgroundColor=UIColorWithRGBA(112, 112, 110, 1);
    }
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds=YES;
    cell.dataLabel.text=[self.array objectAtIndex:indexPath.row];
    return cell;
}
@end

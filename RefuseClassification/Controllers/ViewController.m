//
//  ViewController.m
//  RefuseClassification
//
//  Created by wei.z on 2019/7/16.
//  Copyright © 2019 wei.z. All rights reserved.
//

#import "ViewController.h"
#import "PTableViewCell.h"
#import "PModel.h"
#import <SafariServices/SafariServices.h>
#import "SDCycleScrollView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) SDCycleScrollView *picturesView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.picturesView adjustWhenControllerViewWillAppera];
    [self.view addSubview:self.picturesView];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}
-(SDCycleScrollView *)picturesView{
    if (!_picturesView) {
        _picturesView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, nAdaptedWidthValue(150)) delegate:self placeholderImage:[UIImage imageNamed:@"defaultBanner"]];
        _picturesView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _picturesView.currentPageDotColor = [UIColor whiteColor];
        _picturesView.autoScrollTimeInterval=5.0f;
//        __weak typeof(self) weakSelf = self;
        _picturesView.clickItemOperationBlock = ^(NSInteger index) {
            NSLog(@">>>>>  %ld", (long)index);
//            weakSelf.pictureClickItemOperationBlock(index);
        };
        _picturesView.localizationImageNamesGroup=@[[UIImage imageNamed:@"b2"],[UIImage imageNamed:@"b3"],[UIImage imageNamed:@"b1"]];
    }
    return _picturesView;
}
-(UITableView *)tableView{
    if(_tableView==nil){
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, nAdaptedWidthValue(150), kScreenWidth, kScreenHeight-NAV_HEIGHT-BAR_HEIGHT-nAdaptedWidthValue(150)) style:UITableViewStylePlain];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if(_dataArray==nil){
        _dataArray=[NSMutableArray array];
        NSArray *titlearray=[NSArray arrayWithObjects:@"昆山城管严查倾倒危害废物垃圾",@"第二轮第一批中央生态环境保护督察全部实现督察进驻",@"山东将通过立法增强垃圾分类的强制性",@"生态环境部通报6月全国“12369”环保举报办理情况",@"苏州市医学会医学科技奖、苏州市环保产业协会环境保护科学技术奖设立",@"“环境保护与乡村振兴”暑期学校开课 学员跟随大咖“练功”", nil];
        NSArray *urlarray=[NSArray arrayWithObjects:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563271878789&di=65e6039b82bd78e3b34049937a2855dc&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170709%2F67097ab960504bf58bd06b907816a2da_th.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563275848457&di=a67e0931e487823e1e8103a77e972497&imgtype=0&src=http%3A%2F%2Fimg.sccnn.com%2Fbimg%2F320%2F126.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563275848455&di=9ba729144c11d9c0c2568bdbe970aab4&imgtype=0&src=http%3A%2F%2Fs6.sinaimg.cn%2Fmw690%2F003sKvkvzy6XvYmT2K195%26690",@"http://product.epday.com/file/upload/201907/15/150652181.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563275848476&di=be1b9bb0dd4f1fbcab32b0eb2de6967a&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20161206%2Fd20703f624b44a459aaba08e0e5519fa_th.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563275848471&di=7d6168893240fa35f88ec8f5a1aa817b&imgtype=0&src=http%3A%2F%2Fi9.hexun.com%2F2017-01-03%2F187594511.jpg", nil];
        NSArray *digestarray=[NSArray arrayWithObjects:@"近日，昆山市城管综保区中队在巡查至辖区桃园路时，发现在斯达瑞金属科技（昆山）有限公司的废弃厂房外，有9个废弃化工桶。",@"记者刚刚从生态环境部获悉，昨天下午中央第二生态环境保护督察组对福建省开展中央生态环境保护督察工作动员会在福州召开。至此，第二轮第一批中央生态环境保护督察全部实现督察进驻。",@"央广网济南7月16日消息（记者桂园）记者16日从山东省住建厅获悉，2020年底，济南、青岛、泰安3个试点城市基本建成垃圾分类体系，2025年其余各设区市基本建成垃圾分类体系；山东将通过立法增强垃圾分类的强制性，山东省住建厅将于今年年底前向省人大提交山东省城乡垃圾处理条例立法计划；",@"2019年6月，全国“12369环保举报联网管理平台”共接到环保举报44868件，环比降低2.3%，同比降低31.7%。本月接到的举报中，已受理36610件，未受理8258件。",@"苏报讯（记者　陆晓华　实习生　黄紫箫）近日，关于社会力量设立科学技术奖的公告发布。根据《苏州市政府印发关于进一步鼓励和规范苏州市社会力量设立科学技术奖的指导意见的通知》规定，苏州市医学会、苏州市环保产业协会分别完成了苏州市医学会医学科技奖、苏州市环保产业协会环境保护科学技术奖的设立工作。这两个奖项的设立，标志着我市推动社会科技奖励率先迈出实质性步伐。",@"红网时刻7月14日讯（记者 周丹 通讯员 屈俊林）为了培养符合新时代要求的环境保护区域的创新型人才，促进研究生与相关行业的专家、学者进行学术交流与沟通，7月13日，2019年“环境保护与乡村振兴”湖南省研究生暑期学校开学典礼在中南林业科技大学举行。来自浙江大学、中国科学院大学、中南大学、中南林业科技大学等28所高校的188名学员齐聚一堂，将跟随国内外专家学习15天。", nil];
        NSArray *sourcearray=[NSArray arrayWithObjects:@"中国网视窗",@"北京日报客户端",@"央广网",@"中国环境保护网",@"苏州日报",@"红网", nil];
        NSArray *ptimearray=[NSArray arrayWithObjects:@"07-16 10:37:07",@"07-16 10:44",@"07-16 10:46",@"2019-07-15",@"2019-07-16 10:19",@"07-14 22:19", nil];
        NSArray *linkarray=[NSArray arrayWithObjects:@"http://zgsc.china.com.cn/2019-07/16/content_40828765.html",@"http://baijiahao.baidu.com/s?id=1639181760753530769&wfr=spider&for=pc",@"http://baijiahao.baidu.com/s?id=1639182567872684473&wfr=spider&for=pc",@"http://www.epday.com/show.php/itemid-27626/",@"http://www.subaonet.com/2019/0716/2506328.shtml",@"http://baijiahao.baidu.com/s?id=1639043920053249985&wfr=spider&for=pc", nil];
        for(int i=0;i<titlearray.count;i++){
            PModel *m=[[PModel alloc] init];
            m.title=[titlearray objectAtIndex:i];
            m.url=[urlarray objectAtIndex:i];
            m.digest=[digestarray objectAtIndex:i];
            m.source=[sourcearray objectAtIndex:i];
            m.ptime=[ptimearray objectAtIndex:i];
            m.link=[linkarray objectAtIndex:i];
            [_dataArray addObject:m];
        }
    }
    return _dataArray;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PTableViewCell *cell=[PTableViewCell cellWithTableView:tableView];
    cell.model=[self.dataArray objectAtIndex:indexPath.row];;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PModel *model=[self.dataArray objectAtIndex:indexPath.row];
    if(model.link){
        NSURL *url = [NSURL URLWithString:model.link];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
        [self presentViewController:safariVC animated:YES completion:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


@end

//
//  BloodViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "BloodViewController.h"
#import "LineChartView.h"
#import "BloodRecordManager.h"
@interface BloodViewController ()
{
    UIScrollView *_baseScrollView;
    BloodRecord *_bloodRecord;
    LineChartView *_bloodLineChar;
    NSMutableArray *_lineDataSource;
    BOOL _tableViewSelected;
    LSSegment *_lsSegment;
}
@end

@implementation BloodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _tableViewSelected = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self getDataSource];

    [self layoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Method
- (void)layoutView
{
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 88, DEVICE_WIDTH, DEVICE_HEIGHT -88 -20)];
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.bounces = NO;
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.contentSize = CGSizeMake(DEVICE_WIDTH *3, DEVICE_HEIGHT -88 -20);
    [self.view addSubview:_baseScrollView];

    //*********segement
    [self createSegment];
    //*********Page1
    _bloodRecord = [self createBloodRecord];
    //*********Page3
    [self createTable];
    //*********Page2
    [self createAnalysis];
    
}

#pragma mark 创建段落
- (void)createSegment
{
    NSMutableArray *arr1 = [NSMutableArray new];
    NSMutableArray *arr2 = [NSMutableArray new];
    for (int i =1; i <= 3; i++) {
        NSString *str1 = [NSString stringWithFormat:@"blood_segment_%d",i];
        NSString *str2 = [NSString stringWithFormat:@"blood_segment_selected_%d",i];
        [arr1 addObject:str1];
        [arr2 addObject:str2];
    }
    _lsSegment = [[LSSegment alloc] initWithImageArray:arr1 andHighLightImages:arr2 frame:CGRectMake(0, 44, DEVICE_WIDTH, 44) superView:self.view delegate:self];
    
}

#pragma mark 创建录入界面
- (BloodRecord *)createBloodRecord
{
    BloodRecord *bloodRecord = [[[NSBundle mainBundle] loadNibNamed:@"BloodRecord" owner:self options:nil] firstObject];
    bloodRecord.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT -88 -20);
    [_baseScrollView addSubview:bloodRecord];
    [bloodRecord setSaveBlock:^(NSString *highPressure, NSString *lowPressure, NSString *pulse) {        
        if (!stringIsValidNumber(highPressure) ) {
            ALERT(@"", @"请录入正确的高压数字", @"确定");
            return ;
        }
        
        if(!stringIsValidNumber(lowPressure)) {
            ALERT(@"", @"请录入正确的低压数字", @"确定");
            return ;
        }
           
        if (!stringIsValidNumber(pulse)) {
            ALERT(@"", @"请录入正确的脉搏数字", @"确定");
            return ;
        }
        //直接上传
        NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
        [para setObject:highPressure forKey:@"systolicPressure"];
        [para setObject:lowPressure forKey:@"diastolicPressure"];
        [para setObject:pulse forKey:@"pulseRate"];
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [para setObject:[formatter stringFromDate:[NSDate date]] forKey:@"measureTime"];
        [self updataRecord:para];
        //暂时不需要保存本地。
//        [[BloodRecordManager sharedBloodRecordManager] addNewRecord:highPressure lowPressure:lowPressure pulse:pulse date:[NSDate dateWithTimeIntervalSinceNow:0]];
//        _dataSource = [[BloodRecordManager sharedBloodRecordManager] fetchAllDate];
//        [_tableView reloadData];
//        [self setLineChartDataSource:_bloodLineChar];
//        [_bloodLineChar setNeedsDisplay];

    }];
    return bloodRecord;
}

#pragma mark 创建走势图界面
- (void)createAnalysis
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH, 25, DEVICE_WIDTH, DEVICE_HEIGHT -20 -88  -20)];
//    scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.tag = 2;
    scrollView.maximumZoomScale = 3.0f;
    scrollView.delegate = self;
//    scrollView.contentSize = CGSizeMake(495, scrollView.frame.size.height + 20);
    [_baseScrollView addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blood_table_hit"]];
    imageView.frame = CGRectMake(DEVICE_WIDTH *1.5 -75, 5, 150, 20);
    [_baseScrollView addSubview:imageView];
    
    _bloodLineChar = [self buildLineChartView];
    [scrollView addSubview:_bloodLineChar];
    scrollView.contentSize = CGSizeMake(495, _bloodLineChar.frame.size.height);
}

- (LineChartView *)buildLineChartView
{
    //竖轴
    NSMutableArray *vArr = [[NSMutableArray alloc] init];
    for (int i=0; i<16; i++) {
        [vArr addObject:[NSString stringWithFormat:@"%d",i*20]];
    }
    //横轴
    NSMutableArray *hArr = [[NSMutableArray alloc] init];
    for (int i=1; i<31; i++) {
        [hArr addObject: [NSString stringWithFormat:@"%d",i]];
    }
    
    LineChartView *lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_HEIGHT, 20*16)];//DEVICE_HEIGHT -88 -20
    [lineChartView setHDesc:hArr];
    [lineChartView setVDesc:vArr];
//    lineChartView.hGap = 25;
//    lineChartView.vGap = 80;
    
//    [self setLineChartDataSource:lineChartView];
    return lineChartView;
}

#pragma mark 创建表格界面
- (void)createTable
{
    _dataSource = [[BloodRecordManager sharedBloodRecordManager] fetchAllDate];
    _tableView.frame = CGRectMake(DEVICE_WIDTH *2, 0, DEVICE_WIDTH, DEVICE_HEIGHT -88 -20);
    [_baseScrollView addSubview:_tableView];
}
#pragma mark 弹出框
- (void)popUpBoxHighPressure:(NSString *)hp lowPressure:(NSString *)lp pulse:(NSString *)p date:(NSString *)date
{
    LSBackGrayView *backView = [[LSBackGrayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:backView];

    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(30, 150, 260, 200)];
    tmpView.backgroundColor = [UIColor whiteColor];
    tmpView.layer.borderColor = [UIColor cyanColor].CGColor;
    tmpView.layer.borderWidth = 2.0f;
    tmpView.layer.cornerRadius = 8.0f;
    [backView addSubview:tmpView];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bt_cancel"]];
    imageView.frame = CGRectMake(260 +10, 150 -16, 33, 33);
    [backView addSubview:imageView];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 240, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    [tmpView addSubview:view];

    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 230, 40)];
    label0.font = [UIFont systemFontOfSize:20];
    label0.text = date;
    [tmpView addSubview:label0];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 40)];
    label1.font = [UIFont systemFontOfSize:20];
    label1.text = [NSString stringWithFormat:@"高压:  %@ mm/hg",hp];
    [tmpView addSubview:label1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 90, 200, 40)];
    label2.font = [UIFont systemFontOfSize:20];
    label2.text = [NSString stringWithFormat:@"低压:  %@ mm/hg",lp];
    [tmpView addSubview:label2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(50, 130, 200, 40)];
    label3.font = [UIFont systemFontOfSize:20];
    label3.text = [NSString stringWithFormat:@"脉搏:  %@/min",p];
    [tmpView addSubview:label3];

}

#pragma mark - TableView Delegate Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"bloodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        imageView.frame = CGRectMake(280, 4, 35, 35);
        [cell addSubview:imageView];
    }
    
    //从数据库取出的数据源，现在不用。直接映射网络资源
    //cell.textLabel.text = [_dataSource[indexPath.row] valueForKey:@"dateStr"];
    //直接引用json字段
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //使用日期模型查找对应录入记录。现在以服务器为主
//    //找出数据源对应的日期模型
//    id dateModel = _dataSource[indexPath.row];
//    
//    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
//        //传入日期模型获取录入数据（现在时取最后一次所以用lastObject）
//    NSManagedObject *recordModel = [[[BloodRecordManager sharedBloodRecordManager] fetchRecordBy:dateModel] lastObject];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy.MM.dd  HH:mm"];
//    NSString *date = [formatter stringFromDate:[recordModel valueForKey:@"date"]];
//    NSString *hp = [NSString stringWithFormat:@"高压:  %@ mm/hg",[recordModel valueForKey:@"highPressure"]];
//    NSString *lp = [NSString stringWithFormat:@"低压:  %@ mm/hg",[recordModel valueForKey:@"lowPressure"]];
//    NSString *p = [NSString stringWithFormat:@"脉搏:  %@/min",[recordModel valueForKey:@"pulse"]];
//    [self popUpBoxHighPressure:hp lowPressure:lp pulse:p date:date];
    //直接映射网络数据
    [self popUpBoxHighPressure:[_lineDataSource[indexPath.row] objectForKey:@"highPressure"] lowPressure:[_lineDataSource[indexPath.row] objectForKey:@"lowPressure"] pulse:[_lineDataSource[indexPath.row] objectForKey:@"pulse"] date:_dataSource[indexPath.row]];
    if (!_tableViewSelected) {
        _tableViewSelected = YES;
    }
    
}

#pragma mark - ScrollView Delegate Method
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"scroll...");
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"zooming");
    return _bloodLineChar;
}

#pragma mark - Event Method
- (void)segmentDidSelectedAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"000");
            [self cancelTableViewSelectedRowStatus];
        }
            break;
        case 1:
        {
            NSLog(@"1");
            [self cancelTableViewSelectedRowStatus];
        }
            break;
        case 2:
        {
            NSLog(@"2");
            [_tableView reloadData];
        }
            break;
        default:
            break;
    }
    [_bloodRecord.highPressure.textField resignFirstResponder];
    [_bloodRecord.lowPressure.textField resignFirstResponder];
    [_bloodRecord.pulse.textField resignFirstResponder];
    _baseScrollView.contentOffset = CGPointMake(DEVICE_WIDTH *index, 0);
    [_lsSegment setSelectedImage:index];
}

#pragma mark - Other Method
- (void)setLineChartDataSource:(LineChartView *)lineChartView
{
    //取出数据库数据制作数组
//    NSMutableArray *bloodItem = [NSMutableArray new];
//    for (id dateModel in _dataSource)
//    {
//        NSMutableDictionary *item = [NSMutableDictionary new];
//
//        NSManagedObject *recordModel = [[[BloodRecordManager sharedBloodRecordManager] fetchRecordBy:dateModel] lastObject];
//        [item setObject:[recordModel valueForKey:@"highPressure"] forKey:@"highPressure"];
//        [item setObject:[recordModel valueForKey:@"lowPressure"] forKey:@"lowPressure"];
//        [item setObject:[recordModel valueForKey:@"pulse"] forKey:@"pulse"];
//        [bloodItem addObject:item];
//        
//    }
//    [lineChartView setBloodArray:bloodItem];
    //绘画服务器数据
    [lineChartView setBloodArray:_lineDataSource];
}

BOOL stringIsValidNumber(NSString *checkString)
{
    if ([checkString isEqualToString:@""] || [checkString isKindOfClass:[NSNull class]]) {
        return NO;
    }
    NSString *stricterFilterString = @"^[0-9]*$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    if ([test evaluateWithObject:checkString] && [checkString intValue] <= 300 && [checkString intValue] > 10)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)cancelTableViewSelectedRowStatus {
    if (_tableViewSelected) {
        [_tableView selectRowAtIndexPath:0 animated:NO scrollPosition:0];
        _tableViewSelected = NO;
    }
}


#pragma mark - Updata &DownLoad
- (void)updataRecord:(NSDictionary *)para
{
//    NSArray *result = [[BloodRecordManager sharedBloodRecordManager] fetchRecordForUpData];
//    if (result.count != 0) {
//        //上传
//        for (id model in result)
//        {
//            上传单条数据
//        }
//    }
    //上传单条数据
    
    NSString *url = [NSString stringWithFormat:@"bloodPressure/add/%@.json",[self getCurrentPatientID]];
    [[HttpRequestManager sharedManager] requestWithParameters:para interface:url completionHandle:^(id returnObject) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        if ( [[Message sharedManager] bloodDataUpdateToServer:[result objectForKey:@"resultInfo"]] ) {
            ALERT(@"", @"数据已经上传", @"确定");
            [self segmentDidSelectedAtIndex:2];
        }
//        if ([[[result objectForKey:@"resultInfo"] objectForKey:@"retCode"] intValue] == 1) {
//            ALERT(@"信息更新", @"数据已经上传", @"确定");
//        }
    } failed:^{
        ALERT(@"网络错误", @"网络错误上传失败，您的数据降无法同步到服务器", @"确定");
    } hitSuperView:nil method:kPost];
}


- (void)getDataSource;
{
    NSString *url = [NSString stringWithFormat:@"bloodPressure/list/%@.json",[self getCurrentPatientID]];
    [[HttpRequestManager sharedManager] requestWithParameters:[NSMutableDictionary new] interface:url completionHandle:^(id returnObject) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
        if ([[Message sharedManager] checkBloodList:dict]) {
            [self parseData:dict];
        }
        
    } failed:^{
        ALERT(@"网络错误", @"网络错误上传失败，您的数据无法同步到服务器,请重试", @"确定");
    } hitSuperView:nil method:kPost];
}

- (void)parseData:(NSDictionary *)dict
{
    _dataSource = [NSMutableArray new];
    _lineDataSource = [NSMutableArray new];
    for (id x in [[dict categoryObjectForKey:@"resultInfo"] categoryObjectForKey:@"list"])
    {
        NSString *dateStr = [[[x categoryObjectForKey:@"createTime"] componentsSeparatedByString:@" "] firstObject];
        
        long index = [_dataSource indexOfObject:dateStr];
        NSMutableDictionary *item = [NSMutableDictionary dictionaryWithObjectsAndKeys:[x categoryObjectForKey:@"systolicPressure"],@"highPressure",[x categoryObjectForKey:@"diastolicPressure"],@"lowPressure",[x categoryObjectForKey:@"pulseRate"],@"pulse", nil];
        if (30 < index)
        {
//            if (index < 35) {
//                [(NSMutableArray *)_dataSource removeObjectAtIndex:0];
//                [_lineDataSource removeObjectAtIndex:0];
//            }
            [(NSMutableArray *)_dataSource addObject:dateStr];
            [_lineDataSource addObject:item];
        }
        else
        {
            [_lineDataSource replaceObjectAtIndex:index withObject:item];
        }
    }
    [_tableView reloadData];
    [self setLineChartDataSource:_bloodLineChar];
    [_bloodLineChar setNeedsDisplay];
}
@end

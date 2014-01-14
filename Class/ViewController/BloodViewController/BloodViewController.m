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
}
@end

@implementation BloodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    


    [self layoutView];
//    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
//    [parameter setObject:@"1388888" forKey:@"phoneNumber"];
//    /**
//     *  请求方法：
//     *  首先找出单例
//     *  @param  字典就是要传的json格式的参数
//     *  @param  字符串就是你要请求的接口
//     *  @param  block是你回调的方法
//     *  @return 不需要返回值
//     */
//    [[HttpRequestManager sharedManager] requestWithParameters:parameter interface:@"login.json" completionHandle:^(NSDictionary *jsonObject) {
//        NSLog(@"请求结束");
//    }];

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
    [[LSSegment alloc] initWithImageArray:arr1 andHighLightImages:arr2 frame:CGRectMake(0, 44, DEVICE_WIDTH, 44) superView:self.view delegate:self];
    
}

#pragma mark 创建录入界面
- (BloodRecord *)createBloodRecord
{
    BloodRecord *bloodRecord = [[[NSBundle mainBundle] loadNibNamed:@"BloodRecord" owner:self options:nil] firstObject];
    bloodRecord.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT -88 -20);
    [_baseScrollView addSubview:bloodRecord];
    [bloodRecord setSaveBlock:^(NSString *highPressure, NSString *lowPressure, NSString *pulse) {
        if (!stringIsValidNumber(highPressure) || !stringIsValidNumber(lowPressure) || !stringIsValidNumber(pulse))
        {
            NSLog(@"飞合法");
            return ;
        }
        [[BloodRecordManager sharedBloodRecordManager] addNewRecord:highPressure lowPressure:lowPressure pulse:pulse date:[NSDate dateWithTimeIntervalSinceNow:0]];
        _dataSource = [[BloodRecordManager sharedBloodRecordManager] fetchAllDate];
        [_tableView reloadData];
        [self setLineChartDataSource:_bloodLineChar];
        [_bloodLineChar setNeedsDisplay];

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
    scrollView.contentSize = CGSizeMake(495, scrollView.frame.size.height);
    [_baseScrollView addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blood_table_hit"]];
    imageView.frame = CGRectMake(DEVICE_WIDTH *1.5 -75, 5, 150, 20);
    [_baseScrollView addSubview:imageView];
    
    _bloodLineChar = [self buildLineChartView];
    [scrollView addSubview:_bloodLineChar];

}

- (LineChartView *)buildLineChartView
{
    
    LineChartView *lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_HEIGHT, DEVICE_HEIGHT -88 -20)];
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
    [lineChartView setHDesc:hArr];
    [lineChartView setVDesc:vArr];
    
    [self setLineChartDataSource:lineChartView];
    return lineChartView;
}

#pragma mark 创建表格界面
- (void)createTable
{
    _dataSource = [[BloodRecordManager sharedBloodRecordManager] fetchAllDate];
    _tableView.frame = CGRectMake(DEVICE_WIDTH *2, 0, DEVICE_WIDTH, DEVICE_HEIGHT -88 -20);
    [_baseScrollView addSubview:_tableView];
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
    
    
    cell.textLabel.text = [_dataSource[indexPath.row] valueForKey:@"dateStr"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"详细%d",indexPath.row);
    //找出数据源对应的日期模型
    id dateModel = _dataSource[indexPath.row];
    
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
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
    //传入日期模型获取录入数据（现在时取最后一次所以用lastObject）
    NSManagedObject *recordModel = [[[BloodRecordManager sharedBloodRecordManager] fetchRecordBy:dateModel] lastObject];
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 230, 40)];
    label0.font = [UIFont systemFontOfSize:20];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd  HH:mm"];
    label0.text = [formatter stringFromDate:[recordModel valueForKey:@"date"]];
    [tmpView addSubview:label0];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 40)];
    label1.font = [UIFont systemFontOfSize:20];
    label1.text = [NSString stringWithFormat:@"高压:  %@ mm/hg",[recordModel valueForKey:@"highPressure"]];
    [tmpView addSubview:label1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 90, 200, 40)];
    label2.font = [UIFont systemFontOfSize:20];
    label2.text = [NSString stringWithFormat:@"低压:  %@ mm/hg",[recordModel valueForKey:@"lowPressure"]];
    [tmpView addSubview:label2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(50, 130, 200, 40)];
    label3.font = [UIFont systemFontOfSize:20];
    label3.text = [NSString stringWithFormat:@"脉搏:  %@/min",[recordModel valueForKey:@"pulse"]];
    [tmpView addSubview:label3];
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
- (void)segmentDidSelectedAtIndex:(int)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"000");
        }
            break;
        case 1:
        {
            NSLog(@"1");
        }
            break;
        case 2:
        {
            NSLog(@"2");
        }
            break;
        default:
            break;
    }
    [_bloodRecord.highPressure.textField resignFirstResponder];
    [_bloodRecord.lowPressure.textField resignFirstResponder];
    [_bloodRecord.pulse.textField resignFirstResponder];
    _baseScrollView.contentOffset = CGPointMake(DEVICE_WIDTH *index, 0);
}

#pragma mark - Other Method
- (void)setLineChartDataSource:(LineChartView *)lineChartView
{
    
    NSMutableArray *bloodItem = [NSMutableArray new];
    for (id dateModel in _dataSource) {
        NSMutableDictionary *item = [NSMutableDictionary new];

        NSManagedObject *recordModel = [[[BloodRecordManager sharedBloodRecordManager] fetchRecordBy:dateModel] lastObject];
        [item setObject:[recordModel valueForKey:@"highPressure"] forKey:@"highPressure"];
        [item setObject:[recordModel valueForKey:@"lowPressure"] forKey:@"lowPressure"];
        [item setObject:[recordModel valueForKey:@"pulse"] forKey:@"pulse"];
        [bloodItem addObject:item];
        
    }
    [lineChartView setBloodArray:bloodItem];
}

BOOL stringIsValidNumber(NSString *checkString)
{
    NSString *stricterFilterString = @"^[0-9]*$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    if ([test evaluateWithObject:checkString] && [checkString integerValue] <= 300)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end

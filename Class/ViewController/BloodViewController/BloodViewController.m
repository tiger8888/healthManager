//
//  BloodViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "BloodViewController.h"
#import "LineChartView.h"

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
    
    //*********Page2
    [self createAnalysis];
    //*********Page3
    [self createTable];
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
    [_baseScrollView addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blood_table_hit"]];
    imageView.frame = CGRectMake(DEVICE_WIDTH *2 -170, 5, 150, 20);
    [_baseScrollView addSubview:imageView];
    
    _bloodLineChar = [self buildLineChartView];
    [scrollView addSubview:_bloodLineChar];

}

- (LineChartView *)buildLineChartView
{
    LineChartView *lineChartView;
    lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_HEIGHT, DEVICE_HEIGHT -88 -20)];
    
    //竖轴
    NSMutableArray *vArr = [[NSMutableArray alloc] init];
    for (int i=0; i<16; i++) {
        [vArr addObject:[NSString stringWithFormat:@"%d",i*20]];
    }
    
    //横轴
    NSMutableArray *hArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *bloodItem = [NSMutableArray new];
    int bloodValue = 0;
    for (int i=1; i<31; i++) {
        [hArr addObject: [NSString stringWithFormat:@"%d",i]];
        NSMutableDictionary *item = [NSMutableDictionary new];
        
        bloodValue = arc4random()%110 + 90;
        [item setObject:[NSString stringWithFormat:@"%d",bloodValue] forKey:@"highPressure"];
        
        bloodValue = arc4random()%70 + 60;
        [item setObject:[NSString stringWithFormat:@"%d",bloodValue] forKey:@"lowPressure"];
        
        bloodValue = arc4random()%30 + 60;
        [item setObject:[NSString stringWithFormat:@"%d",bloodValue] forKey:@"pulse"];
        //        if (i%2==0)bloodValue = 130;
        //        else bloodValue = 150;
        [bloodItem addObject:item];
    }
    
    [lineChartView setBloodArray:bloodItem];
    [lineChartView setHDesc:hArr];
    [lineChartView setVDesc:vArr];
    
    return lineChartView;
}

#pragma mark 创建表格界面
- (void)createTable
{
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
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@" yyyy.MM.dd  hh:mm:ss"];
    
    cell.textLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"详细%d",indexPath.row);
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

@end

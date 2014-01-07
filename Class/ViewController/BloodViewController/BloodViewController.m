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
    UITapGestureRecognizer *_tgr;
    UIScrollView *_baseScrollView;
    LineChartView *bloodLineChar;
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Method
- (void)layoutView
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
    
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 88, DEVICE_WIDTH, DEVICE_HEIGHT -88)];
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.bounces = NO;
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.contentSize = CGSizeMake(DEVICE_WIDTH *3, DEVICE_HEIGHT -88);
    
    [self.view addSubview:_baseScrollView];

    
    //*********Page1
    BloodRecord *bloodRecord = [[[NSBundle mainBundle] loadNibNamed:@"BloodRecord" owner:self options:nil] firstObject];
//    bloodRecord.frame = CGRectMake(0, 88, DEVICE_WIDTH, 480);
    _tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_baseScrollView addGestureRecognizer:_tgr];
    [_baseScrollView addSubview:bloodRecord];

    //*********Page2
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, 480)];
//    scrollView.backgroundColor = [UIColor redColor];
    scrollView.tag = 2;
    scrollView.maximumZoomScale = 3.0f;
    scrollView.delegate = self;
    [_baseScrollView addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blood_table_hit"]];
//    imageView.frame = CGRectMake(DEVICE_WIDTH -170, 5, 150, 20);
    static CGFloat imageCenterX = 0;
    if ( imageCenterX == 0)
        imageCenterX = (DEVICE_WIDTH - imageView.frame.size.width) / 2;
    
    imageView.frame = CGRectMake(imageCenterX, 5, 150, 20);
    [scrollView addSubview:imageView];
    
    bloodLineChar = [self buildLineChartView];
    [scrollView addSubview:bloodLineChar];
    
    //*********Page3
    _tableView.frame = CGRectMake(DEVICE_WIDTH *2, 0, DEVICE_WIDTH, DEVICE_HEIGHT -88);
    [_baseScrollView addSubview:_tableView];
}

#pragma mark - Textfield Delegate Method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"blood_texfield_selected.png"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"blood_texfield.png"];
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

#pragma mark - Event Method
- (void)segmentDidSelectedAtIndex:(int)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"000");
            _tgr.enabled = YES;
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
            _tgr.enabled = NO;
        }
            break;
        default:
            break;
    }
    [self tapGesture:nil];
    _baseScrollView.contentOffset = CGPointMake(DEVICE_WIDTH *index, 0);
}

- (IBAction)saveBTBClick:(id)sender
{
    NSLog(@"save");
}

- (void)tapGesture:(id)sender
{
    [self.highPressure resignFirstResponder];
    [self.lowPressure resignFirstResponder];
    [self.pulse resignFirstResponder];
}
#pragma mark - ScrollView Delegate Method
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"scroll...");
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"zooming");
    return bloodLineChar;
}
#pragma mark - custom method
- (LineChartView *)buildLineChartView {
    LineChartView *lineChartView;
    lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 25, 320, 340)];
    NSMutableArray *pointArr = [[NSMutableArray alloc]init];
    
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
        bloodValue = arc4random()%110 + 90;
        //        if (i%2==0)bloodValue = 130;
        //        else bloodValue = 150;
        [bloodItem addObject:[NSValue valueWithCGPoint:CGPointMake(i, bloodValue)]];
    }
    [pointArr addObject:[bloodItem copy] ];
    [bloodItem removeAllObjects];
    
    for (int i=1; i<31; i++) {
        [hArr addObject: [NSString stringWithFormat:@"%d",i]];
        bloodValue = arc4random()%70 + 60;
        //        if (i%2==0)bloodValue = 130;
        //        else bloodValue = 150;
        [bloodItem addObject:[NSValue valueWithCGPoint:CGPointMake(i, bloodValue)]];
    }
    [pointArr addObject:[bloodItem copy]];
    [bloodItem removeAllObjects];
    
    for (int i=1; i<31; i++) {
        [hArr addObject: [NSString stringWithFormat:@"%d",i]];
        bloodValue = arc4random()%30 + 60;
        //        if (i%2==0)bloodValue = 130;
        //        else bloodValue = 150;
        [bloodItem addObject:[NSValue valueWithCGPoint:CGPointMake(i, bloodValue)]];
    }
    [pointArr addObject:[bloodItem copy]];
    bloodItem = NULL;
    
    [lineChartView setBloodArray:pointArr];
    [lineChartView setHDesc:hArr];
    [lineChartView setVDesc:vArr];
    
    return lineChartView;
}
@end

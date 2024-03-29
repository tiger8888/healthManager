//
//  DoctorViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "DoctorViewController.h"
#import "SessionViewController.h"
#import "DoctorBusiness.h"

@interface DoctorViewController ()

@end

@implementation DoctorViewController

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
    [[DoctorBusiness sharedManager] getAllDoctor:^(NSArray *arr) {
        _dataSource = arr;
        [_tableView reloadData];
    } superView:self.view];
//    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:[NSString stringWithFormat:@"patient/doctor/list/%@.json",[[UserBusiness sharedManager] getCurrentPatientID]] completionHandle:^(id returnObject) {
////        NSLog(@"%@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
//        
//        NSDictionary * returnDict = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
//        _dataSource = [[returnDict objectForKey:@"resultInfo"] objectForKey:@"list"];
//        [_tableView reloadData];
//        
//    } failed:^{
//        
//    } hitSuperView:self.view method:kGet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate Method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"docCell";
    DoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorCell" owner:nil options:nil] firstObject];
        cell.delegate = self;
    }
    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    LSBackGrayView *backView = [[LSBackGrayView alloc] initWithFrame:FULLSCREEN];
    [self.view addSubview:backView];
    
    
    //
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 260, DEVICE_HEIGHT -64 -60)];
    tmpView.backgroundColor = [UIColor whiteColor];
    tmpView.layer.borderColor = [UIColor cyanColor].CGColor;
    tmpView.layer.borderWidth = 2.0f;
    tmpView.layer.cornerRadius = 8.0f;
    [backView addSubview:tmpView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bt_cancel"]];
    imageView.frame = CGRectMake(275, 15, 33, 33);
    [backView addSubview:imageView];
    //
    UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, 240, DEVICE_HEIGHT -64 -90)];
    label.text = [NSString stringWithFormat:@"医生介绍:%@",[_dataSource[indexPath.row] objectForKey:@"profesIntro"]];
    label.editable = NO;
    label.font = [UIFont systemFontOfSize:16];
    [tmpView addSubview:label];
}

#pragma mark - CellDelegate Method
- (void)delegateOnClick:(id)cell
{
    NSIndexPath *index = [_tableView indexPathForCell:cell];
    LSBackGrayView *backView = [[LSBackGrayView alloc] initWithFrame:FULLSCREEN];
    [self.view addSubview:backView];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(30, 100, 260, 200)];
    tmpView.backgroundColor = [UIColor whiteColor];
    tmpView.layer.borderColor = [UIColor cyanColor].CGColor;
    tmpView.layer.borderWidth = 2.0f;
    tmpView.layer.cornerRadius = 8.0f;
    [backView addSubview:tmpView];
    NSString *name = [_dataSource[index.row] objectForKey:@"name"];
    NSString *htmlStr = [NSString stringWithFormat:@"<p>您申请 <b >%@</b> 医师成为您的专属医生，%@ 医生将为您提供一对一的医疗服务。</p>",name,name];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 10, 220, 100)];
    [webView loadHTMLString:htmlStr baseURL:nil];
    
    [tmpView addSubview:webView];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(15, 140, 110, 35);
    nextButton.tag = index.row;
    [nextButton setBackgroundImage:[UIImage imageNamed:@"bt_pop_ok"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(popButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:nextButton];
    
    UIImageView *cancelImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bt_pop_cancel"]];
    cancelImage.frame = CGRectMake(135, 140, 110, 35);
    [tmpView addSubview:cancelImage];
}

#pragma mark - Event Method
- (void)backButtonClick
{
    NSLog(@"back");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)popButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSDictionary *dict = _dataSource[button.tag];
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    [[DoctorBusiness sharedManager] addMyDoctor:[dict objectForKey:@"doctorId"]];
//    [self relateDoctorID:[dict objectForKey:@"doctorId"]];
    
//    NSString *classStr = [[[(AppDelegate *)([UIApplication sharedApplication].delegate) propertyList] objectAtIndex:9] objectForKey:@"class"];
//    Class class = NSClassFromString(classStr);
    
    
    
    UIViewController * viewController = [[SessionViewController alloc] initWithCategory:9];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

//- (void)relateDoctorID:(id)obj
//{
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    [userDef setObject:obj forKey:DOCTORID_KEY];
//    [userDef synchronize];
//    
//    NSString *url = [NSString stringWithFormat:@"patient/doctor/add/%@/%@.json",[userDef objectForKey:PATIENTID_KEY],obj];
//    NSLog(@"%@",url);
//    [[HttpRequestManager sharedManager] requestWithParameters:nil interface:url completionHandle:^(id returnObject) {
//        NSLog(@"%@",[[NSString alloc] initWithData:returnObject encoding:NSUTF8StringEncoding]);
//        
//    } failed:^{
//        
//    } hitSuperView:nil method:kPost];
//}
@end

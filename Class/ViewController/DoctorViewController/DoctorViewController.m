//
//  DoctorViewController.m
//  HealthManager
//
//  Created by LiShuo on 13-12-2.
//  Copyright (c) 2013年 LiShuo. All rights reserved.
//

#import "DoctorViewController.h"

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

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"详细%d",indexPath.row);
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    LSBackGrayView *backView = [[LSBackGrayView alloc] initWithFrame:FULLSCREEN];
    [self.view addSubview:backView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 300)];
    lable.text = [NSString stringWithFormat:@"index:%d",indexPath.row];
    [backView addSubview:lable];
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
    
    NSString *htmlStr = [NSString stringWithFormat:@"<p>您申请 <b >%@%d</b> 医师成为您的专属医生，%@%d 医生将为您提供一对一的医疗服务。</p>",@"人名",index.row,@"人名",index.row];
    
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
- (void)popButtonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"%d",button.tag);
}

@end

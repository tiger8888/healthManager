//
//  DPBloodListCell.m
//  HealthManager
//
//  Created by user on 14-2-28.
//  Copyright (c) 2014年 LiShuo. All rights reserved.
//

#import "DPListCell.h"



@interface DPListCell ()
{
    NSArray *_data;
    NSMutableArray *_clickStatus;
    NSString *_bloodValueFormat;
    NSMutableArray *_detailData;
}
@end

@implementation DPListCell
@synthesize expandBtn, isExpanded;
@synthesize subTable;

+ (int) getHeight
{
    return height;
}

+ (int) getsubCellHeight
{
    return subCellHeight;
}

#pragma mark - set/get


#pragma mark - life circle
- (id) initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        _bloodValueFormat = @"%@--高压%@  低压%@  脉搏%@";
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setupInterface];
}

- (void) setupInterface
{
    [self setClipsToBounds: YES];
    
    expandBtn.frame = CGRectMake(DEVICE_WIDTH-50, 6, 44, 44);
    [expandBtn setBackgroundColor:[UIColor clearColor]];
    [expandBtn addTarget:self.parentTable action:@selector(collapsableButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [expandBtn addTarget:self action:@selector(rotateExpandBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
#pragma mark - uitable view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BloodCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BloodCell"];
    }
    NSDictionary *itemObj = [_detailData objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:_bloodValueFormat, [[itemObj objectForKey:@"dateStr"] substringWithRange:NSMakeRange(11, 5)], [itemObj objectForKey:@"highPressure"], [itemObj objectForKey:@"lowPressure"], [itemObj objectForKey:@"pulse"] ];
    
    cell.textLabel.textColor = UICOLORFROMRGB(0x636363);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return subCellHeight;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
#pragma mark - 类方法
-(void)setupCell:(NSArray *)data  withClickStatus:(NSMutableArray *)clickStatus withIndex:(NSIndexPath *)indexPath{
    //    NSLog(@"data count %d",[data count]);
    _data = data;
    _clickStatus = clickStatus;
    
    NSDictionary *itemObj = [_data lastObject];
    self.mainTitle.text = [[[itemObj objectForKey:@"dateStr"] substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.subTitle.text = [NSString stringWithFormat:_bloodValueFormat, [[itemObj objectForKey:@"dateStr"] substringWithRange:NSMakeRange(11, 5)], [itemObj objectForKey:@"highPressure"], [itemObj objectForKey:@"lowPressure"], [itemObj objectForKey:@"pulse"] ];
    
    if ([data count] > 1) {
        expandBtn.hidden = NO;
        _detailData = [NSMutableArray new];
        for (NSDictionary *item in _data) {
            [_detailData addObject:item];
        }
        
//        if ([_clickStatus[indexPath.row] intValue] == 1) {
//            [self loadDetailList];
//        }
//        else {
//            [self unloadDetailList];
//        }
//        
//        [self layoutIfNeeded];
    }
    else {
        _detailData = nil;
        expandBtn.hidden = YES;
    }
    
}


#pragma mark - behavior

- (void)rotateExpandBtn:(id)sender
{
    isExpanded = !isExpanded;
    switch (isExpanded) {
        case 0:
            [self rotateExpandBtnToCollapsed];
            self.subTitle.hidden = NO;
            [self unmoveSubTable];
            break;
        case 1:
            [self rotateExpandBtnToExpanded];
            self.subTitle.hidden = YES;
            [self moveSubTable];
            break;
        default:
            break;
    }
}

-(void)moveSubTable {
    CGRect frame = subTable.frame;
    frame = CGRectMake(self.subTitle.frame.origin.x-8, self.subTitle.frame.origin.y, frame.size.width, frame.size.height);
    subTable.frame = frame;
}

- (void)unmoveSubTable {
    CGRect frame = subTable.frame;
    frame = CGRectMake(self.subTitle.frame.origin.x-8, self.subTitle.frame.origin.y+self.subTitle.frame.size.height, frame.size.width, frame.size.height);
    subTable.frame = frame;
}

- (void)rotateExpandBtnToExpanded
{
    NSLog(@"%s", __func__);
    [UIView beginAnimations:@"rotateDisclosureButt" context:nil];
    [UIView setAnimationDuration:0.2];
    expandBtn.transform = CGAffineTransformMakeRotation(M_PI*1);
    [UIView commitAnimations];
}

- (void)rotateExpandBtnToCollapsed
{
    [UIView beginAnimations:@"rotateDisclosureButt" context:nil];
    [UIView setAnimationDuration:0.2];
    expandBtn.transform = CGAffineTransformMakeRotation(M_PI*2);
    [UIView commitAnimations];
}
@end

//
//  TKIShowGoodsVM.m
//  tracedemo
//
//  Created by 罗田佳 on 15/12/14.
//  Copyright © 2015年 trace. All rights reserved.
//

#import "TKIShowGoodsVM.h"
#import "TKShowGoodsCell.h"
#import "TKIShowGoodsRowM.h"
#import "TKUITools.h"

@implementation TKIShowGoodsVM


-(void)tkLoadDefaultData
{
    
    /**
     
     data4.picAddr1 = @"http://183.131.13.104:80/share/data/spider/pic/user/11186/weibo/weibo_20151109124331_438_X.jpg";
     data4.picAddr2 = @"http://183.131.13.104:80/share/data/spider/pic/user/11186/weibo/weibo_20151109124332_084_X.jpg";
     data4.picAddr3 = @"http://183.131.13.104:80/share/data/spider/pic/user/11186/weibo/weibo_20151109124332_498_X.jpg";
     data4.picAddr4 = @"http://183.131.13.104:80/share/data/spider/pic/user/11186/weibo/weibo_20151109124332_950_X.jpg";
     data4.picAddr5 = @"http://183.131.13.104:80/share/data/spider/pic/user/11186/weibo/weibo_20151109124331_438_X.jpg";
     data4.picAddr6 = @"http://183.131.13.104:80/share/data/spider/pic/user/11186/weibo/weibo_20151109124331_438_X.jpg";
     data4.picAddr7 = @"http://183.131.13.104:80/share/data/spider/pic/user/11186/weibo/weibo_20151109124331_438_X.jpg";
     **/
    
    TKTableSectionM * section = [[TKTableSectionM alloc] init];
    [section.rowsData removeAllObjects];
    section.sectionHeadHeight = 1;
    section.sectionFootHeight = 1;
    
    for(int i=0;i<20;i++)
    {
        TKIShowGoodsRowM * row = [[TKIShowGoodsRowM alloc] init];
        
        row.showGoodsData = [[TKShowGoodsRowData alloc] init];
        
        for(int k = 0;k<=i; k++)
        {
            [row.showGoodsData.pics addObject:@"http://183.131.13.104:80/share/data/spider/pic/user/11186/weibo/weibo_20151109124331_438_X.jpg"];
        }
        
        [section.rowsData addObject:row];
    }
    [self setDefaultSection:section];
}



- (void)beginPullDownRefreshing
{
    [self tkLoadDefaultData];
    [self.mTableView reloadData];
    // tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.3];
}

- (void)beginPullUpLoading
{
    [self tkLoadDefaultData];
    [self.mTableView reloadData];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.3];
}

-(BOOL)hasRefreshFooterView
{
    return YES;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKShowGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"showGoodsCell"];
    if(cell == nil)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TKShowGoodsCell" owner:self options:nil].firstObject;
        cell.backgroundColor = [UIColor clearColor];
        [cell.layer setCornerRadius:5];
        [cell setClipsToBounds:YES];
    }
    [self fillCellImages:cell indexPath:indexPath];
    return cell;
}


-(void)fillCellImages:(TKShowGoodsCell *)cell  indexPath:(NSIndexPath *)indexPath
{
    TKIShowGoodsRowM * rowD = (TKIShowGoodsRowM *)[self.defaultSection.rowsData objectAtIndex:indexPath.row];
//    [rowD]
    NSMutableArray * pics = rowD.showGoodsData.pics;
    
    int type = (pics.count == 4?2:3);
    

    for(UIView *view in [cell.imageContentView subviews])
    {
        [view removeFromSuperview];
    }
    
    
    for(int i = 0;i< pics.count;i++)
    {
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                              action:@selector(showBigImage:)];
        UIImageView * img = [[UIImageView alloc] init];
        TKSetLoadingImageView(img, [pics objectAtIndex:i]);
        [cell.imageContentView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([rowD getPicWidth]);
            make.height.mas_equalTo([rowD getPicHeight]);
            CGFloat px = i%type * ([rowD getPicWidth] +[rowD getPicSeparation]) + [rowD getPicPaddingLeft];
            CGFloat py = i/type * ([rowD getPicHeight] + [rowD getPicSeparation]);
            make.top.mas_equalTo(py );
            make.left.mas_equalTo(px );
        
        }];
        
        [img setUserInteractionEnabled:YES];
        [img addGestureRecognizer:tap];
        img.tag = indexPath.row * 1000 + i;
        
    }
    
    cell.imageFiledHeight.constant = rowD.rowHeight;
    [cell.imageContentView layoutIfNeeded];
    
    
    
//    [cell.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        make.height.mas_equalTo(rowD.rowHeight);
//    }];
    
    
}

-(void)showBigImage:(UITapGestureRecognizer *)tap
{
    int index = tap.view.tag%1000;
    NSInteger rowIndex = tap.view.tag/1000;
    
    TKIShowGoodsRowM * rowD = (TKIShowGoodsRowM *)[self.defaultSection.rowsData objectAtIndex:rowIndex];
    [TKUITools showImagesInBigScreen:rowD.showGoodsData.pics
                       withImageView: (UIImageView *)tap.view
                        currentIndex:index];
}



//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 305;
//}


@end

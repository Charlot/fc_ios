//
//  XiangDetailModel.h
//  Material
//
//  Created by wayne on 16/4/19.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiangDetailModel : NSObject
@property(nonatomic,strong)NSMutableArray *xiangDetailArray;
+(instancetype)sharedXiangDetailStore:(UITableView *)view;
//-(Xiang *)addXiang:(NSString *)key partNumber:(NSString *)partNumber quatity:(NSString *)quatity;
-(NSInteger)xiangDetailCount;
-(NSArray *)xiangDetailList;
//-(void)removeXiang:(NSInteger)index;

@end

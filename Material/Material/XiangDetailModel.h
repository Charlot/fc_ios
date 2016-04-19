//
//  XiangDetailModel.h
//  Material
//
//  Created by wayne on 16/4/19.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiangDetailModel : NSObject
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *partNr;
@property (nonatomic,copy) NSString *quantity;
-(instancetype)initWithObject:(NSDictionary *)object;
@property(nonatomic,strong) NSMutableArray *xiangdetailist;
-(void)addXiangdetailist:(NSSet *)xiangdetailist;
@end

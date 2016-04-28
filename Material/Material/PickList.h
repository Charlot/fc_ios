//
//  PickList.h
//  Material
//
//  Created by Charlot on 16/4/13.
//  Copyright © 2016年 brilliantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickList : NSObject
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *userNr;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)NSString *createdAt;



-(instancetype)initWithObject:(NSDictionary *)dictionary;
@end

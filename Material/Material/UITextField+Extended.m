//
//  UITextField+Extended.m
//  Material
//
//  Created by exmooncake on 15-6-18.
//  Copyright (c) 2015年 brilliantech. All rights reserved.
//

#import "UITextField+Extended.h"
#import <objc/runtime.h>

static char defaultHashKey;

@implementation UITextField(Extended)

- (UITextField *) nextTextField {
    return objc_getAssociatedObject(self, &defaultHashKey);
}

- (void) setNextTextField:(UITextField *)nextTextField{
    objc_setAssociatedObject(self, &defaultHashKey, nextTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

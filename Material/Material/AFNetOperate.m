//
//  AFNetOperate.m
//  Material
//
//  Created by wayne on 14-6-10.
//  Copyright (c) 2014年 brilliantech. All rights reserved.
//

#import "AFNetOperate.h"
#import "Xiang.h"
#import "Tuo.h"
#import "Yun.h"
#import <AudioToolbox/AudioToolbox.h>
@interface AFNetOperate()
@property(nonatomic,strong)UIAlertView *alert;
@end

@implementation AFNetOperate
-(instancetype)init
{
    self=[super init];
    if(self){
        self.activeView=[[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return  self;
}
-(AFHTTPRequestOperationManager *)generateManager:(UIView *)view
{
    self.activeView.center=CGPointMake(view.bounds.size.width/2, view.bounds.size.width/2-21.0);
    self.activeView.hidesWhenStopped=YES;
    [view addSubview:self.activeView];
    [self.activeView startAnimating];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    return manager;
}
-(void)alert:(id)content
{
    NSString *string=[NSString string];
    NSString *class=[NSString stringWithFormat:@"%@",[content class]];
    if([class isEqualToString:@"__NSCFString"]){
        string=content;
    }
    else if([class isEqualToString:@"__NSCFArray"]){
        for(int i=0;i<[(NSArray *)content count];i++){
            string=[string stringByAppendingString:[NSString stringWithFormat:@" %@",content[i]]];
        }
    }
    self.alert = [[UIAlertView alloc]initWithTitle:@""
                                                  message:string
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self
                                   selector:@selector(dissmissAlert:)
                                   userInfo:nil
                                    repeats:NO];
    AudioServicesPlaySystemSound(1051);
    [self.alert show];
  
}
-(void)alertSuccess:(NSString *)string
{
    self.alert = [[UIAlertView alloc]initWithTitle:@""
                                           message:string
                                          delegate:self
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.8f
                                     target:self
                                   selector:@selector(dissmissAlert:)
                                   userInfo:nil
                                    repeats:NO];
    AudioServicesPlaySystemSound(1012);
    [self.alert show];
}
-(void)dissmissAlert:(NSTimer *)timer
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    self.alert=nil;
//}
#pragma keyarchive relative method
-(void)setKeyArchive:(NSString *)path keyArray:(NSArray *)keyArray objectArray:(NSArray *)objectArray
{
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
    for(int i=0;i<keyArray.count;i++){
        [dictionary setObject:objectArray[i] forKey:keyArray[i]];
    }
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *archivePath=[document stringByAppendingPathComponent:path];
    [NSKeyedArchiver archiveRootObject:dictionary toFile:archivePath];
}
-(id)getKeyArchive:(NSString *)path key:(NSString *)key
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *pathArchive=[document stringByAppendingPathComponent:path];
    NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchive];
    id object=[dictionary objectForKey:key];
    return object;
}
#pragma url method
-(NSMutableDictionary *)URLDictionary
{
    NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"URL" ofType:@"plist"];
    NSMutableDictionary *URLDictionary=[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return URLDictionary;
}
-(NSString *)baseURL
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"ip.address.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSString *base=[dictionary objectForKey:@"ip"];
        NSString *port=[dictionary objectForKey:@"port"];
        return [base stringByAppendingString:port];
    }
    else{
        NSString *base=[[self URLDictionary] objectForKey:@"base"];
        NSString *port=[[self URLDictionary] objectForKey:@"port"];
        return [base stringByAppendingString:port];
    }    
}
-(NSString *)baseURLWithoutPort
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"ip.address.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSString *base=[dictionary objectForKey:@"ip"];
        return base;
    }
    else{
        NSString *base=[[self URLDictionary] objectForKey:@"base"];
        return base;
    }
}
//resource part
-(NSString *)part_index
{
    NSString *base=[self baseURL];
    NSString *part=[[[self URLDictionary] objectForKey:@"part"] objectForKey:@"root"];
    return [base stringByAppendingString:part];
}
-(NSString *)part_validate{
    NSString *bind=[[[self URLDictionary] objectForKey:@"part"] objectForKey:@"validate"];
    return [[self part_index] stringByAppendingString:bind];
}
-(NSString *)part_quantity_validate
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"validate_quantity"];
    return [[self xiang_index] stringByAppendingString:bind];
}
//resource xiang
-(NSString *)xiang_index
{
    NSString *base=[self baseURL];
    NSString *xiang=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"root"];
    return [base stringByAppendingString:xiang];
}
-(NSString *)xiang_root
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"index"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_validate
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"validate"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_check
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"check"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_uncheck{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"uncheck"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_send
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"send"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_receive
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"receive"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_reject
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"reject"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_received
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"received"];
    return [[self xiang_index] stringByAppendingString:bind];
}
-(NSString *)xiang_edit:(NSString *)id{
    NSString *xiangRoot=[self xiang_index];
    return [NSString stringWithFormat:@"%@%@",xiangRoot,id];
}
-(NSString *)xiang_confirm_receive
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"xiang"] objectForKey:@"confirm_receive"];
    return [[self xiang_index] stringByAppendingString:bind];
}
//resource Tuo
-(NSString *)tuo_index
{
    NSString *base=[self baseURL];
    NSString *tuo=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"root"];
    return [base stringByAppendingString:tuo];
}
-(NSString *)tuo_root
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"index"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_single
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"single"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_packages{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"packages"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_bundle_add
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"bundle_add"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_key_for_bundle{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"key_for_bundle"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_remove_xiang{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"remove_xiang"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_received
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"received"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_confirm_receive
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"confirm_receive"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_receive{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"receive"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_send
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"tuo"] objectForKey:@"send"];
    return [[self tuo_index] stringByAppendingString:bind];
}
-(NSString *)tuo_edit:(NSString *)id{
    NSString *tuoRoot=[self tuo_root];
    return [NSString stringWithFormat:@"%@%@",tuoRoot,id];
}

//resource Yun
-(NSString *)yun_index
{
    NSString *base=[self baseURL];
    NSString *yun=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"root"];
    return [base stringByAppendingString:yun];
}
-(NSString *)yun_root
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"index"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_single
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"single"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_add_tuo_by_scan{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"add_tuo_by_scan"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_remove_tuo{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"remove_tuo"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_add_tuo{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"add_tuo"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_send{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"send"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_folklifts{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"forklifts"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_edit:(NSString *)id{
    NSString *yunRoot=[self yun_root];
    return [NSString stringWithFormat:@"%@%@",yunRoot,id];
}
-(NSString *)yun_receive
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"receive"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_confirm_receive
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"confirm_receive"];
    return [[self yun_index] stringByAppendingString:bind];
}
-(NSString *)yun_received
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"yun"] objectForKey:@"received"];
    return [[self yun_index] stringByAppendingString:bind];
}
//库
-(NSString *)storages_index
{
    NSString *base=[self baseURL];
    NSString *storages=[[[self URLDictionary] objectForKey:@"storages"] objectForKey:@"index"];
    return [base stringByAppendingString:storages];
}
-(NSString *)storages_move_store
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"storages"] objectForKey:@"move_store"];
    return [[self storages_index] stringByAppendingString:bind];
}
//打印
-(NSString *)baseURL_print
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.ip.address.archive"];
    NSString *file=[[[self URLDictionary] objectForKey:@"print"] objectForKey:@"file"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSString *base=[dictionary objectForKey:@"print_ip"];
        NSString *port=[dictionary objectForKey:@"print_port"];
        return [[base stringByAppendingString:port] stringByAppendingString:file];
    }
    else{
        NSString *base=[[[self URLDictionary] objectForKey:@"print"] objectForKey:@"base"];
        NSString *port=[[[self URLDictionary] objectForKey:@"print"] objectForKey:@"port"];
        return [[base stringByAppendingString:port] stringByAppendingString:file];
    }
}

-(NSString *)print_model_list
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.ip.address.archive"];
    NSString *list=[[[self URLDictionary] objectForKey:@"print"] objectForKey:@"model"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSString *base=[dictionary objectForKey:@"print_ip"];
        NSString *port=[dictionary objectForKey:@"print_port"];
        return [[base stringByAppendingString:port] stringByAppendingString:list];
    }
    else{
        NSString *base=[[[self URLDictionary] objectForKey:@"print"] objectForKey:@"base"];
        NSString *port=[[[self URLDictionary] objectForKey:@"print"] objectForKey:@"port"];
        return [[base stringByAppendingString:port] stringByAppendingString:list];
    }
}

-(NSString *)get_current_print_model
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.ip.address.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return [dictionary objectForKey:@"print_model"]?[dictionary objectForKey:@"print_model"]:@"";
    }
    else{
        return @"";
    }
}
-(void)set_tuo_copy:(NSString *)copy
{
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:copy,@"tuo_copy",nil];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.copy.tuo.archive"];
    [NSKeyedArchiver archiveRootObject:dictionary toFile:path];
}
-(void)set_yun_copy:(NSString *)copy
{
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:copy,@"yun_copy",nil];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.copy.yun.archive"];
    [NSKeyedArchiver archiveRootObject:dictionary toFile:path];
}
-(void)set_yun_uncheck_copy:(NSString *)copy
{
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:copy,@"yun_uncheck_copy",nil];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.copy.yun.uncheck.archive"];
    [NSKeyedArchiver archiveRootObject:dictionary toFile:path];
}
-(void)set_transfer_note_copy:(NSString *)copy
{
    NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:copy,@"transfer_note_copy",nil];
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.copy.transfer.note.archive"];
    [NSKeyedArchiver archiveRootObject:dictionary toFile:path];
}
-(NSString *)get_tuo_copy
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.copy.tuo.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return [dictionary objectForKey:@"tuo_copy"]?[dictionary objectForKey:@"tuo_copy"]:@"1";
    }
    else{
        return @"1";
    }
}
-(NSString *)get_yun_copy
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.copy.yun.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return [dictionary objectForKey:@"yun_copy"]?[dictionary objectForKey:@"yun_copy"]:@"1";
    }
    else{
        return @"1";
    }
}
-(NSString *)get_yun_uncheck_copy
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.copy.yun.uncheck.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return [dictionary objectForKey:@"yun_uncheck_copy"]?[dictionary objectForKey:@"yun_uncheck_copy"]:@"1";
    }
    else{
        return @"1";
    }
}
-(NSString *)get_transfer_note_copy
{
    NSArray *documentDictionary=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document=[documentDictionary firstObject];
    NSString *path=[document stringByAppendingPathComponent:@"print.copy.transfer.note.archive"];
    if([NSKeyedUnarchiver unarchiveObjectWithFile:path]){
        NSDictionary *dictionary=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return [dictionary objectForKey:@"transfer_note_copy"]?[dictionary objectForKey:@"transfer_note_copy"]:@"1";
    }
    else{
        return @"1";
    }
}
-(NSString *)base_for_print:(NSString *)key
{
    NSDictionary *printDictionary=[[self URLDictionary] objectForKey:@"print"];
    NSString *base=[self baseURL_print];
    NSString *bind=[printDictionary objectForKey:key];
    return [base stringByAppendingString:bind];
}
-(NSString *)print_stock_xiang:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies
{
    NSString *joint=[self base_for_print:@"stock_xiang"];
    NSString *after=[NSString string];
    if(copies.length>0){
        after=[[ID stringByAppendingPathComponent:printer] stringByAppendingPathComponent:copies];
    }
    else{
        after=[ID stringByAppendingPathComponent:printer];
    }
    return [NSString stringWithFormat:@"%@%@",joint,after];
}
-(NSString *)print_stock_tuo:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies
{
    NSString *joint=[self base_for_print:@"stock_tuo"];
    NSString *after=[NSString string];
    if(copies.length>0){
        after=[[ID stringByAppendingPathComponent:printer] stringByAppendingPathComponent:copies];
    }
    else{
        after=[ID stringByAppendingPathComponent:printer];
    }
    return [NSString stringWithFormat:@"%@%@",joint,after];
}
-(NSString *)print_stock_yun:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies
{
    NSString *joint=[self base_for_print:@"stock_yun"];
    NSString *after=[NSString string];
    if(copies.length>0){
        after=[[ID stringByAppendingPathComponent:printer] stringByAppendingPathComponent:copies];
    }
    else{
        after=[ID stringByAppendingPathComponent:printer];
    }
    return [NSString stringWithFormat:@"%@%@",joint,after];
}

-(NSString *)print_shop_yun_receive:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies
{
    NSString *joint=[self base_for_print:@"shop_yun_receive"];
    NSString *after=[NSString string];
    if(copies.length>0){
        after=[[ID stringByAppendingPathComponent:printer] stringByAppendingPathComponent:copies];
    }
    else{
        after=[ID stringByAppendingPathComponent:printer];
    }
    return [NSString stringWithFormat:@"%@%@",joint,after];
}
-(NSString *)print_shop_yun_unreceive:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies
{
    NSString *joint=[self base_for_print:@"shop_yun_unreceive"];
    NSString *after=[NSString string];
    if(copies.length>0){
        after=[[ID stringByAppendingPathComponent:printer] stringByAppendingPathComponent:copies];
    }
    else{
        after=[ID stringByAppendingPathComponent:printer];
    }
    return [NSString stringWithFormat:@"%@%@",joint,after];
}
-(NSString *)print_shop_xiang_receive:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies
{
    NSString *joint=[self base_for_print:@"shop_xiang_receive"];
    NSString *after=[NSString string];
    if(copies.length>0){
        after=[[ID stringByAppendingPathComponent:printer] stringByAppendingPathComponent:copies];
    }
    else{
        after=[ID stringByAppendingPathComponent:printer];
    }
    return [NSString stringWithFormat:@"%@%@",joint,after];
}
-(NSString *)print_shop_xiang_unreceive:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies
{
    NSString *joint=[self base_for_print:@"shop_xiang_unreceive"];
    NSString *after=[NSString string];
    if(copies.length>0){
        after=[[ID stringByAppendingPathComponent:printer] stringByAppendingPathComponent:copies];
    }
    else{
        after=[ID stringByAppendingPathComponent:printer];
    }
    return [NSString stringWithFormat:@"%@%@",joint,after];
}
-(NSString *)print_shop_tuo_receive:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies
{
    NSString *joint=[self base_for_print:@"shop_tuo_receive"];
    NSString *after=[NSString string];
    if(copies.length>0){
        after=[[ID stringByAppendingPathComponent:printer] stringByAppendingPathComponent:copies];
    }
    else{
        after=[ID stringByAppendingPathComponent:printer];
    }
    return [NSString stringWithFormat:@"%@%@",joint,after];
}
-(NSString *)print_shop_tuo_unreceive:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies
{
    NSString *joint=[self base_for_print:@"shop_tuo_unreceive"];
    NSString *after=[NSString string];
    if(copies.length>0){
        after=[[ID stringByAppendingPathComponent:printer] stringByAppendingPathComponent:copies];
    }
    else{
        after=[ID stringByAppendingPathComponent:printer];
    }
    return [NSString stringWithFormat:@"%@%@",joint,after];
}
-(NSString *)print_transfer_note:(NSString *)ID printer_name:(NSString *)printer copies:(NSString *)copies
{
    NSString *joint=[self base_for_print:@"transfer_note"];
    NSString *after=[NSString string];
    if(copies.length>0){
        after=[[ID stringByAppendingPathComponent:printer] stringByAppendingPathComponent:copies];
    }
    else{
        after=[ID stringByAppendingPathComponent:printer];
    }
    return [NSString stringWithFormat:@"%@%@",joint,after];
}
//login and logout
-(NSString *)log_in
{
    NSString *base=[self baseURL];
    return [base stringByAppendingString:[[self URLDictionary] objectForKey:@"log_in"]];
}
-(NSString *)log_out
{
    NSString *base=[self baseURL];
    return [base stringByAppendingString:[[self URLDictionary] objectForKey:@"log_out"]];
}
//version
-(NSString *)version
{
    NSString *base=[self baseURL];
    return [base stringByAppendingString:[[self URLDictionary] objectForKey:@"version"]];
}
#pragma validate
-(NSString *)scan_validate{
    NSString *base=[self baseURL];
    return [base stringByAppendingString:[[self URLDictionary] objectForKey:@"scan_validate"]];
}
//order
-(NSString *)order_root
{
    NSString *base=[self baseURL];
    NSString *order=[[[self URLDictionary] objectForKey:@"orders"] objectForKey:@"root"];
    return [base stringByAppendingString:order];
}
-(NSString *)order_history
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"orders"] objectForKey:@"history"];
    return [[self order_root] stringByAppendingString:bind];
}
-(NSString *)order_check_part
{
    NSString *bind=[[[self URLDictionary] objectForKey:@"orders"] objectForKey:@"check_part"];
    return [[self order_root] stringByAppendingString:bind];
}
//order item
-(NSString *)order_item_root{
    NSString *base=[self baseURL];
    NSString *order_item=[[[self URLDictionary] objectForKey:@"order_item"] objectForKey:@"root"];
    return [base stringByAppendingString:order_item];
}
-(NSString *)order_item_verify{
    NSString *bind=[[[self URLDictionary] objectForKey:@"order_item"] objectForKey:@"verify"];
    return [[self order_item_root] stringByAppendingString:bind];
}
//control led state
-(NSString *)order_led_root{
    NSString *base=[self baseURL];
    NSString *order_led=[[[self URLDictionary] objectForKey:@"order_led"] objectForKey:@"root"];
    return [base stringByAppendingString:order_led];
}
-(NSString *)order_led_reset{
    NSString *bind=[[[self URLDictionary] objectForKey:@"order_led"] objectForKey:@"reset"];
    return [[self order_led_root] stringByAppendingString:bind];
}
-(NSString *)order_led_position_state{
    NSString *bind=[[[self URLDictionary] objectForKey:@"order_led"] objectForKey:@"position_state"];
    return [[self order_led_root] stringByAppendingString:bind];
}
-(NSString *)order_led_state_list{
    NSString *bind=[[[self URLDictionary] objectForKey:@"order_led"] objectForKey:@"state_list"];
    return [[self order_led_root] stringByAppendingString:bind];
}
-(NSString *)send_address{
    NSString *base=[self baseURL];
    NSString *send_address=[[self URLDictionary] objectForKey:@"send_address"];
    return [base stringByAppendingString:send_address];
}
-(NSString *)movables{
    NSString *base=[self baseURL];
    NSString *send_address=[[self URLDictionary] objectForKey:@"movables"];
    return [base stringByAppendingString:send_address];
}
-(NSString *)locations_warehosues{
    NSString *base=[self baseURL];
    NSString *locations_warehosues=[[self URLDictionary] objectForKey:@"locations_warehosues"];
    return [base stringByAppendingString:locations_warehosues];
}

-(NSString *)inventory_processing{
    NSString *base = [ self baseURL];
    NSString *inventory_processing = [[self URLDictionary] objectForKey:@"inventory_processing"];
    return [base stringByAppendingString:inventory_processing];
                                    
}

-(NSString *)check_stock
{
    NSString *base = [self baseURL];
    NSString *_check_stock = [[self URLDictionary] objectForKey:@"check_stock"];
    return [base stringByAppendingString:_check_stock];
}

-(NSString *)inventory_list_item
{
    NSString *base = [self baseURL];
    NSString *_inventory_list_item = [[self URLDictionary] objectForKey:@"inventory_list_item"];
    return [base stringByAppendingString: _inventory_list_item];
}

/*
 *
 * url：/v3/whouse/move
 */
- (NSString *)move
{
    NSString *base = [self baseURL];
    NSString *moveString = [[self URLDictionary] objectForKey:@"move"];
    return [base stringByAppendingString: moveString];
}


/*
 url: /v1/parts/get_positions
 */
- (NSString *)get_positions
{
    NSString *base = [self baseURL];
    NSString *get_positionsString = [[self URLDictionary] objectForKey: @"get_positions"];
    return [base stringByAppendingString: get_positionsString];
}


@end

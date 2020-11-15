//
//  MoreTableHook.m
//  WeHook
//
//  Created by winnie on 2020/11/16.
//

#import "MoreTableHook.h"
#import <objc/runtime.h>

@implementation MoreTableHook

+ (void)load
{
    NSLog(@"hook load");
    Class origin_class  = NSClassFromString(@"MoreTableViewController");
    Class swizzed_class = [self class];
    
    SEL origin_selector = NSSelectorFromString(@"numberOfSectionsInTableView:");
    SEL swizzed_selector = NSSelectorFromString(@"new_numberOfSectionsInTableView:");
    
    Method origin_method = class_getInstanceMethod(origin_class, origin_selector);
    Method swizzed_method = class_getInstanceMethod(swizzed_class, swizzed_selector);
    
    BOOL add_method = class_addMethod(origin_class,
                                      swizzed_selector,
                                      method_getImplementation(swizzed_method),
                                      method_getTypeEncoding(swizzed_method));
    if (!add_method) {
        return;
    }
    
    swizzed_method = class_getInstanceMethod(origin_class, swizzed_selector);
    if (!swizzed_method) {
        return;
    }
    
    BOOL did_add_method = class_addMethod(origin_class,
                                          origin_selector,
                                          method_getImplementation(swizzed_method),
                                          method_getTypeEncoding(swizzed_method));
    if (did_add_method) {
        class_replaceMethod(origin_class,
                            swizzed_selector,
                            method_getImplementation(origin_method),
                            method_getTypeEncoding(origin_method));
    }else{
        method_exchangeImplementations(origin_method, swizzed_method);
    }
}

- (long long)numberOfSectionsInTableView:(id)arg1;
{
    [self numberOfSectionsInTableView:arg1];
    return 1;
}

@end


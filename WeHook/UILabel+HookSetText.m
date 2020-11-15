//
//  UILabel+HookSetText.m
//  WeHook
//
//  Created by winnie on 2020/11/16.
//

#import "UILabel+HookSetText.h"
#import <objc/runtime.h>

@implementation UILabel (HookSetText)

+ (void)load
{
    Class clazz = [self class];
    
    SEL setTextSelector = @selector(setText:);
    SEL new_setTextSelector = @selector(new_setText:);
    
    Method setTextMethod = class_getInstanceMethod(clazz, setTextSelector);
    Method new_setTextMethod = class_getInstanceMethod(clazz, new_setTextSelector);
    
    BOOL did_add_method = class_addMethod(clazz,
                                          setTextSelector,
                                          method_getImplementation(new_setTextMethod),
                                          method_getTypeEncoding(new_setTextMethod));
    if (did_add_method) {
        class_replaceMethod(clazz,
                            new_setTextSelector,
                            method_getImplementation(setTextMethod),
                            method_getTypeEncoding(setTextMethod));
    }else{
        method_exchangeImplementations(setTextMethod, new_setTextMethod);
    }
    
}

- (void)new_setText:(NSString *)text
{
    if ([text isEqualToString:@"微信"]) {
        [self new_setText:@"new_微信"];
    }else {
        [self new_setText:text];
    }
    
}

@end

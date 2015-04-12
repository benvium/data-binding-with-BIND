@import UIKit;
#import <Foundation/Foundation.h>

static NSString *const BNDBindingEditingChangedKeyPath = @"onEditingChanged";

@interface UITextField (BNDBinding)
@property (nonatomic) NSString *onEditingChanged;
@end
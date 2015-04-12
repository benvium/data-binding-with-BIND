#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ViewModelItem;

@interface ViewModel : NSObject
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, strong) ViewModelItem *selected;
@property(nonatomic) NSUInteger selectedIndex;

- (instancetype)initWithItems:(NSArray *)items;

- (NSArray *)list;
@end

@interface ViewModelItem : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *value;
@property(nonatomic, copy) NSString *listValue;

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value listValue:(NSString *)listValue;

- (NSString *)description;

@end
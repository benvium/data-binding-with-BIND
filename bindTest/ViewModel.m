#import "ViewModel.h"

@implementation ViewModel {

}
- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.items = items;
    }

    return self;
}

- (NSArray*) list {
    return @[@"a", @"b", @"c", @"d", @"e"];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    NSLog(@"sel index = %@", @(selectedIndex) );
    if (selectedIndex >= self.items.count) {
        return;
    }
    _selectedIndex = selectedIndex;

    self.selected = self.items[selectedIndex];
}
@end

@implementation ViewModelItem
- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value listValue:(NSString *)listValue {
    self = [super init];
    if (self) {
        self.title = title;
        self.value = value;
        self.listValue = listValue;
    }

    return self;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.title=%@", self.title];
    [description appendFormat:@", self.value=%@", self.value];
    [description appendString:@">"];
    return description;
}

@end
#import "ViewController.h"
#import "View+MASAdditions.h"
#import "ViewModel.h"
#import "BNDMacros.h"
#import "BNDBinding.h"
#import "Underscore.h"
#import "UITextField+BNDBinding.h"
#import "UITextField+BlocksKit.h"
#import "UIGestureRecognizer+BlocksKit.h"
#import "UIControl+BlocksKit.h"
#import "ActionSheetStringPicker.h"

@interface ViewController ()

@property(nonatomic, strong) ViewModel *model;
@property(nonatomic, strong) UITextField *list;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // VIEWS
    ////////////////////////////////////////////////////////////////////////

    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] init];
    [self.view addSubview:segmentedControl];

    UILabel *title = [UILabel new];
    title.text = @"empty title";
    [self.view addSubview:title];

    UITextField *field = [[UITextField alloc] init];
    field.borderStyle = UITextBorderStyleLine;
    field.text = @"empty field";
    field.bk_shouldReturnBlock = ^BOOL (UITextField *field) {
        [field resignFirstResponder];
        return NO;
    };
    [self.view addSubview:field];

    self.list = [UITextField new];
    self.list.borderStyle = UITextBorderStyleLine;
    self.list.text = @"empty field 2";

    // Disable Editing. http://stackoverflow.com/questions/3275103/set-uitextfield-as-non-editable-objective-c
    __weak typeof(self) weakSelf = self;
    self.list.bk_shouldBeginEditingBlock = ^BOOL (UITextField *field) {
        [weakSelf picker];
        return NO;
    };

    [self.view addSubview:self.list];

    // CONSTRAINTS
    ////////////////////////////////////////////////////////////////////////
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.view).offset(36);
    }];

    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(segmentedControl);
        make.top.equalTo(segmentedControl.mas_bottom).offset(16);
        make.height.equalTo(@40);
    }];

    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(segmentedControl);
        make.top.equalTo(title.mas_bottom).offset(16);
    }];

    [self.list mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(segmentedControl);
        make.top.equalTo(field.mas_bottom).offset(16);
    }];

    // BEHAVIOR
    ////////////////////////////////////////////////////////////////////////

    self.model = [[ViewModel alloc] initWithItems:@[
            [[ViewModelItem alloc] initWithTitle:@"one" value:@"fish" listValue:@"a"],
            [[ViewModelItem alloc] initWithTitle:@"two" value:@"trousers" listValue:@"b"],
            [[ViewModelItem alloc] initWithTitle:@"three" value:@"badger" listValue:@"c"]
    ]];

    __block int i = 0;
    Underscore.arrayEach(self.model.items, ^(ViewModelItem *obj) {
        [segmentedControl insertSegmentWithTitle:obj.title
                                         atIndex:i++
                                        animated:NO];
    });
    segmentedControl.selectedSegmentIndex = 0;

    NSMutableArray *itemBindings = [NSMutableArray new];

    // DATA BINDINGS
    ////////////////////////////////////////////////////////////////////////

    // re-bind when selected item is changed, sadly KVO doesn't work with
    // sub-properties when the parent is changed.
    [BINDO(self.model, selected) observe:^(id observable, ViewModelItem *item) {
        NSLog(@"%@ %@", observable, item);

        // Unbind old ones..
        Underscore.arrayEach(itemBindings, ^(BNDBinding *obj) {
            [obj unbind];
        });

        // Bind and remember so we can unbind later..
        [itemBindings addObjectsFromArray:@[

                // item title bind (one way)
                BIND(item, title, ->, title, text),

                // item value bind (one way)
                BIND(item, value, ->, field, text),

                // update value while typing
                BIND(field, onEditingChanged, ->, item, value),

                // list value bind (bidirectional)
                BIND(item, listValue, <>, self.list, text)
        ]];
    }];

    // segmented control written to model.selectedIndex
    // This is AFTER the above bindings as we need them to be ready to receive
    // the initial value
    BIND(segmentedControl, selectedSegmentIndex, ->, self.model, selectedIndex);
}

- (void)picker {
    int initialSelection = [self.model.list indexOfObject:self.list.text];
    ActionSheetStringPicker *stringPicker =
            [[ActionSheetStringPicker alloc]
                    initWithTitle:nil
                             rows:self.model.list
                 initialSelection:initialSelection
                        doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                            self.list.text = selectedValue;
                        }

                      cancelBlock:^(ActionSheetStringPicker *picker) {
                          NSLog(@"Block Picker Canceled");
                      }
                           origin:self.list];

    stringPicker.tapDismissAction = TapActionSuccess;
    [stringPicker showActionSheetPicker];
}

@end
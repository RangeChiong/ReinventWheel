//
//  RWPickerView.m
//  Test0606
//
//  Created by Ranger on 16/6/6.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "RWPickerView.h"

// 主色调
#define Dominant_Color  [UIColor redColor]

@interface RWPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *_dataSource;
    BOOL _isMutiComponent;
    NSInteger _lastRow;
    void (^_selectInfoBlock)(NSString *, NSInteger);
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *marker;  //!< 竖线
@property (nonatomic, strong) UIView *split;   //!< 分割线（横线）

@end

@implementation RWPickerView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource {
    NSParameterAssert(dataSource.count > 0);
    if (self = [super init]) {
        self.frame = frame;
        _dataSource = dataSource;
        [self initialize];
    }
    return self;
}

- (void)initialize {
//    self.backgroundColor = [UIColor orangeColor];
    if (_dataSource.count > 0) {
        if ([_dataSource[0] isKindOfClass:[NSArray class]]) {
            _isMutiComponent = YES;
            [self createSplitWithComponent:_dataSource.count];
        }
        else
            _isMutiComponent = NO;
        
        [self addSubview:self.marker];
        [self addSubview:self.pickerView];
    }
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self initialize];
}

- (void)selectedInfo:(void (^)(NSString *, NSInteger))block {
    _selectInfoBlock = block;
}

#pragma mark-  UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _isMutiComponent ? _dataSource.count : 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _isMutiComponent ? [_dataSource[component] count] : _dataSource.count;
}

#pragma mark-  UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment =  NSTextAlignmentCenter;
    [self setLabelTextColor:&label row:row component:component];
    
    if (_isMutiComponent) {
        if ([_dataSource[component] count] > 0)
            label.text = _dataSource[component][row];
        else
            label.text = @"";
    }
    else
        label.text = _dataSource[row];
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _lastRow = row;
    [pickerView reloadComponent:component];
    
    if (_selectInfoBlock)
        _selectInfoBlock(_isMutiComponent ? _dataSource[component][row] : _dataSource[row], component);
}

#pragma mark-  set label text color

- (void)setLabelTextColor:(UILabel **)label row:(NSInteger)row component:(NSInteger)component {
    UILabel *lbl = *label;
    
    // _lastRow default is 0
    if (_lastRow == row)
        lbl.textColor = Dominant_Color;
    else
        lbl.textColor = [UIColor blackColor];
}

- (void)createSplitWithComponent:(NSInteger)count {
    if (count < 2) return;
    if (count == 2) {
        UIView *split = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width-6) / 2,
                                                                 (self.bounds.size.height-2) / 2,
                                                                 6,
                                                                 2)];
        split.backgroundColor = Dominant_Color;
        [self addSubview:split];
    }else if (count > 2) {
        for (int i = 1; i < count; i ++) {
            UIView *split = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width-6) * i / count,
                                                                     (self.bounds.size.height-2) / 2,
                                                                     6,
                                                                     2)];
            split.backgroundColor = Dominant_Color;
            [self addSubview:split];
        }
    }
}

#pragma mark-   Setter & Getter

- (UIPickerView *)pickerView {
    if (_pickerView)
        return _pickerView;
    
    _pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    return _pickerView;
}

- (UIView *)marker {
    if (_marker)
        return _marker;
    
    _marker = [[UIView alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height-30) / 2, 4, 30)];
    _marker.backgroundColor = Dominant_Color;
    return _marker;
}

@end

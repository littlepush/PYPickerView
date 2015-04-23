//
//  PYPickerView.h
//  PYPickerView
//
//  Created by Push Chen on 4/20/15.
//  Copyright (c) 2015 Push Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PYPickerView;

@protocol PYPickerViewDelegate <UIPickerViewDelegate>

@optional
- (NSAttributedString *)pickerView:(PYPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component
                         forStatus:(UIControlState)state;

- (UIView *)pickerView:(PYPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
             forStatus:(UIControlState)state;

@end

@interface PYPickerView : UIPickerView

@property (nonatomic, assign)   id<PYPickerViewDelegate>    delegate;

@property (nonatomic, strong)   UIColor *highlightBarColor;
@property (nonatomic, assign)   BOOL isShowAssistLine;

@end

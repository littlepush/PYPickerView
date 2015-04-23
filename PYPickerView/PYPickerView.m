//
//  PYPickerView.m
//  PYPickerView
//
//  Created by Push Chen on 4/20/15.
//  Copyright (c) 2015 Push Chen. All rights reserved.
//

#import "PYPickerView.h"

// Just the container
@interface PYPickerViewCell : UIView
@end
@implementation PYPickerViewCell @end

@interface PYPickerView ()  <UIPickerViewDelegate>
{
    id<PYPickerViewDelegate>    _externalDelegate;
    NSMutableArray              *_highlightTables;
    UIView                      *_highlightBackgroundView;
}

@end

@implementation PYPickerView

- (void)_internalInit
{
    [super setDelegate:self];
    _highlightTables = [NSMutableArray array];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self _internalInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self _internalInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if ( self ) {
        [self _internalInit];
    }
    return self;
}

@dynamic delegate;
- (void)setDelegate:(id<PYPickerViewDelegate>)delegate
{
    _externalDelegate = delegate;
}
- (id<PYPickerViewDelegate>)delegate
{
    return _externalDelegate;
}

- (UITableView *)_searchTheLastTableView:(UIView *)view
{
    for ( NSUInteger i = view.subviews.count; i > 0; --i ) {
        UIView *_sv = view.subviews[i - 1];
        if ( [_sv isKindOfClass:[UITableView class]] ) return (UITableView *)_sv;
        UITableView *_tv = [self _searchTheLastTableView:_sv];
        if ( _tv != nil ) return _tv;
    }
    return nil;
}

- (PYPickerViewCell *)_searchForViewContainer:(UIView *)view
{
    for ( UIView *_v in view.subviews ) {
        if ( [_v isKindOfClass:[PYPickerViewCell class]] ) return (PYPickerViewCell *)_v;
        PYPickerViewCell *_c = [self _searchForViewContainer:_v];
        if ( _c != nil ) return _c;
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_highlightTables removeAllObjects];
    
    // For each UIPickerColumnView
    for ( UIView *_sv in ((UIView *)[self.subviews objectAtIndex:0]).subviews ) {
        for ( UIView *_csv in _sv.subviews ) {
            //[_csv setBackgroundColor:[UIColor clearColor]];
            if ( _csv.frame.origin.y != 0 &&
                (fabs(_csv.frame.origin.y + _csv.frame.size.height - self.frame.size.height) > 0.001) )
            {
                UITableView *_tvWeNeed = [self _searchTheLastTableView:_csv];
                if ( _tvWeNeed == nil ) continue;
                [_highlightTables addObject:_tvWeNeed];
            }
        }
    }
    
    // Hide Assist Line
    if ( self.isShowAssistLine == NO ) {
        for ( UIView *_sv in self.subviews ) {
            if ( _sv.frame.size.height <= 1 ) {
                [_sv setBackgroundColor:[UIColor clearColor]];
            }
        }
    }
    
    // Only the first table's super view should set the background
    UITableView *_firstTVN = [_highlightTables objectAtIndex:0];
    if ( _firstTVN != nil ) _highlightBackgroundView = _firstTVN.superview;
    if ( _firstTVN != nil && self.highlightBarColor != nil ) {
        [_highlightBackgroundView setBackgroundColor:self.highlightBarColor];
    }
    
    // Modify the initialized highlight cells
    NSInteger _component = 0;
    for ( UITableView *_atv in _highlightTables ) {
        NSArray *_displayedCell = [_atv visibleCells];
        for ( UITableViewCell *_cell in _displayedCell ) {
            NSIndexPath *_index = [_atv indexPathForCell:_cell];
            PYPickerViewCell *_ctnt = [self _searchForViewContainer:_cell];
            if ( _ctnt != nil ) {
                if ( [_externalDelegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:forStatus:)] ) {
                    UIView *_highlightView =
                    [_externalDelegate
                     pickerView:self
                     viewForRow:_index.row
                     forComponent:_component
                     reusingView:_ctnt.subviews[0]
                     forStatus:UIControlStateHighlighted];
                }
            }
        }
        _component += 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end

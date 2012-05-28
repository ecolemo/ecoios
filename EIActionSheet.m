//
//  EIActionSheet.m
//  chattingvil-ios
//
//  Created by Pak Youngrok on 12. 5. 28..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import "EIActionSheet.h"

@implementation EIActionSheet

- (id)initWithTitle:(NSString*)title {
    NSLog(@"init");
    _title = [title retain];
    otherButtonTitles = [[NSMutableArray alloc] init];
    otherBlocks = [[NSMutableDictionary alloc] init];
    NSLog(@"init %@", otherBlocks);
    return self;
}

- (void)addCancelButtonTitle:(NSString*)title block:(void (^)(void))block {
    cancelButtonTitle = [title retain];
    cancelBlock = Block_copy(block);
}

- (void)addDestructiveButtonTitle:(NSString*)title block:(void (^)(void))block {
    destructiveButtonTitle = [title retain];
    destructiveBlock = Block_copy(block);
}

- (void)addOtherButtonTitle:(NSString*)title block:(void (^)(void))block {
    [otherButtonTitles addObject: [title retain]];
    
    [otherBlocks setObject:block forKey:title];
    NSLog(@"%@ %@", title, otherBlocks);
}

- (void)showFromBarButtonItem:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:_title delegate:self cancelButtonTitle:nil destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    
    for (NSString* title in otherButtonTitles) {
        [actionSheet addButtonWithTitle:title];
    }
    if (cancelButtonTitle) {
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:cancelButtonTitle];
    }
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        destructiveBlock();
    } else if (buttonIndex == actionSheet.cancelButtonIndex) {
        cancelBlock();
    } else {
        void (^block)(void) = [otherBlocks objectForKey:[actionSheet buttonTitleAtIndex:buttonIndex]];
        block();
    }
}
@end

//
//  EIActionSheet.h
//  chattingvil-ios
//
//  Created by Pak Youngrok on 12. 5. 28..
//  Copyright (c) 2012년 ecolemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EIActionSheet : NSObject <UIActionSheetDelegate> {
    NSString* _title;

    NSString* cancelButtonTitle;
    NSString* destructiveButtonTitle;
    NSMutableArray* otherButtonTitles;
    
    void (^cancelBlock)(void);
    void (^destructiveBlock)(void);
    NSMutableDictionary* otherBlocks;
}

- (id)initWithTitle:(NSString*)title;
- (void)addCancelButtonTitle:(NSString*)title block:(void (^)(void))block;
- (void)addDestructiveButtonTitle:(NSString*)title block:(void (^)(void))block;
- (void)addOtherButtonTitle:(NSString*)title block:(void (^)(void))block;
- (void)showFromBarButtonItem:(id)sender;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

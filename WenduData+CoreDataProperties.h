//
//  WenduData+CoreDataProperties.h
//  TiwenJi
//
//  Created by 莫福见 on 16/3/9.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WenduData.h"

NS_ASSUME_NONNULL_BEGIN

@interface WenduData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *sex;
@property (nullable, nonatomic, retain) NSString *age;
@property (nullable, nonatomic, retain) NSString *weiht;
@property (nullable, nonatomic, retain) NSString *height;
@property (nullable, nonatomic, retain) NSData *iconImage;

@end

NS_ASSUME_NONNULL_END

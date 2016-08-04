//
//  Test+CoreDataProperties.h
//  TiwenJi
//
//  Created by 莫福见 on 16/3/9.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Test.h"

NS_ASSUME_NONNULL_BEGIN

@interface Test (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *shijian;
@property (nullable, nonatomic, retain) NSString *wendu;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END

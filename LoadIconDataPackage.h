//
//  LoadIconDataPackage.h
//  PackingCheckList
//
//  Created by Mobili Studio Station 2 on 2010/6/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoadIconDataPackage : NSObject {

	NSString *m_Name;
	int m_Quantity;
}

@property (nonatomic, retain) NSString *m_Name;
@property int m_Quantity;

@end

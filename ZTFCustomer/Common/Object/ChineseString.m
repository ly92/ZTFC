#import "ChineseString.h"
#import "pinyin.h"

@implementation ChineseString

@def_singleton(ChineseString)

@synthesize string = _string;
@synthesize pinYin = _pinYin;
@synthesize data = _data;


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
    }
    return self;
}

+ (NSMutableArray *)getChineseStringArr:(NSArray *)arrToSort
{
   return [[self sharedInstance] getChineseStringArr:arrToSort];
}

- (NSMutableArray *)getChineseStringArr:(NSArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        RegionModel *city = [arrToSort objectAtIndex:i];

		if ( nil == city.name || 0 == city.name.length )
			continue;
			
        ChineseString *chineseString=[[ChineseString alloc] init];
        chineseString.string = [NSString stringWithString:city.name];
        chineseString.pinYin = city.key;
        chineseString.data = city;
        //if(chineseString.string==nil){
           // chineseString.string=@"";
        //}
        
        if(![chineseString.string isEqualToString:@""]){
            //NSString *pinYinResult = [NSString string];
            //for(int j = 0;j < chineseString.string.length; j++) {
                //NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                             //   pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
               // pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            //}
            //chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = [NSMutableArray array];
    NSMutableArray *sectionHeadsKeys = [NSMutableArray array];
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        if(![sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                
                checkValueAtIndex = YES;
            }
        }
    }
    [arrayForArrays addObject:sectionHeadsKeys];
    
    return arrayForArrays;
}

@end

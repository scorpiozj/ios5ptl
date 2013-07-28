---
layout: post
title: iOS JSON Object Model
---

{{ page.title }}
================

<p class="meta">22 Nov 2011 </p>
It does *not* talk about either how to parsering the json into object or comparing the speed of the parser kit here.
I want to cover something about the JSON Object Model. In mobile apps, JSON is used popular. Before reading ios ptl, I always create the property in advance and sythesize them.
when comes comlicate json structure, as you can imagine,there will be such a lot of synthesize. For example:

    @interface ZJNodeObj : NSObject
    @property (nonatomic, strong) NSString *filedate, *filefolderflag, *filename, *filepath,*filesize, *opedate,*operation,*opesrc,*opeuser;
    @property (nonatomic, strong) NSNumber *no;
    - (void)setContentWith:(NSDictionary *)dic;
    @end
    
    @implementation ZJNodeObj
    @synthesize filedate,filefolderflag,filename,filepath,filesize,opedate,operation,opesrc,opeuser;
    @synthesize no;
    - (void)setContentWith:(NSDictionary*)dic
    {
        NSEnumerator *enumerator = [dic keyEnumerator];
        NSString *key = nil;
        while (key = [enumerator nextObject])
        {
            NSLog(@"%@",key);
            [self setValue:[dic valueForKey:key] forKey:key];
        }
    }
    @end

As json is a kind of key-value style text, we can model the text use setValue:forKey:.
The only thing, first of all, is to set the property in your class. 
Note usually the property name is exactly the same as that in the json except that the property is the key word reserved by obj-c.
If the property is, for example, "id", we can detect it in the *while* case:
    if([key isEqualToString:@"id"])
    {
        //blah blah...
        [self setValue:[dic valueForKey:key] forKey:@"itemid"];
    }

As a result, the nested json object can also be hanled in this way.
    if([key isEqualToString:@"reviews"])
    {
        //blah blah...
    }

Let take a look how it does in PTL:
    //Base class
    -(id) initWithDictionary:(NSMutableDictionary*) jsonObject
    {
        if((self = [super init]))
        {
            [self setValuesForKeysWithDictionary:jsonObject];
        }
        return self;
    }
    //derived class
    - (void)setValue:(id)value forUndefinedKey:(NSString *)key
    {
        if([key isEqualToString:@"id"])
            self.itemId = value;
        else if([key isEqualToString:@"description"])
            self.itemDescription = value;
        else [super setValue:value forUndefinedKey:key];
}

    -(void) setValue:(id)value forKey:(NSString *)key
    {
        if([key isEqualToString:@"reviews"])
        {
            for(NSMutableDictionary *reviewArrayDict in value)
            {
                Review *thisReview = [[Review alloc] initWithDictionary:reviewArrayDict];
                [self.reviews addObject:thisReview];
            }
        }  
        else
        [super setValue:value forKey:key];
    }

This is totally a KVC style, right? The reserved key word is handled in setValue:forUndefinedKey: as we really do not *define* the property.
Besieds, the model class has a better extensibility. If the json text has no excetptions, the derived class only need to define some properties.

AS I like the KVC, I will improve my code using PTL style. Notice here I do not just copy the code.
The code here is not so important, but the way of thinking behind the code is more important.



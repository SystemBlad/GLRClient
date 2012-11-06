package com.letv.aiLoader.multiMedia 
{
    import com.letv.aiLoader.type.*;
    
    public class AIDataFactory extends Object
    {
        public function AIDataFactory()
        {
            super();
            return;
        }

        public static function transformData(arg1:Array):Array
        {
            var loc4:*=null;
            if (pool == null) 
            {
                pool = {};
                pool[com.letv.aiLoader.type.ResourceType.TEXT] = 1;
                pool[com.letv.aiLoader.type.ResourceType.FLASH] = 1;
                pool[com.letv.aiLoader.type.ResourceType.BITMAP] = 1;
                pool[com.letv.aiLoader.type.ResourceType.VIDEO] = 1;
                pool[com.letv.aiLoader.type.ResourceType.BINARY] = 1;
                pool[com.letv.aiLoader.type.ResourceType.ORIGINAL] = 1;
            }
            var loc1:*=[];
            var loc2:*=arg1.length;
            var loc3:*=0;
            while (loc3 < loc2) 
            {
                if ((loc4 = arg1[loc3]) != null) 
                {
                    if (loc4.hasOwnProperty("type")) 
                    {
                        if (pool.hasOwnProperty(loc4.type)) 
                        {
                            if (!loc4.hasOwnProperty("url") || loc4.url == "") 
                            {
                                loc4.url = null;
                            }
                            if (!loc4.hasOwnProperty("retryMax") || isNaN(loc4.retryMax) || int(loc4.retryMax) <= 0) 
                            {
                                loc4.retryMax = 3;
                            }
                            if (!loc4.hasOwnProperty("first") || isNaN(loc4.first) || int(loc4.first) <= 5) 
                            {
                                loc4.first = 5000;
                            }
                            if (!loc4.hasOwnProperty("gap") || isNaN(loc4.gap)) 
                            {
                                loc4.gap = 1000;
                            }
                            loc1.push(loc4);
                        }
                    }
                }
                ++loc3;
            }
            return loc1;
        }

        public static function createMedia(arg1:int, arg2:Object):com.letv.aiLoader.multiMedia.IMedia
        {
            var loc1:*=null;
            var loc2:*=arg2.type;
            switch (loc2) 
            {
                case com.letv.aiLoader.type.ResourceType.FLASH:
                {
					
					trace("flash media")
                    loc1 = new com.letv.aiLoader.multiMedia.FlashMedia(arg1, arg2);
                    break;
                }
                case com.letv.aiLoader.type.ResourceType.TEXT:
                {
					trace("text media")
                    loc1 = new com.letv.aiLoader.multiMedia.TextMedia(arg1, arg2);
                    break;
                }
                case com.letv.aiLoader.type.ResourceType.VIDEO:
                {
					trace("video media")
                    loc1 = new com.letv.aiLoader.multiMedia.VideoMedia(arg1, arg2);
                    break;
                }
                case com.letv.aiLoader.type.ResourceType.BITMAP:
                {
                    loc1 = new com.letv.aiLoader.multiMedia.BitmapMedia(arg1, arg2);
                    break;
                }
                case com.letv.aiLoader.type.ResourceType.BINARY:
                {
                    loc1 = new com.letv.aiLoader.multiMedia.BinaryMedia(arg1, arg2);
                    break;
                }
                case com.letv.aiLoader.type.ResourceType.ORIGINAL:
                {
                    loc1 = new com.letv.aiLoader.multiMedia.OriginalMedia(arg1, arg2);
                    break;
                }
            }
            return loc1;
        }

        internal static var pool:Object;
    }
}

package com.utils
{
    public class KeyFrameUtil extends Object
    {
        public function KeyFrameUtil()
        {
            super();
            return;
        }

        public static function getKeyFrame(arg1:Object, arg2:Object):Number
        {
            var value:Object;
            var metadata:Object;
            var time:Number;
            var offsetList:Array;
            var timeList:Array;
            var len:int;
            var count:int;
            var lastValue:Number;
            var i:int;
            var currentValue:Number;

            var loc1:*;
            len = 0;
            count = 0;
            lastValue = NaN;
            i = 0;
            currentValue = NaN;
            value = arg1;
            metadata = arg2;
            time = Number(value);
            if (time < 0) 
            {
                return 0;
            }
            if (metadata == null || metadata.duration == null || metadata.keyframes == null) 
            {
                return time;
            }
            offsetList = metadata.keyframes.filepositions;
            timeList = metadata.keyframes.times;
            if (offsetList == null || timeList == null) 
            {
                return time;
            }
            if (offsetList.length <= 0 || timeList.length <= 0) 
            {
                return time;
            }
            try 
            {
                len = timeList.length;
                count = -1;
                lastValue = Math.abs(timeList[1] - time);
                i = 2;
                while (i < len) 
                {
                    currentValue = Math.abs(timeList[i] - time);
                    if (currentValue <= lastValue) 
                    {
                        lastValue = currentValue;
                        count = i;
                    }
                    else 
                    {
                        break;
                    }
                    ++i;
                }
                if (count < 0) 
                {
                    return 0;
                }
                if (count >= (len - 1)) 
                {
                    count = len - 3;
                }
                return timeList[count];
            }
            catch (e:Error)
            {
            };
            return 0;
        }
    }
}

package com.letv.aiLoader.events 
{
    import flash.events.*;
    
    public class AILoaderEvent extends flash.events.Event
    {
        public function AILoaderEvent(arg1:String, arg2:String=null, arg3:int=0, arg4:int=0, arg5:Boolean=false, arg6:Boolean=false)
        {
            super(arg1, arg5, arg6);
            if (arg2 != null) 
            {
                this.sourceType = arg2;
            }
            this.index = arg3;
            this.retry = arg4;
            return;
        }

        public override function toString():String
        {
            return "[AILoaderEvent type=" + type + " sourceType=" + this.sourceType + " index=" + this.index + "]";
        }

        public static const LOAD_ERROR:String="loadError";

        public static const LOAD_STATE_CHANGE:String="loadStateChange";

        public static const LOAD_COMPLETE:String="loadComplete";

        public static const WHOLE_COMPLETE:String="wholeComplete";

        public var dataProvider:Object;

        public var errorCode:int=-1;

        public var index:int;

        public var sourceType:String;

        public var infoCode:String;

        public var retry:int;
    }
}

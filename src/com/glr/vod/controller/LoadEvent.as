package com.glr.vod.controller 
{
    import flash.events.*;
    
    public class LoadEvent extends flash.events.Event
    {
        public function LoadEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false)
        {
            super(arg1, arg2, arg3);
            return;
        }

        public static const LOAD_COMPLETE:String="loadComplete";

        public static const LOAD_ERROR:String="loadError";

        public var dataProvider:Object;
    }
}

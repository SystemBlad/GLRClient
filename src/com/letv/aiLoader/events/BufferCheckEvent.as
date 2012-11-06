package com.letv.aiLoader.events 
{
    import flash.events.*;
    
    public class BufferCheckEvent extends flash.events.Event
    {
        public function BufferCheckEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false)
        {
            super(arg1, arg2, arg3);
            return;
        }

        public static const VIDEO_LOAD_COMPLETE:String="videoLoadComplete";
    }
}

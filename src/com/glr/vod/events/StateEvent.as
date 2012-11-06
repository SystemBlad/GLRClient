package com.glr.vod.events 
{
    import flash.events.*;
    
    public class StateEvent extends flash.events.Event
    {
        public function StateEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false)
        {
            super(arg1, arg2, arg3);
            return;
        }

        public var dataProvider:Object;
    }
}

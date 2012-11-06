package com.glr.components.dragbar 
{
    import flash.events.*;
    
    public class DragbarEvent extends flash.events.Event
    {
        public function DragbarEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false)
        {
            super(arg1, arg2, arg3);
            return;
        }

        public static const CHANGE:String="change";

        public var percent:Number=1;
    }
}

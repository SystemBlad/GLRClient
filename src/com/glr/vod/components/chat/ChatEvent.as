package com.glr.vod.components.chat 
{
    import flash.events.*;
    
    public class ChatEvent extends flash.events.Event
    {
        public function ChatEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false)
        {
            super(arg1, arg2, arg3);
            return;
        }

        public static const CHANGE_PROMPT:String="changePrompt";

        public var dataProvider:Object;
    }
}

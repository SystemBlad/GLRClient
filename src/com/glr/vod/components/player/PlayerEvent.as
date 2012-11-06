package com.glr.vod.components.player 
{
    import flash.events.*;
    
    public class PlayerEvent extends flash.events.Event
    {
        public function PlayerEvent(arg1:String, arg2:Boolean=false, arg3:Boolean=false)
        {
            super(arg1, arg2, arg3);
            return;
        }

        public static const ZOOM_IN:String="zoomIn";

        public static const ZOOM_OUT:String="zoomOut";

        public static const SEEK_TO:String="seekTo";

        public static const PAUSE:String="pause";

        public static const RESUME:String="resume";

        public static const VOLUME_CHANGE:String="volumeChange";

        public var dataProvider:Object;
    }
}

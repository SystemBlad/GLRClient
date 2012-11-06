package com.glr.vod.facade 
{
    import com.glr.vod.events.*;
    import flash.events.*;
    
    public class Notifier extends Object
    {
        public function Notifier(arg1:String, arg2:Boolean=true)
        {
            var loc1:*=null;
            var loc2:*=0;
            super();
            _list[arg1] = this;
            if (arg2) 
            {
                loc1 = this.listInteresting();
                loc2 = 0;
                while (loc2 < loc1.length) 
                {
                    event.addEventListener(loc1[loc2], this.onNotification);
                    ++loc2;
                }
            }
            return;
        }

        public function destroy():void
        {
            var loc1:*=this.listInteresting();
            var loc2:*=0;
            while (loc2 < loc1.length) 
            {
                event.removeEventListener(loc1[loc2], this.onNotification);
                ++loc2;
            }
            return;
        }

        internal function onNotification(arg1:com.glr.vod.events.StateEvent):void
        {
            this.handleNotification(new com.glr.vod.facade.Notification(arg1.type, arg1.dataProvider));
            return;
        }

        protected function listInteresting():Array
        {
            return [];
        }

        protected function handleNotification(arg1:com.glr.vod.facade.Notification):void
        {
			trace("do sth");
            return;
        }

        public static function getOB(arg1:String):com.glr.vod.facade.Notifier
        {
            return _list[arg1];
        }

        public static function sendNotification(arg1:String, arg2:Object=null):void
        {
            var loc1:*=new com.glr.vod.events.StateEvent(arg1);
            loc1.dataProvider = arg2;
            event.dispatchEvent(loc1);
            return;
        }

        
        {
            event = new flash.events.EventDispatcher();
            _list = {};
        }

        internal static var event:flash.events.EventDispatcher;

        internal static var _list:Object;
    }
}

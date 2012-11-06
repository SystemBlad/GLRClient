package com.letv.aiLoader.tools 
{
    import com.letv.aiLoader.events.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class BufferCheck extends flash.events.EventDispatcher
    {
        public function BufferCheck(arg1:flash.net.NetStream)
        {
            super();
            this.ns = arg1;
            this.originalSize = arg1.bytesTotal;
            return;
        }

        public function start():void
        {
            this.setLoop(true);
            return;
        }

        public function close():void
        {
            this.setLoop(false);
            this.ns = null;
            return;
        }

        protected function setLoop(arg1:Boolean):void
        {
            flash.utils.clearInterval(this.inter);
            if (arg1) 
            {
                this.inter = flash.utils.setInterval(this.onLoop, this.SPEED);
            }
            return;
        }

        protected function onLoop():void
        {
            var loc1:*;
            try 
            {
                if (this.ns && this.ns.bytesTotal > 0 && this.ns.bytesLoaded >= this.ns.bytesTotal) 
                {
                    this.close();
                    this.dispatchEvent(new com.letv.aiLoader.events.BufferCheckEvent(com.letv.aiLoader.events.BufferCheckEvent.VIDEO_LOAD_COMPLETE));
                }
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal const SPEED:uint=100;

        protected var ns:flash.net.NetStream;

        protected var originalSize:Number=0;

        internal var inter:int;
    }
}

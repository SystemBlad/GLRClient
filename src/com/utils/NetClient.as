package com.utils
{
    public class NetClient extends Object
    {
        public function NetClient(arg1:Object)
        {
            super();
            this.callback = arg1;
            return;
        }

        internal function forward(arg1:Object, arg2:String):void
        {
            var loc2:*=null;
            arg1["type"] = arg2;
            var loc1:*=new Object();
            var loc3:*=0;
            var loc4:*=arg1;
            for (loc2 in loc4) 
            {
                loc1[loc2] = arg1[loc2];
            }
            this.callback.onData(loc1);
            return;
        }

        public function close(... rest):void
        {
            this.forward({"close":true}, "close");
            return;
        }

        public function onBWCheck(... rest):Number
        {
            return 0;
        }

        public function onBWDone(... rest):void
        {
            if (rest.length > 0) 
            {
                this.forward({"bandwidth":rest[0]}, "bandwidth");
            }
            return;
        }

        public function onCaption(arg1:String, arg2:Number):void
        {
            this.forward({"captions":arg1, "speaker":arg2}, "caption");
            return;
        }

        public function onCaptionInfo(arg1:Object):void
        {
            this.forward(arg1, "captioninfo");
            return;
        }

        public function onCuePoint(arg1:Object):void
        {
            this.forward(arg1, "cuepoint");
            return;
        }

        public function onFCSubscribe(arg1:Object):void
        {
            this.forward(arg1, "fcsubscribe");
            return;
        }

        public function onHeaderData(arg1:Object):void
        {
            var loc4:*=null;
            var loc5:*=null;
            var loc1:*=new Object();
            var loc2:*="-";
            var loc3:*="_";
            var loc6:*=0;
            var loc7:*=arg1;
            for (loc4 in loc7) 
            {
                loc5 = loc4.replace("-", "_");
                loc1[loc5] = arg1[loc4];
            }
            this.forward(loc1, "headerdata");
            return;
        }

        public function onID3(... rest):void
        {
            this.forward(rest[0], "id3");
            return;
        }

        public function onImageData(arg1:Object):void
        {
            this.forward(arg1, "imagedata");
            return;
        }

        public function onLastSecond(arg1:Object):void
        {
            this.forward(arg1, "lastsecond");
            return;
        }

        public function onMetaData(arg1:Object):void
        {
            this.forward(arg1, "metadata");
            return;
        }

        public function onPlayStatus(arg1:Object):void
        {
            if (arg1.code != "NetStream.Play.Complete") 
            {
                this.forward(arg1, "playstatus");
            }
            else 
            {
                this.forward(arg1, "complete");
            }
            return;
        }

        public function onSDES(... rest):void
        {
            this.forward(rest[0], "sdes");
            return;
        }

        public function onXMPData(... rest):void
        {
            this.forward(rest[0], "xmp");
            return;
        }

        public function RtmpSampleAccess(... rest):void
        {
            this.forward(rest[0], "rtmpsampleaccess");
            return;
        }

        public function onTextData(arg1:Object):void
        {
            this.forward(arg1, "textdata");
            return;
        }

        public function onSendMsg(arg1:Object):void
        {
            this.callback.onData({"type":"onSendMsg", "info":arg1});
            return;
        }

        public function onSendText(arg1:Object):void
        {
            this.callback.onData({"type":"onSendText", "info":arg1});
            return;
        }

        public function onSendEmpty(arg1:Object):void
        {
            this.callback.onData({"type":"onSendEmpty", "info":arg1});
            return;
        }

        public function onSendClear(arg1:Object):void
        {
            this.callback.onData({"type":"onSendClear", "info":arg1});
            return;
        }

        public function onSendClap(arg1:Object):void
        {
            this.callback.onData({"type":"onSendClap", "info":arg1});
            return;
        }

        public function onSendOverClass(arg1:Object):void
        {
            this.callback.onData({"type":"onSendOverClass", "info":arg1});
            return;
        }

        public function onUserListChange(arg1:Object):void
        {
            this.callback.onData({"type":"onUserListChange", "info":arg1});
            return;
        }

        public function onClassFull(arg1:Object):void
        {
            this.callback.onData({"type":"onClassFull", "info":arg1});
            return;
        }
		
		public function onGetLatestChat(arg1:Object):void{
			this.callback.onData({"type":"onGetLatestChat", "info":arg1});
			return;
			
		}
		

        internal var callback:Object;
    }
}

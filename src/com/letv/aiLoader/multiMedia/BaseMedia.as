package com.letv.aiLoader.multiMedia 
{
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    
    public class BaseMedia extends flash.events.EventDispatcher implements com.letv.aiLoader.multiMedia.IMedia
    {
        public function BaseMedia(arg1:int=0, arg2:Object=null)
        {
            super();
            this._index = arg1;
            this._data = arg2;
            this._url = this._data["url"];
            this._retryMax = this._data["retryMax"];
            this._firstOutTime = Number(this._data["first"]);
            this._outTime = this._firstOutTime;
            this._gap = Number(this._data["gap"]);
            this._resourceType = this._data["type"];
            return;
        }

        public function get metadata():Object
        {
            return this._metadata;
        }

        public function get rect():flash.geom.Rectangle
        {
            return null;
        }

        public function get url():String
        {
            return this._url;
        }

        public function get size():int
        {
            return this._size;
        }

        public function get originalRect():flash.geom.Rectangle
        {
            return this._originalRect;
        }

        public function get speed():int
        {
            return 0;
        }

        public function get utime():int
        {
            if (this._startTime <= 0) 
            {
                return 0;
            }
            if (this._stopTime > 0) 
            {
                return this._stopTime - this._startTime;
            }
            return flash.utils.getTimer() - this._startTime;
        }

        public function get resourceType():String
        {
            return this._resourceType;
        }

        public function get content():Object
        {
            return null;
        }

        public function get hadError():Boolean
        {
            return this._hadError;
        }

        public function get hadUsed():Boolean
        {
            return this._hadUsed;
        }

        public function get hadCompress():String
        {
            return this._hadCompress;
        }

        public function mute(arg1:Number=1):void
        {
            return;
        }

        public function resume():void
        {
            return;
        }

        public function set visible(arg1:Boolean):void
        {
            return;
        }

        protected function request(arg1:Boolean=false):void
        {
            return;
        }

        protected function setDelay(arg1:Boolean):void
        {
            flash.utils.clearTimeout(this._timeout);
            if (arg1) 
            {
                this._timeout = flash.utils.setTimeout(this.onDelay, this._outTime);
            }
            return;
        }

        public function get domain():flash.system.ApplicationDomain
        {
            var loc1:*;
            try 
            {
                return this.content.content.loaderInfo.applicationDomain;
            }
            catch (e:Error)
            {
            };
            return null;
        }

        protected function onDelay():void
        {
            return;
        }

        public function destroy():void
        {
            return;
        }

        public function start(arg1:String=null):void
        {
            if (arg1 && !(arg1 == "")) 
            {
                this._url = arg1;
            }
            this.destroy();
            this.request();
            return;
        }

        public function get post():Object
        {
            if (this._data.hasOwnProperty("post") && this._data.post) 
            {
                return this._data.post;
            }
            return null;
        }

        public function pause():Boolean
        {
            return true;
        }

        public function get index():int
        {
            return this._index;
        }

        public function get data():Object
        {
            return this._data;
        }

        public function get retry():int
        {
            return this._retryTimes;
        }

        public function get time():Number
        {
            return this._time;
        }

        protected var _index:int;

        protected var _data:Object;

        protected var _url:String;

        protected var _size:int;

        protected var _stopTime:int=0;

        protected var _retryTimes:int=0;

        protected var _outTime:uint=5000;

        protected var _firstOutTime:uint=5000;

        protected var _gap:int=1000;

        protected var _retryMax:int=2;

        protected var _time:Number=0;

        protected var _metadata:Object;

        protected var _originalRect:flash.geom.Rectangle;

        protected var _resourceType:String;

        protected var _hadError:Boolean;

        protected var _hadUsed:Boolean;

        protected var _hadCompress:String="0";

        protected var _startTime:int=0;

        internal var _timeout:int;
    }
}

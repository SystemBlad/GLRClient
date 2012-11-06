package com.letv.aiLoader.multiMedia 
{
    import com.letv.aiLoader.errors.*;
    import com.letv.aiLoader.events.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class OriginalMedia extends com.letv.aiLoader.multiMedia.BaseMedia
    {
        public function OriginalMedia(arg1:int=0, arg2:Object=null)
        {
            super(arg1, arg2);
            return;
        }

        public override function get content():Object
        {
            return this.newContent;
        }

        public override function destroy():void
        {
            super.destroy();
            this.loaderGc();
            this.newContent = null;
            return;
        }

        public override function get speed():int
        {
            if (_stopTime > 0) 
            {
                return int(_size / (_stopTime - _startTime));
            }
            return 0;
        }

        protected override function request(arg1:Boolean=false):void
        {
            var retryFlag:Boolean=false;
            var newurl:String;

            var loc1:*;
            retryFlag = arg1;
            super.request(retryFlag);
            newurl = url;
            if (url && _retryTimes > 0) 
            {
                newurl = newurl + (newurl.indexOf("?") != -1 ? "&retry=" + _retryTimes : "?retry=" + _retryTimes);
            }
            _outTime = _firstOutTime + _gap * _retryTimes;
            var loc2:*;
            _retryTimes++;
            if (url == null || url == "") 
            {
                this.onOtherError();
                return;
            }
            this.loaderGc();
            this.loader = new flash.net.URLLoader();
            this.loader.dataFormat = flash.net.URLLoaderDataFormat.BINARY;
            this.loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
            this.loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            this.loader.addEventListener(flash.events.Event.COMPLETE, this.onComplete);
            try 
            {
                _startTime = flash.utils.getTimer();
                this.loader.load(new flash.net.URLRequest(newurl));
                setDelay(true);
            }
            catch (e:SecurityError)
            {
                onSecurityError();
            }
            catch (e:flash.errors.IOError)
            {
                onIOError();
            }
            catch (e:Error)
            {
                onOtherError();
            }
            catch (e:*)
            {
                onOtherError();
            }
            return;
        }

        protected override function onDelay():void
        {
            this.loaderGc();
            this.sendError("timeout", com.letv.aiLoader.errors.AIError.TIMEOUT_ERROR);
            return;
        }

        internal function onOtherError():void
        {
            this.loaderGc();
            this.sendError("otherError", com.letv.aiLoader.errors.AIError.OTHER_ERROR);
            return;
        }

        internal function onIOError(arg1:flash.events.IOErrorEvent=null):void
        {
            this.loaderGc();
            this.sendError("ioError", com.letv.aiLoader.errors.AIError.IO_ERROR);
            return;
        }

        internal function onSecurityError(arg1:flash.events.SecurityErrorEvent=null):void
        {
            this.loaderGc();
            this.sendError("securityError", com.letv.aiLoader.errors.AIError.SECURITY_ERROR);
            return;
        }

        internal function onComplete(arg1:flash.events.Event):void
        {
            var event:flash.events.Event;
            var str:String;
            var ev:com.letv.aiLoader.events.AILoaderEvent;
            var arr:Array;
            var newStr:String;
            var newArr:Array;
            var codeStr:String;
            var bytes:flash.utils.ByteArray;

            var loc1:*;
            str = null;
            ev = null;
            arr = null;
            newStr = null;
            newArr = null;
            codeStr = null;
            bytes = null;
            event = arg1;
            _stopTime = flash.utils.getTimer();
            _size = this.loader.bytesLoaded;
            try 
            {
                str = String(this.loader.data);
                if (str.substr(0, 5) != "<?xml") 
                {
                    this.newContent = str;
                }
                else 
                {
                    arr = str.split(" ");
                    newStr = arr[2];
                    newArr = newStr.split("\"");
                    codeStr = newArr[1];
                    bytes = this.loader.data;
                    this.newContent = bytes.readMultiByte(bytes.bytesAvailable, codeStr);
                }
                _hadUsed = true;
                ev = new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, resourceType, index, _retryTimes);
                ev.dataProvider = this;
                dispatchEvent(ev);
            }
            catch (e:Error)
            {
                trace("--x Error From OriginalMedia.onComplete", e.message);
                sendError("analyError", com.letv.aiLoader.errors.AIError.ANALY_ERROR);
            }
            this.loaderGc();
            return;
        }

        protected function sendState(arg1:String, arg2:int=0):void
        {
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_STATE_CHANGE, resourceType, index, _retryTimes);
            loc1.dataProvider = this;
            loc1.infoCode = arg1;
            loc1.errorCode = arg2;
            this.dispatchEvent(loc1);
            return;
        }

        protected function sendError(arg1:String, arg2:int=0):void
        {
            var loc1:*=null;
            _stopTime = flash.utils.getTimer();
            if (_retryTimes != _retryMax) 
            {
                this.sendState(arg1, arg2);
                this.request(true);
            }
            else 
            {
                this.destroy();
                this._hadError = true;
                loc1 = new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, resourceType, index, _retryTimes);
                loc1.dataProvider = this;
                loc1.infoCode = arg1;
                loc1.errorCode = arg2;
                dispatchEvent(loc1);
            }
            return;
        }

        internal function loaderGc():void
        {
            var loc1:*;
            setDelay(false);
            try 
            {
                this.loader.close();
            }
            catch (e:Error)
            {
            };
            if (this.loader) 
            {
                this.loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
                this.loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
                this.loader.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
            }
            this.loader = null;
            return;
        }

        internal var loader:flash.net.URLLoader;

        internal var newContent:Object;
    }
}

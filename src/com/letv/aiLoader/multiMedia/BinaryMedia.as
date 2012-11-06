package com.letv.aiLoader.multiMedia 
{
    import com.letv.aiLoader.errors.*;
    import com.letv.aiLoader.events.*;
    import com.letv.aiLoader.utils.*;
    import flash.display.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    
    public class BinaryMedia extends com.letv.aiLoader.multiMedia.BaseMedia
    {
        public function BinaryMedia(arg1:int=0, arg2:Object=null)
        {
            super(arg1, arg2);
            return;
        }

        public override function get rect():flash.geom.Rectangle
        {
            var loc1:*;
            try 
            {
                return new flash.geom.Rectangle(0, 0, this.content.contentLoaderInfo.width, this.content.contentLoaderInfo.height);
            }
            catch (e:Error)
            {
            };
            return new flash.geom.Rectangle(0, 0, 400, 300);
        }

        public override function get content():Object
        {
            return this.swfloader;
        }

        public override function destroy():void
        {
            super.destroy();
            this.loaderGc(true);
            this.swfloaderGc();
            if (this.swfloader) 
            {
                this.swfloader.unload();
                this.swfloader.unloadAndStop();
            }
            this.swfloader = null;
            this.loader = null;
            if (this.totalBytes) 
            {
                this.totalBytes.clear();
            }
            this.totalBytes = null;
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
            newurl = null;
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
            if (this.loader == null) 
            {
                this.loader = new flash.net.URLStream();
            }
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
            this.loaderGc(true);
            this.sendError("timeout", com.letv.aiLoader.errors.AIError.TIMEOUT_ERROR);
            return;
        }

        internal function onOtherError():void
        {
            this.loaderGc(true);
            this.sendError("otherError", com.letv.aiLoader.errors.AIError.OTHER_ERROR);
            return;
        }

        internal function onIOError(arg1:flash.events.IOErrorEvent=null):void
        {
            this.loaderGc(true);
            this.sendError("ioError", com.letv.aiLoader.errors.AIError.IO_ERROR);
            return;
        }

        internal function onSecurityError(arg1:flash.events.SecurityErrorEvent=null):void
        {
            this.loaderGc(true);
            this.sendError("securityError", com.letv.aiLoader.errors.AIError.SECURITY_ERROR);
            return;
        }

        internal function onComplete(arg1:flash.events.Event):void
        {
            var event:flash.events.Event;

            var loc1:*;
            event = arg1;
            _size = this.loader.bytesAvailable;
            _stopTime = flash.utils.getTimer();
            try 
            {
                if (this.totalBytes) 
                {
                    this.totalBytes.clear();
                }
                this.totalBytes = new flash.utils.ByteArray();
                this.loader.readBytes(this.totalBytes, 0, this.loader.bytesAvailable);
                this.compressCheck();
            }
            catch (e:Error)
            {
                trace("--x Error From FlashMedia.onComplete.compressCheck", e.message);
                sendError("analyError", com.letv.aiLoader.errors.AIError.ANALY_ERROR);
                return;
            }
            this.loaderGc();
            return;
        }

        internal function compressCheck():void
        {
            if (!(this.totalBytes[0] == 67) && !(this.totalBytes[1] == 87) && !(this.totalBytes[2] == 83)) 
            {
                this.sendError("analyError", com.letv.aiLoader.errors.AIError.ANALY_ERROR);
                return;
            }
            if (!(this.totalBytes[0] == 90) && !(this.totalBytes[1] == 87) && !(this.totalBytes[2] == 83)) 
            {
                this.sendError("analyError", com.letv.aiLoader.errors.AIError.ANALY_ERROR);
                return;
            }
            if (this.totalBytes[0] == 90) 
            {
                _hadCompress = "1";
                this.totalBytes = com.letv.aiLoader.utils.DeCompress.decodeSWF(this.totalBytes);
            }
            if (this.swfloader == null) 
            {
                this.swfloader = new flash.display.Loader();
            }
            this.swfloader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onCompressComplete);
            this.swfloader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
            var loc1:*=new flash.system.LoaderContext();
            loc1.applicationDomain = new flash.system.ApplicationDomain();
            if (loc1.hasOwnProperty("allowCodeImport")) 
            {
                loc1["allowCodeImport"] = true;
            }
            this.swfloader.loadBytes(this.totalBytes, loc1);
            this.loader = null;
            return;
        }

        internal function onCompressComplete(arg1:flash.events.Event):void
        {
            this.swfloader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, this.onCompressComplete);
            this.swfloader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
            _originalRect = new flash.geom.Rectangle(0, 0, this.swfloader.width, this.swfloader.height);
            _hadUsed = true;
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, resourceType, index, _retryTimes);
            loc1.dataProvider = this;
            this.dispatchEvent(loc1);
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

        internal function swfloaderGc():void
        {
            var loc1:*;
            if (this.swfloader) 
            {
                this.swfloader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, this.onCompressComplete);
                this.swfloader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
            }
            try 
            {
                this.swfloader.unload();
                this.swfloader.unloadAndStop();
                this.swfloader.close();
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal function loaderGc(arg1:Boolean=false):void
        {
            var gc:Boolean=false;

            var loc1:*;
            gc = arg1;
            setDelay(false);
            if (gc) 
            {
                try 
                {
                    this.loader.close();
                }
                catch (e:Error)
                {
                };
            }
            if (this.loader) 
            {
                this.loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
                this.loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
                this.loader.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
            }
            return;
        }

        internal var totalBytes:flash.utils.ByteArray;

        internal var loader:flash.net.URLStream;

        internal var swfloader:flash.display.Loader;
    }
}

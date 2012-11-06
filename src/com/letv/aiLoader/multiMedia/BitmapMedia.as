package com.letv.aiLoader.multiMedia 
{
    import com.letv.aiLoader.errors.*;
    import com.letv.aiLoader.events.*;
    import flash.display.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    
    public class BitmapMedia extends com.letv.aiLoader.multiMedia.BaseMedia
    {
        public function BitmapMedia(arg1:int=0, arg2:Object=null)
        {
            super(arg1, arg2);
            return;
        }

        public override function get rect():flash.geom.Rectangle
        {
            var loc1:*;
            try 
            {
                return new flash.geom.Rectangle(0, 0, this.content.width, this.content.height);
            }
            catch (e:Error)
            {
            };
            return new flash.geom.Rectangle(0, 0, 400, 300);
        }

        public override function get content():Object
        {
            var loc1:*;
            try 
            {
                return this.loader.content;
            }
            catch (e:Error)
            {
            };
            return null;
        }

        public override function set visible(arg1:Boolean):void
        {
            var value:Boolean;

            var loc1:*;
            value = arg1;
            try 
            {
                this.loader.content.visible = value;
            }
            catch (e:Error)
            {
            };
            return;
        }

        public override function destroy():void
        {
            super.destroy();
            this.loaderGc();
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
            this.loader = new flash.display.Loader();
            this.loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
            this.loader.contentLoaderInfo.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            this.loader.contentLoaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
            this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onComplete);
            try 
            {
                _startTime = flash.utils.getTimer();
                this.loader.load(new flash.net.URLRequest(newurl), new flash.system.LoaderContext(true));
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

        internal function onProgress(arg1:flash.events.ProgressEvent):void
        {
            if (_size == 0 && arg1.bytesTotal) 
            {
                _size = arg1.bytesTotal;
            }
            return;
        }

        internal function onComplete(arg1:flash.events.Event):void
        {
            var event:flash.events.Event;
            var ev:com.letv.aiLoader.events.AILoaderEvent;

            var loc1:*;
            ev = null;
            event = arg1;
            _stopTime = flash.utils.getTimer();
            this.loaderGc(false);
            try 
            {
                _originalRect = new flash.geom.Rectangle(0, 0, this.loader.width, this.loader.height);
                _hadUsed = true;
                ev = new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, resourceType, index, _retryTimes);
                ev.dataProvider = this;
                this.dispatchEvent(ev);
            }
            catch (e:Error)
            {
            };
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

        internal function loaderGc(arg1:Boolean=true):void
        {
            var gc:Boolean=true;

            var loc1:*;
            gc = arg1;
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
                this.loader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
                this.loader.contentLoaderInfo.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
                this.loader.contentLoaderInfo.removeEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
                this.loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
            }
            if (gc && this.loader) 
            {
                this.loader.unload();
                this.loader.unloadAndStop();
                this.loader = null;
            }
            return;
        }

        internal var loader:flash.display.Loader;
    }
}

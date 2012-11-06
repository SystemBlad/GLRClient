package com.letv.aiLoader.multiMedia 
{
    import com.glr.test.DeviceLogger;
    import com.letv.aiLoader.errors.*;
    import com.letv.aiLoader.events.*;
    
    import flash.errors.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class TextMedia extends com.letv.aiLoader.multiMedia.BaseMedia
    {
		
		private var logger:DeviceLogger;
		
        public function TextMedia(arg1:int=0, arg2:Object=null)
        {
            super(arg1, arg2);
			
			logger = DeviceLogger.getInstance(); 
				
            return;
        }

        public override function destroy():void
        {
            super.destroy();
            this.gc();
            return;
        }

        public override function get content():Object
        {
            var loc1:*;
            try 
            {
                return this.loadContent;
            }
            catch (e:Error)
            {
            };
            return null;
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
            var r:flash.net.URLRequest;

            var loc1:*;
            r = null;
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
                this.onIOError();
                return;
            }
            this.gc();
            this.loader = new flash.net.URLLoader();
            this.loader.addEventListener(flash.events.Event.COMPLETE, this.onComplete);
            this.loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
            this.loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
			
			
			
			trace(newurl)
			logger.log(newurl);
			
			//newurl = "http://www.glr.cn/playerapi.php"
            try 
            {
                _startTime = flash.utils.getTimer();
                r = new flash.net.URLRequest(newurl);
				r.authenticate = false;
                if (post) 
                {
					trace("post");
                    r.method = flash.net.URLRequestMethod.POST;
                    r.data = post;
                }
				
				
				trace("reqq  " + r.url);
                this.loader.load(r);
                //setDelay(true);
            }
            catch (e:SecurityError)
            {
				logger.log("secureError");
                onSecurityError();
            }
            catch (e:flash.errors.IOError)
            {
				logger.log("ioError");
                onIOError();
            }
            catch (e:Error)
            {
				logger.log("ioError");
                onIOError();
            }
            return;
        }

        protected override function onDelay():void
        {
            this.gc();
            this.sendError("timeout", com.letv.aiLoader.errors.AIError.TIMEOUT_ERROR);
            return;
        }

        internal function onIOError(arg1:flash.events.IOErrorEvent=null):void
        {
            this.gc();
			
			logger.log("ioError");
            this.sendError("ioError", com.letv.aiLoader.errors.AIError.IO_ERROR);
            return;
        }

        internal function onSecurityError(arg1:flash.events.SecurityErrorEvent=null):void
        {
            this.gc();
			logger.log("securityError");
            this.sendError("securityError", com.letv.aiLoader.errors.AIError.SECURITY_ERROR);
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
            _size = this.loader.bytesTotal;
			trace("size " + this.loader.bytesLoaded);
			
			logger.log("size " + this.loader.bytesLoaded);
			
            try 
            {
				trace("urldata " + event.target.data.toString())
				
				//if(this.loader.bytesLoaded == 0)
					//this.loadContent = '{"flv_path":"http:\\/\\/swf.glr.cn\\/20121022\\/259\\/259.flv","action_path":"http:\\/\\/swf.glr.cn\\/20121022\\/259\\/259.action"}'
				//else
                    this.loadContent = event.target.data;
                this.gc();
                _hadUsed = true;
                ev = new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, resourceType, index, _retryTimes);
                ev.dataProvider = this;
                dispatchEvent(ev);
				
				
            }
            catch (e:Error)
            {
				
                gc();
                sendError("otherError", com.letv.aiLoader.errors.AIError.ANALY_ERROR);
            }
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

        internal function gc():void
        {
            var loc1:*;
            try 
            {
                setDelay(false);
                this.loader.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
                this.loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
                this.loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
                this.loader.close();
            }
            catch (e:Error)
            {
            };
            this.loader = null;
            return;
        }

        internal var loadContent:Object;

        internal var loader:flash.net.URLLoader;
    }
}

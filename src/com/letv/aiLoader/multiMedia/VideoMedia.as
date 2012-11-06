package com.letv.aiLoader.multiMedia 
{
    import com.letv.aiLoader.errors.*;
    import com.letv.aiLoader.events.*;
    import com.letv.aiLoader.tools.*;
    import com.letv.aiLoader.type.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class VideoMedia extends com.letv.aiLoader.multiMedia.BaseMedia
    {
        public function VideoMedia(arg1:int=0, arg2:Object=null)
        {
			
			
            super(arg1, arg2);
            if (data.hasOwnProperty("dm") && String(data.dm) == "1" && com.letv.aiLoader.type.PlayerVersion.supportP2P) 
            {
                this._useDataMode = true;
            }
            else 
            {
                this._useDataMode = false;
            }
            return;
        }

        protected function onLoadProgress(arg1:flash.events.ProgressEvent):void
        {
            var loc1:*=null;
            if (this._loader.bytesAvailable > 0) 
            {
                loc1 = new flash.utils.ByteArray();
                this._loader.readBytes(loc1, 0, this._loader.bytesAvailable);
                loc1.readBytes(this._totalBytes, this._totalBytes.length, loc1.bytesAvailable);
            }
            if (_size <= 0 && arg1.bytesTotal > 0) 
            {
                _size = arg1.bytesTotal;
            }
            return;
        }

        protected function onLoadComplete(arg1:flash.events.Event):void
        {
            this.loaderGc();
            _stopTime = flash.utils.getTimer();
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, resourceType, index, _retryTimes);
            loc1.dataProvider = this;
            this.dispatchEvent(loc1);
            return;
        }

        protected function onNetStatus(arg1:flash.events.NetStatusEvent):void
        {
            var loc1:*=arg1.info.code;
            switch (loc1) 
            {
                case "NetConnection.Connect.Success":
                {
                    this._ns = new flash.net.NetStream(this._conn);
                    this._ns.client = new com.letv.aiLoader.tools.NetClient(this);
                    this._ns.bufferTime = 3;
                    this._video.attachNetStream(this._ns);
                    this._ns.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
                    if (this.useDataMode) 
                    {
                        this._ns.play(null);
                    }
                    break;
                }
                case "NetStream.Play.Start":
                {
                    this.sendState(arg1.info.code);
                    this.setCheck(true);
                    break;
                }
                case "NetStream.Play.Stop":
                case "NetStream.Buffer.Full":
                {
                    this.sendState(arg1.info.code);
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    if (this.useDataMode) 
                    {
                        if (this.metadata.duration - this._ns.time <= this._ns.bufferTime) 
                        {
                            this.sendState("NetStream.Play.Stop");
                        }
                        else 
                        {
                            this.sendState(arg1.info.code);
                        }
                    }
                    else 
                    {
                        this.sendState(arg1.info.code);
                    }
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                case "NetStream.Play.FileStructureInvalid":
                {
                    this.sendError(arg1.info.code, com.letv.aiLoader.errors.AIError.IO_ERROR);
                    break;
                }
            }
            return;
        }

        protected function setGetLoop(arg1:Boolean):void
        {
            var flag:Boolean;

            var loc1:*;
            flag = arg1;
            flash.utils.clearInterval(this._loopIner);
            if (flag) 
            {
                this._totalBytes.position = 0;
                try 
                {
                    this._ns.seek(0);
                }
                catch (e:Error)
                {
                };
                try 
                {
                    (this._ns)["appendBytesAction"]("resetBegin");
                }
                catch (e:Error)
                {
                };
                this.onLoop();
                this._loopIner = flash.utils.setInterval(this.onLoop, 50);
            }
            return;
        }

        public override function mute(arg1:Number=1):void
        {
            var value:Number=1;

            var loc1:*;
            value = arg1;
            try 
            {
                this._ns.soundTransform = new flash.media.SoundTransform(value);
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
            loc1.errorCode = arg2;
            loc1.infoCode = arg1;
            dispatchEvent(loc1);
            return;
        }

        protected function sendError(arg1:String, arg2:int=0):void
        {
            var loc1:*=null;
            _stopTime = flash.utils.getTimer();
            if (_retryTimes >= _retryMax) 
            {
                this.destroy();
                this._hadError = true;
                loc1 = new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, resourceType, index, _retryTimes);
                loc1.dataProvider = this;
                loc1.errorCode = arg2;
                loc1.infoCode = arg1;
                dispatchEvent(loc1);
            }
            else 
            {
                this.sendState(arg1, arg2);
                this.request(true);
            }
            return;
        }

        protected function loaderGc():void
        {
            var loc1:*;
            this.setCheck(false);
            setDelay(false);
            try 
            {
                this._loader.close();
            }
            catch (e:Error)
            {
            };
            try 
            {
                this._loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
                this._loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
                this._loader.removeEventListener(flash.events.ProgressEvent.PROGRESS, this.onLoadProgress);
                this._loader.removeEventListener(flash.events.Event.COMPLETE, this.onLoadComplete);
            }
            catch (e:Error)
            {
            };
            this._loader = null;
            return;
        }

        protected function gc():void
        {
            var loc1:*;
            this.loaderGc();
            this.setGetLoop(false);
            try 
            {
                this._totalBytes.clear();
            }
            catch (e:Error)
            {
            };
            try 
            {
                this._conn.close();
            }
            catch (e:Error)
            {
            };
            try 
            {
                this._conn.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
            }
            catch (e:Error)
            {
            };
            try 
            {
                this._ns.close();
            }
            catch (e:Error)
            {
            };
            try 
            {
                this._ns.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
            }
            catch (e:Error)
            {
            };
            this._ns = null;
            this._conn = null;
            this._totalBytes = null;
            return;
        }

        protected function setCheck(arg1:Boolean):void
        {
            if (arg1) 
            {
                _size = this._ns.bytesTotal;
                if (this._check == null) 
                {
                    this._check = new com.letv.aiLoader.tools.BufferCheck(this._ns);
                }
                this._check.addEventListener(com.letv.aiLoader.events.BufferCheckEvent.VIDEO_LOAD_COMPLETE, this.onLoadComplete);
                this._check.start();
            }
            else if (this._check) 
            {
                this._check.close();
                this._check.removeEventListener(com.letv.aiLoader.events.BufferCheckEvent.VIDEO_LOAD_COMPLETE, this.onLoadComplete);
                this._check = null;
            }
            return;
        }

        public override function destroy():void
        {
            super.destroy();
            this.gc();
            this._video = null;
            return;
        }

        public function get useDataMode():Boolean
        {
            return this._useDataMode;
        }

        public function get netstream():flash.net.NetStream
        {
            return this._ns;
        }

        public override function get content():Object
        {
            return this._video;
        }

        public override function set visible(arg1:Boolean):void
        {
            var value:Boolean;

            var loc1:*;
            value = arg1;
            try 
            {
                this._video.visible = value;
            }
            catch (e:Error)
            {
            };
            return;
        }

        public override function get time():Number
        {
            var loc1:*;
            try 
            {
                return this._ns.time;
            }
            catch (e:Error)
            {
            };
            return 0;
        }

        public override function get metadata():Object
        {
            return _metadata;
        }

        public override function get rect():flash.geom.Rectangle
        {
            var loc1:*;
            try 
            {
                return new flash.geom.Rectangle(0, 0, this.metadata.width, this.metadata.height);
            }
            catch (e:Error)
            {
            };
            return new flash.geom.Rectangle(0, 0, 400, 300);
        }

        public override function pause():Boolean
        {
            this._playing = false;
            if (this._ns) 
            {
                if (this.useDataMode) 
                {
                    if (hadUsed) 
                    {
                        this._ns.pause();
                    }
                }
                else 
                {
                    this._ns.pause();
                }
                return true;
            }
            return false;
        }

        public override function resume():void
        {
            var loc1:*;
            this._playing = true;
            try 
            {
                if (this.useDataMode) 
                {
                    if (!this._hadReume) 
                    {
                        this._hadReume = true;
                        this.setGetLoop(true);
                    }
                }
                this._ns.resume();
            }
            catch (e:Error)
            {
            };
            return;
        }

        protected function onLoop():void
        {
            var bytes:flash.utils.ByteArray;

            var loc1:*;
            bytes = null;
            if (this._totalBytes && this._totalBytes.bytesAvailable > 0) 
            {
                bytes = new flash.utils.ByteArray();
                this._totalBytes.readBytes(bytes, 0, this._totalBytes.bytesAvailable);
                try 
                {
                    (this._ns)["appendBytes"](bytes);
                }
                catch (e:Error)
                {
                };
            }
            return;
        }

        public function close():void
        {
            var loc1:*;
            try 
            {
                this._ns.close();
            }
            catch (e:Error)
            {
            };
            try 
            {
                this._video.clear();
            }
            catch (e:Error)
            {
            };
            return;
        }

        public function play(arg1:String):void
        {
            start(arg1);
            return;
        }

        public function set volume(arg1:Number):void
        {
            var value:Number;

            var loc1:*;
            value = arg1;
            try 
            {
                this._ns.soundTransform = new flash.media.SoundTransform(value);
            }
            catch (e:Error)
            {
            };
            return;
        }

        public function onData(arg1:Object):void
        {
            var info:Object;

            var loc1:*;
            info = arg1;
            if (info.type == "metadata") 
            {
                setDelay(false);
                if (!hadUsed) 
                {
                    if (!info.hasOwnProperty("duration")) 
                    {
                        info.duration = 15;
                    }
                    _metadata = info;
                    this._video.width = _metadata.width;
                    this._video.height = _metadata.height;
                    this.visible = true;
                    _hadUsed = true;
                    if (this.useDataMode && !this._playing) 
                    {
                        try 
                        {
                            this._ns.pause();
                        }
                        catch (e:Error)
                        {
                        };
                    }
                    this.sendState("metadata");
                }
            }
            return;
        }

        public override function get speed():int
        {
            if (this._ns == null) 
            {
                return 0;
            }
            if (_stopTime > 0) 
            {
                if (this._ns.bytesLoaded > 0) 
                {
                    return int(this._ns.bytesLoaded / (_stopTime - _startTime));
                }
                return int(_size / (_stopTime - _startTime));
            }
            if (this._ns.bytesLoaded > 0) 
            {
                return int(this._ns.bytesLoaded / (flash.utils.getTimer() - _startTime));
            }
            return int(_size / (flash.utils.getTimer() - _startTime));
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
                this.sendError("otherError", com.letv.aiLoader.errors.AIError.OTHER_ERROR);
                return;
            }
            this.gc();
            this.initVideo();
            this.visible = false;
            _startTime = flash.utils.getTimer();
            if (this.useDataMode) 
            {
                this._loader = new flash.net.URLStream();
                this._loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onIOError);
                this._loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
                this._loader.addEventListener(flash.events.ProgressEvent.PROGRESS, this.onLoadProgress);
                this._loader.addEventListener(flash.events.Event.COMPLETE, this.onLoadComplete);
                try 
                {
                    this.sendState("NetStream.Play.Start");
                    this.volume = 0;
                    this._totalBytes = new flash.utils.ByteArray();
                    this._loader.load(new flash.net.URLRequest(newurl));
                    this.setGetLoop(true);
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
            }
            else 
            {
                try 
                {
                    this._ns.play(newurl);
                }
                catch (e:Error)
                {
                };
                this.pause();
            }
            setDelay(true);
            return;
        }

        protected function initVideo():void
        {
            if (this._video == null) 
            {
                this._video = new flash.media.Video();
                this._video.smoothing = true;
            }
            this._conn = new flash.net.NetConnection();
            this._conn.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
            this._conn.connect(null);
            return;
        }

        protected override function onDelay():void
        {
            this.gc();
            this.sendError("timeout", com.letv.aiLoader.errors.AIError.TIMEOUT_ERROR);
            return;
        }

        protected function onOtherError():void
        {
            this.gc();
            this.sendError("otherError", com.letv.aiLoader.errors.AIError.OTHER_ERROR);
            return;
        }

        protected function onIOError(arg1:flash.events.IOErrorEvent=null):void
        {
            this.gc();
            this.sendError("ioError", com.letv.aiLoader.errors.AIError.IO_ERROR);
            return;
        }

        protected function onSecurityError(arg1:flash.events.SecurityErrorEvent=null):void
        {
            this.gc();
            this.sendError("securityError", com.letv.aiLoader.errors.AIError.SECURITY_ERROR);
            return;
        }

        internal var _useDataMode:Boolean;

        internal var _hadReume:Boolean;

        internal var _playing:Boolean;

        internal var _loader:flash.net.URLStream;

        internal var _ns:flash.net.NetStream;

        internal var _video:flash.media.Video;

        internal var _check:com.letv.aiLoader.tools.BufferCheck;

        internal var _totalBytes:flash.utils.ByteArray;

        internal var _loopIner:int;

        internal var _conn:flash.net.NetConnection;
    }
}

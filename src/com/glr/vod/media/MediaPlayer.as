package com.glr.vod.media 
{
    import com.glr.vod.*;
    import com.glr.vod.facade.*;
    import com.glr.vod.model.*;
    import com.glr.vod.notify.*;
    import com.letv.aiLoader.tools.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class MediaPlayer extends Object
    {
        public function MediaPlayer()
        {
            this.ACTION = {"onSendMsg":com.glr.vod.notify.LogicNotify.GOT_USER_SAY, "onSendText":com.glr.vod.notify.LogicNotify.GOT_TEXT_PEN, "onSendEmpty":com.glr.vod.notify.LogicNotify.CLEAR_GRAPHICS, "onSendClear":com.glr.vod.notify.LogicNotify.CLEAR_MSG, "onSendClap":com.glr.vod.notify.LogicNotify.GOT_CLAP, "pen":com.glr.vod.notify.LogicNotify.MOUSE_SO_CHANGE, "page":com.glr.vod.notify.LogicNotify.PAGE_SO_CHANGE};
            super();
            return;
        }

        protected function setInitAction():void
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc4:*=0;
            var loc1:*=this.model.setting.beforeAction;
            if (loc1 && loc1.length > 0) 
            {
                loc2 = loc1.length;
                loc4 = 0;
                while (loc4 < loc2) 
                {
                    if (loc1[loc4].type == "page") 
                    {
                        loc3 = loc1[loc4].value;
                    }
                    if (this.ACTION[loc1[loc4].type]) 
                    {
                        com.glr.vod.facade.Notifier.sendNotification(this.ACTION[loc1[loc4].type], loc1[loc4].value);
                    }
                    ++loc4;
                }
                if (loc3) 
                {
                    com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.LogicNotify.PAGE_SO_CHANGE, loc3);
                }
            }
            return;
        }

        protected function setLoop(arg1:Boolean):void
        {
            flash.utils.clearInterval(this._loopInter);
            if (arg1) 
            {
                this.onLoop();
                this._loopInter = flash.utils.setInterval(this.onLoop, 500);
            }
            return;
        }

		
		private var loc6 = 0;
		
        protected function onLoop():void
        {
            var loc1:*=NaN;
            var loc2:*=NaN;
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=0;
            var loc6:*=0;
            if (this.duration > 0) 
            {
                loc1 = (this.startTime + this.percent * (this.duration - this.startTime)) / this.duration;
                loc2 = this.videoTime / this.duration;
                loc3 = {"time":this.videoTime, "load":loc1, "play":loc2};
                com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.LogicNotify.UPDATE_TIME, loc3);
				
				//trace(this.model.setting.action.length)
                if (loc4 = this.model.setting.action) 
                {
					
                    loc5 = loc4.length;
					//trace(loc5)
                   
                    //while (loc6 < loc5) 
                    //{
                        if (loc4[loc6].valid && !loc4[loc6].used && Math.abs(loc4[loc6].time - this.videoTime) <= ACCURACY) 
                        {
                            loc4[loc6].used = true;
                            if (this.ACTION[loc4[loc6].type]) 
                            {
								//trace("type " + this.ACTION[loc4[loc6].type]);
                                com.glr.vod.facade.Notifier.sendNotification(this.ACTION[loc4[loc6].type], loc4[loc6].value);
                            }
                            if (!(loc4[loc6].time > this.videoTime + ACCURACY)) 
                            {
                            };
							
							++loc6;
                        }
                        
                   // }
                }
            }
            return;
        }

        protected function setDelay(arg1:Boolean):void
        {
            flash.utils.clearTimeout(this._timeout);
            if (arg1) 
            {
                this._timeout = flash.utils.setTimeout(this.onDelay, 10000);
            }
            return;
        }

        protected function onDelay():void
        {
            this.mediaError();
            return;
        }

        protected function mediaError():void
        {
            this.closeStream();
            com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.ErrorNotify.ERROR_MEDIA);
            return;
        }

        public static function getInstance():com.glr.vod.media.MediaPlayer
        {
            if (_instance == null) 
            {
                _instance = new MediaPlayer();
            }
            return _instance;
        }

        public function init(arg1:com.glr.vod.model.Model):void
        {
            com.glr.vod.Vod.log("Init Vod Media");
            this.model = arg1;
            this.setupStream();
            this.setDelay(true);
            return;
        }

        protected function setupStream():void
        {
            this.closeStream();
            this.conn = new flash.net.NetConnection();
            this.conn.connect(null);
            this.stream = new flash.net.NetStream(this.conn);
            this.stream.bufferTime = 3;
            this.stream.client = new com.letv.aiLoader.tools.NetClient(this);
            this.stream.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
            this.setDelay(true);
            this.play(0);
			this.loc6 = 0;
            return;
        }

        protected function closeStream():void
        {
            this.setDelay(false);
            this.setLoop(false);
            if (this.conn) 
            {
                this.conn.close();
                this.conn.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
            }
            if (this.stream) 
            {
                this.stream.close();
                this.stream.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
            }
            this.conn = null;
            this.stream = null;
            return;
        }

        protected function play(arg1:Number):void
        {
            var time:Number;

            var loc1:*;
            time = arg1;
            try 
            {
                this.stream.close();
            }
            catch (e:Error)
            {
            };
            try 
            {
                this.stream.play(this.model.setting.flv);
            }
            catch (e:Error)
            {
            };
            return;
        }

        protected function onNetStatus(arg1:flash.events.NetStatusEvent):void
        {
            if (arg1.info.code == "NetStream.Buffer.Flush") 
            {
                return;
            }
            com.glr.vod.Vod.log("Vod Media InfoCode: " + arg1.info.code);
            var loc1:*=arg1.info.code;
            switch (loc1) 
            {
                case "NetStream.Play.Start":
                {
                    this.stream.soundTransform = new flash.media.SoundTransform(0.5);
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    this.onStop();
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    this.onEmpty();
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this.onFull();
                    break;
                }
                case "NetStream.Seek.InvalidTime":
                {
                    this.stream.seek(arg1.info.details);
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                case "NetStream.Play.FileStructureInvalid":
                {
                    this.mediaError();
                    break;
                }
            }
            return;
        }

        protected function onFull():void
        {
            this.setDelay(false);
            if (this.playStart) 
            {
                com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.LogicNotify.BUFFER_FULL);
            }
            else 
            {
                this.playStart = true;
                com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.InitNotiy.GOT_MEDIA);
                this.setInitAction();
            }
            this.stream.soundTransform = new flash.media.SoundTransform(this.model.setting.volume);
            this.setLoop(true);
            return;
        }

        protected function onEmpty():void
        {
            if (this.duration - this.videoTime > this.stream.bufferTime) 
            {
                this.setDelay(true);
                com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.LogicNotify.BUFFER_EMPTY);
            }
            return;
        }

        protected function onStop():void
        {
            com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.LogicNotify.PLAY_STOP);
            return;
        }

        public function onData(arg1:Object):void
        {
            var loc1:*=arg1.type;
            switch (loc1) 
            {
                case "metadata":
                {
                    this.metadata = arg1;
                    com.glr.vod.Vod.log("onData: " + arg1.type + " " + this.duration);
                    com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.LogicNotify.METADATA, this.metadata);
                    break;
                }
            }
            return;
        }

        public function seekTo(arg1:Object):void
        {
			
			trace("seek");
            var loc1:*=com.glr.vod.media.KeyFrameUtil.getKeyFrame(arg1, this.metadata);
            com.glr.vod.Vod.log("Vod SeekTo " + loc1 + " - " + this.duration);
            var loc2:*=this.startTime + this.percent * (this.duration - this.startTime);
            if (loc1 >= this.startTime && loc1 < loc2) 
            {
                this.setLoop(false);
                this.seekTime = loc1;
                this.resetAction(loc1);
            }
            return;
        }

        public function resume():void
        {
            var loc1:*;
            try 
            {
                this.stream.resume();
            }
            catch (e:Error)
            {
            };
            return;
        }

        public function pause():void
        {
            var loc1:*;
            try 
            {
                this.stream.pause();
            }
            catch (e:Error)
            {
            };
            return;
        }

        public function set volume(arg1:Number):void
        {
            var value:Number;

            var loc1:*;
            value = arg1;
            try 
            {
                this.stream.soundTransform = new flash.media.SoundTransform(value);
            }
            catch (e:Error)
            {
            };
            return;
        }

        public function get videoTime():Number
        {
            if (this.stream) 
            {
                if (this.seekTime > 0 && Math.abs(this.stream.time - this.seekTime) > this.stream.bufferTime) 
                {
                    return this.seekTime;
                }
                this.seekTime = 0;
                if (this.stream.time > 0) 
                {
                    return this.stream.time;
                }
            }
            return this.startTime;
        }

        public function get duration():Number
        {
            var loc1:*;
            try 
            {
                return this.metadata.duration;
            }
            catch (e:Error)
            {
            };
            return 0;
        }

        public function get percent():Number
        {
            var loc1:*;
            try 
            {
                return this.stream.bytesLoaded / this.stream.bytesTotal;
            }
            catch (e:Error)
            {
            };
            return 0;
        }

        public function resetActionBack():void
        {
            var loc1:*=0;
            var loc2:*=0;
            var loc3:*=NaN;
            if (this.model.setting.delayAction) 
            {
                com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.LogicNotify.CLEAR_MSG);
                com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.LogicNotify.CLEAR_GRAPHICS);
                loc1 = this.model.setting.delayAction.length;
                loc2 = 0;
                while (loc2 < loc1) 
                {
                    com.glr.vod.facade.Notifier.sendNotification(this.ACTION[this.model.setting.delayAction[loc2].type], this.model.setting.delayAction[loc2].value);
                    ++loc2;
                }
                com.glr.vod.Vod.log("resetActionCheck Seek " + this.seekTime);
                loc3 = this.startTime + this.percent * (this.duration - this.startTime);
                this.stream.seek(this.seekTime);
            }
            this.model.setting.delayAction = null;
            return;
        }

        protected function resetAction(arg1:Number):void
        {
            var loc2:*=0;
            var loc3:*=NaN;
            var loc4:*=0;
            var loc5:*=0;
            var loc6:*=null;
            var loc7:*=0;
            var loc8:*=0;
            var loc9:*=0;
            var loc10:*=0;
            this.model.setting.delayAction = [];
            var loc1:*=this.model.setting.action;
            if (loc1 && loc1.length > 0) 
            {
                loc2 = 0;
                loc3 = 0;
                loc4 = loc1.length;
                loc5 = 0;
                while (loc5 < loc4) 
                {
                    loc1[loc5].used = false;
                    ++loc5;
                }
                loc5 = 0;
                while (loc5 < loc4) 
                {
                    if (loc1[loc5].valid) 
                    {
                        if (loc3 != 0) 
                        {
                            if (loc1[loc5].time <= arg1) 
                            {
                                loc3 = loc1[loc5].time;
                                loc2 = loc5;
                            }
                            else 
                            {
                                break;
                            }
                        }
                        else 
                        {
                            loc3 = loc1[loc5].time;
                        }
                    }
                    ++loc5;
                }
                loc7 = -1;
                loc8 = -1;
                loc9 = -1;
                loc5 = 0;
                while (loc5 <= loc2) 
                {
                    if (loc1[loc5].type == "page") 
                    {
                        loc6 = loc1[loc5].value;
                        loc7 = loc5;
                    }
                    if (loc1[loc5].type == "onSendEmpty") 
                    {
                        loc8 = loc5;
                    }
                    if (loc1[loc5].type == "onSendClear") 
                    {
                        loc9 = loc5;
                    }
                    ++loc5;
                }
                loc5 = (loc10 = Math.max(loc7, loc8)) + 1;
                while (loc5 <= loc2) 
                {
                    if (loc1[loc5].type == "pen" || loc1[loc5].type == "onSendText") 
                    {
                        loc1[loc5].used = true;
                        this.model.setting.delayAction.push(loc1[loc5]);
                    }
                    ++loc5;
                }
                loc5 = loc9 + 1;
                while (loc5 <= loc2) 
                {
                    if (loc1[loc5].type == "onSendMsg") 
                    {
                        loc1[loc5].used = true;
                        this.model.setting.delayAction.push(loc1[loc5]);
                    }
                    ++loc5;
                }
                com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.LogicNotify.BUFFER_EMPTY);
                if (loc6 && !(loc6["url"] == this.model.setting.currentUrl)) 
                {
                    com.glr.vod.facade.Notifier.sendNotification(com.glr.vod.notify.LogicNotify.PAGE_SO_CHANGE, loc6);
                }
                else 
                {
                    this.resetActionBack();
                }
            }
            return;
        }

        public static const ACCURACY:Number=0.5;

        internal var model:com.glr.vod.model.Model;

        protected var conn:flash.net.NetConnection;

        protected var stream:flash.net.NetStream;

        protected var playStart:Boolean;

        protected var metadata:Object;

        protected var seekTime:Number=0;

        protected var startTime:Number=0;

        protected var _loopInter:int;

        protected var _timeout:int;

        internal static var _instance:com.glr.vod.media.MediaPlayer;

        internal var ACTION:Object;
    }
}

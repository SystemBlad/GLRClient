package com.glr.vod.components.player.classes 
{
    import com.adobe.utils.*;
    import com.glr.components.*;
    import com.glr.vod.components.player.*;
    import com.glr.vod.components.player.classes.controlbar.*;
    import com.glr.vod.components.player.classes.volume.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    public class ControlbarUI extends com.glr.components.UIComponent
    {
        public function ControlbarUI(arg1:Object, arg2:Object=null)
        {
            super(arg1, arg2);
            return;
        }

        public override function resize(arg1:flash.geom.Rectangle):void
        {
            var loc1:*=NaN;
            if (skin) 
            {
                loc1 = arg1.width;
                if (skin.back) 
                {
                    skin.back.width = arg1.width;
                    skin.x = 0;
                    skin.y = arg1.height - skin.back.height;
                }
                if (skin.screen) 
                {
                   // skin.screen.x = loc1 - skin.screen.width - 10;
                   // loc1 = skin.screen.x;
                }
                if (skin.volume) 
                {
                    skin.volume.x = loc1 - skin.volume.width - 10 - 100;
                }
                if (skin.dragbarBack) 
                {
                    skin.dragbarBack.x = 0;
                    skin.dragbarBack.width = arg1.width;
                }
                if (this.track) 
                {
                    this.track.resize(arg1);
                }
            }
            return;
        }

        public function set pageData(arg1:Object):void
        {
            if (arg1) 
            {
                this.index = arg1.index;
                this.total = arg1.total;
                if (this.total != 1) 
                {
                    if (this.total > 1) 
                    {
                        if (this.index != 0) 
                        {
                            if (this.index != (this.total - 1)) 
                            {
                                this.pageLink(this.index + 1 + " / " + this.total);
                            }
                            else 
                            {
                                this.pageLink(this.index + 1 + " / " + this.total);
                            }
                        }
                        else 
                        {
                            this.pageLink(this.index + 1 + " / " + this.total);
                        }
                    }
                    else 
                    {
                        this.pageLink("1 / 1");
                    }
                }
                else 
                {
                    this.pageLink(this.index + 1 + " / " + this.total);
                }
            }
            else if (this.total > 0) 
            {
                this.pageLink(this.index + 1 + " / " + this.total);
            }
            else 
            {
                this.pageLink("1 / 1");
            }
            return;
        }

        public function setMeta(arg1:Object):void
        {
            this.metadata = arg1;
			this.track.metadata = arg1;
            this.inPlayState();
            return;
        }

        public function updateTime(arg1:Object):void
        {
            this.track.percent = arg1;
            skin.timeTxt.text = com.adobe.utils.TimeUtil.swap2(Math.round(arg1.time)) + "/" + com.adobe.utils.TimeUtil.swap2(this.duration);
            return;
        }

        public function initState():void
        {
            if (skin.pauseBtn) 
            {
                skin.pauseBtn.mouseEnabled = false;
            }
            if (skin.playBtn) 
            {
                skin.playBtn.mouseEnabled = false;
                skin.playBtn.removeEventListener(flash.events.MouseEvent.CLICK, this.onResume);
                skin.playBtn.removeEventListener(flash.events.MouseEvent.CLICK, this.onReplay);
            }
            return;
        }

        public function inStopState():void
        {
            if (skin.pauseBtn) 
            {
                skin.pauseBtn.visible = false;
            }
            if (skin.playBtn) 
            {
                skin.playBtn.visible = true;
                skin.playBtn.removeEventListener(flash.events.MouseEvent.CLICK, this.onResume);
                skin.playBtn.addEventListener(flash.events.MouseEvent.CLICK, this.onReplay);
            }
            return;
        }

        public function inPauseState():void
        {
            if (skin.pauseBtn) 
            {
                skin.pauseBtn.visible = false;
            }
            if (skin.playBtn) 
            {
                skin.playBtn.visible = true;
                skin.playBtn.addEventListener(flash.events.MouseEvent.CLICK, this.onResume);
                skin.playBtn.removeEventListener(flash.events.MouseEvent.CLICK, this.onReplay);
            }
            return;
        }

        public function inPlayState():void
        {
            if (skin.pauseBtn) 
            {
                skin.pauseBtn.visible = true;
                skin.pauseBtn.mouseEnabled = true;
            }
            if (skin.playBtn) 
            {
                skin.playBtn.visible = false;
                skin.playBtn.mouseEnabled = true;
            }
            return;
        }

        protected override function init():void
        {
            if (skin) 
            {
                this.initState();
                if (skin.timeTxt) 
                {
                    skin.timeTxt.text = "视频载入中请稍候...";
                    skin.timeTxt.mouseEnabled = false;
                }
                if (skin.track) 
                {
                    this.track = new com.glr.vod.components.player.classes.controlbar.TrackUI(skin.track);
                }
                if (skin.volume) 
                {
                    this.volume = new com.glr.vod.components.player.classes.volume.VolumeUI(skin.volume);
                }
                if (skin.pauseBtn) 
                {
                    skin.pauseBtn.visible = false;
                    skin.pauseBtn.addEventListener(flash.events.MouseEvent.CLICK, this.onPause);
                }
                this.addListener();
            }
            return;
        }

        protected function get duration():Number
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

        protected function pageLink(arg1:String):void
        {
            if (skin.pageTxt) 
            {
                skin.pageTxt.htmlText = arg1;
            }
            return;
        }

        internal function addListener():void
        {
            if (skin) 
            {
                if (skin.screen) 
                {
                    skin.screen.addEventListener(flash.events.MouseEvent.CLICK, this.onScreen);
                }
                if (skin.stage) 
                {
                    skin.stage.addEventListener(flash.events.FullScreenEvent.FULL_SCREEN, this.onFullScreen);
                }
                if (skin.zoomIn) 
                {
                    skin.zoomIn.addEventListener(flash.events.MouseEvent.CLICK, this.onZoomIn);
                }
                if (skin.zoomOut) 
                {
                    skin.zoomOut.addEventListener(flash.events.MouseEvent.CLICK, this.onZoomOut);
                }
                if (this.track) 
                {
                    this.track.addEventListener(com.glr.vod.components.player.PlayerEvent.SEEK_TO, this.onSeekTo);
                }
                if (this.volume) 
                {
                    this.volume.addEventListener(com.glr.vod.components.player.PlayerEvent.VOLUME_CHANGE, this.onVolumeChange);
                }
            }
            return;
        }

        internal function removeListener():void
        {
            if (skin) 
            {
                if (skin.screen) 
                {
                    skin.screen.removeEventListener(flash.events.MouseEvent.CLICK, this.onScreen);
                }
                if (skin.stage) 
                {
                    skin.stage.removeEventListener(flash.events.FullScreenEvent.FULL_SCREEN, this.onFullScreen);
                }
                if (skin.zoomIn) 
                {
                    skin.zoomIn.removeEventListener(flash.events.MouseEvent.CLICK, this.onZoomIn);
                }
                if (skin.zoomOut) 
                {
                    skin.zoomOut.removeEventListener(flash.events.MouseEvent.CLICK, this.onZoomOut);
                }
                if (this.track) 
                {
                    this.track.removeEventListener(com.glr.vod.components.player.PlayerEvent.SEEK_TO, this.onSeekTo);
                }
            }
            return;
        }

        internal function onPause(arg1:flash.events.MouseEvent):void
        {
            this.inPauseState();
            dispatchEvent(new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.PAUSE));
            return;
        }

        internal function onResume(arg1:flash.events.MouseEvent):void
        {
            this.inPlayState();
            dispatchEvent(new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.RESUME));
            return;
        }

        internal function onReplay(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=null;
            this.inPlayState();
            if (this.duration > 0) 
            {
                loc1 = new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.SEEK_TO);
                loc1.dataProvider = 0;
                dispatchEvent(loc1);
            }
            return;
        }

        internal function onScreen(arg1:flash.events.MouseEvent):void
        {
            var event:flash.events.MouseEvent;

            var loc1:*;
            event = arg1;
            if (event.currentTarget.currentFrame != 1) 
            {
                event.currentTarget.gotoAndStop(1);
                skin.stage.displayState = flash.display.StageDisplayState.NORMAL;
            }
            else 
            {
                event.currentTarget.gotoAndStop(2);
                try 
                {
                    skin.stage.displayState = flash.display.StageDisplayState.FULL_SCREEN;
                }
                catch (e:Error)
                {
                };
            }
            return;
        }

        internal function onFullScreen(arg1:flash.events.FullScreenEvent):void
        {
            if (arg1.fullScreen) 
            {
                skin.screen.gotoAndStop(2);
            }
            else 
            {
                skin.screen.gotoAndStop(1);
            }
            return;
        }

        internal function onZoomIn(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.ZOOM_IN));
            return;
        }

        internal function onZoomOut(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.ZOOM_OUT));
            return;
        }

        internal function onSeekTo(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            var loc1:*=null;
            if (this.duration > 0) 
            {
                this.inPlayState();
                loc1 = new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.SEEK_TO);
                loc1.dataProvider = Number(arg1.dataProvider) * this.duration;
                dispatchEvent(loc1);
            }
            return;
        }

        internal function onVolumeChange(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            var loc1:*=new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.VOLUME_CHANGE);
            loc1.dataProvider = arg1.dataProvider;
            dispatchEvent(loc1);
            return;
        }

        public static const CSS:String="a{font-size:12px;color:#000000;}a:hover{color:#0066FF;}";

        internal var index:int;

        internal var total:int;

        internal var track:com.glr.vod.components.player.classes.controlbar.TrackUI;

        internal var volume:com.glr.vod.components.player.classes.volume.VolumeUI;

        internal var metadata:Object;
    }
}

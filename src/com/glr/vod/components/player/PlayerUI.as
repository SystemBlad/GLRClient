package com.glr.vod.components.player 
{
    import com.glr.components.*;
    import com.glr.vod.components.player.classes.*;
    import com.greensock.TweenLite;
    
    import flash.events.MouseEvent;
    import flash.geom.*;
    
    public class PlayerUI extends com.glr.components.UIComponent
    {
        public function PlayerUI(arg1:Object, arg2:Object=null)
        {
            super(arg1, arg2);
            return;
        }

        public override function resize(arg1:flash.geom.Rectangle):void
        {
            if (skin && skin.stage) 
            {
                if (this.headArea) 
                {
                    this.headArea.resize(arg1);
                }
                if (this.scroll) 
                {
                    this.scroll.resize(arg1);
                }
                if (this.controlbar) 
                {
                    this.controlbar.resize(arg1);
                }
                if (skin.loading) 
                {
                    skin.loading.x = arg1.width / 2;
                    skin.loading.y = arg1.height / 2;
                }
                if (skin.loadingBack) 
                {
                    var loc1:*;
                    skin.loadingBack.y = loc1 = 0;
                    skin.loadingBack.x = loc1;
                    skin.loadingBack.width = arg1.width;
                    skin.loadingBack.height = arg1.height;
                }
                skin.x = arg1.x;
                skin.y = arg1.y;
						
				this.controlBarX = this.controlbar.skin.x;
				this.controlBarY = this.controlbar.skin.y;
				
            }
            return;
        }

        public function set metadata(arg1:Object):void
        {
            var value:Object;

            var loc1:*;
            value = arg1;
            try 
            {
                this.controlbar.setMeta(value);
            }
            catch (e:Error)
            {
            };
            this.bufferFull();
            return;
        }

        public function stopVideo():void
        {
            this.controlbar.inStopState();
            return;
        }

        public function bufferEmpty():void
        {
            skin.loading.visible = true;
            skin.loadingBack.visible = true;
            skin.loading.label.text = "正在努力准备视频";
            skin.loading.gotoAndStop(1);
            return;
        }

        public function bufferFull():void
        {
            skin.loading.visible = false;
            skin.loadingBack.visible = false;
            return;
        }

        public function set penPosition(arg1:Object):void
        {
            this.scroll.penPosition = arg1;
            return;
        }

        public function set page(arg1:Object):void
        {
            this.scroll.pageData = arg1;
            return;
        }

        public function set textPen(arg1:Object):void
        {
            this.scroll.textPen = arg1;
            return;
        }

        public function updateTime(arg1:Object):void
        {
            this.controlbar.updateTime(arg1);
            return;
        }

        public function clearGraphics():void
        {
            this.scroll.clearGraphics();
            return;
        }

        public function initMedia():void
        {
            this.headArea.enabled = true;
            this.controlbar.enabled = true;
            this.scroll.enabled = true;
            return;
        }

        public function mediaDataError(arg1:String="无法连接至媒体"):void
        {
            this.headArea.enabled = false;
            this.controlbar.enabled = false;
            this.scroll.enabled = false;
            skin.loading.visible = true;
            skin.loadingBack.visible = true;
            skin.loading.label.text = arg1;
            skin.loading.gotoAndStop(2);
            return;
        }

        protected override function init():void
        {
            if (skin) 
            {
                this.headArea = new com.glr.vod.components.player.classes.HeadAreaUI(skin.headArea, config);
                this.controlbar = new com.glr.vod.components.player.classes.ControlbarUI(skin.controlbar, config);
                this.scroll = new com.glr.vod.components.player.classes.ScrollUI(skin.scroll, config);
                this.headArea.enabled = false;
                this.controlbar.enabled = false;
                this.scroll.enabled = false;
                this.addListener();
				
				
				
				
            }
            return;
        }

        internal function addListener():void
        {
            if (this.scroll) 
            {
                this.controlbar.addEventListener(com.glr.vod.components.player.PlayerEvent.ZOOM_IN, this.onZoomIn);
                this.controlbar.addEventListener(com.glr.vod.components.player.PlayerEvent.ZOOM_OUT, this.onZoomOut);
                this.controlbar.addEventListener(com.glr.vod.components.player.PlayerEvent.SEEK_TO, this.onSeekTo);
                this.controlbar.addEventListener(com.glr.vod.components.player.PlayerEvent.PAUSE, this.onPause);
                this.controlbar.addEventListener(com.glr.vod.components.player.PlayerEvent.RESUME, this.onResume);
                this.controlbar.addEventListener(com.glr.vod.components.player.PlayerEvent.VOLUME_CHANGE, this.onVolumeChange);
				
				this.scroll.addEventListener(MouseEvent.CLICK, this.onMouseClicked);
				
            }
            return;
        }

		private var isControlBarVisible:Boolean = true;
		private var controlBarX:Number;
		private var controlBarY:Number;
		
		private function onMouseClicked(e:MouseEvent):void{
			
			
			if(isControlBarVisible)
			{
				this.scroll.removeEventListener(MouseEvent.CLICK, this.onMouseClicked);
				var endX = -0.25 * this.controlbar.skin.width;
				var endY = this.controlbar.skin.y - 0.25 * this.controlbar.skin.height;
				
				TweenLite.to(this.controlbar.skin, 0.25, {scaleX:1.5, scaleY:1.5, alpha:0, x:endX, y:endY, onComplete:this.onHideComplete})
			}
			else
			{
			   TweenLite.to(this.controlbar.skin, 0.3, {scaleX:1, scaleY:1, alpha:1, x:controlBarX, y:controlBarY})
			   this.controlbar.visible = true;
			   isControlBarVisible = true;
			}
		}
		
		private function onHideComplete():void{
			this.controlbar.visible = false;
			isControlBarVisible = false;
			this.scroll.addEventListener(MouseEvent.CLICK, this.onMouseClicked);
			
		}
		
        internal function onZoomIn(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            if (this.scroll) 
            {
                this.scroll.zoomIn();
            }
            return;
        }

        internal function onZoomOut(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            if (this.scroll) 
            {
                this.scroll.zoomOut();
            }
            return;
        }

        internal function onSeekTo(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            var loc1:*=new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.SEEK_TO);
            loc1.dataProvider = arg1.dataProvider;
            dispatchEvent(loc1);
            return;
        }

        internal function onPause(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            dispatchEvent(new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.PAUSE));
            return;
        }

        internal function onResume(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            dispatchEvent(new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.RESUME));
            return;
        }

        internal function onVolumeChange(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            var loc1:*=new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.VOLUME_CHANGE);
            loc1.dataProvider = arg1.dataProvider;
            dispatchEvent(loc1);
            return;
        }

        internal var headArea:com.glr.vod.components.player.classes.HeadAreaUI;

        internal var controlbar:com.glr.vod.components.player.classes.ControlbarUI;

        internal var scroll:com.glr.vod.components.player.classes.ScrollUI;
    }
}

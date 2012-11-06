package com.glr.vod.components.player.classes.controlbar 
{
    import com.glr.components.*;
    import com.glr.vod.components.player.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
	import com.adobe.utils.*;
    
    public class TrackUI extends com.glr.components.UIComponent
    {
        public function TrackUI(arg1:Object, arg2:Object=null)
        {
            super(arg1, arg2);
            return;
        }

        public override function resize(arg1:flash.geom.Rectangle):void
        {
            var loc1:*=NaN;
            var loc2:*=NaN;
            var loc3:*=NaN;
            if (skin) 
            {
                loc1 = arg1.width - 2 * skin.x;
                if (skin.playLine) 
                {
                    loc2 = skin.playLine / skin.back.width;
                    skin.playLine.width = loc2 * loc1;
                }
                if (skin.loadLine) 
                {
                    loc3 = skin.loadLine / skin.back.width;
                    skin.loadLine.width = loc3 * loc1;
                }
                if (skin.back) 
                {
                    skin.back.width = loc1;
                }
				
				skin.slider.time.visible = false;
				
                this.setVisualTrack();
            }
            return;
        }

        public function set percent(arg1:Object):void
        {
            if (skin.playLine && !this.dragging) 
            {
                skin.playLine.width = skin.back.width * arg1.play;
                if (skin.slider) 
                {
                    skin.slider.visible = true;
                    skin.slider.x = skin.playLine.width;
                }
            }
            return;
        }

        protected override function init():void
        {
            if (skin) 
            {
                skin.buttonMode = true;
                if (skin.slider) 
                {
                    skin.slider.visible = false;
                    skin.slider.mouseEnabled = false;
                    skin.slider.mouseChildren = false;
                }
                if (skin.playLine) 
                {
                    skin.playLine.width = 0;
                    skin.playLine.mouseEnabled = false;
                    skin.playLine.mouseChildren = false;
                }
                if (skin.loadLine) 
                {
                    skin.loadLine.width = 0;
                    skin.loadLine.mouseEnabled = false;
                    skin.loadLine.mouseChildren = false;
                }
                if (skin.back) 
                {
                    skin.back.mouseEnabled = false;
                    skin.back.mouseChildren = false;
                }
				
				
                this.visualTrack = new flash.display.Sprite();
                skin.addChild(this.visualTrack);
                skin.addChild(skin.slider);
                this.setVisualTrack();
                this.addListener();
            }
            return;
        }

        protected function setVisualTrack():void
        {
            if (skin.back) 
            {
                this.visualTrack.x = skin.back.x;
                this.visualTrack.y = skin.back.y;
                this.visualTrack.graphics.clear();
                this.visualTrack.graphics.beginFill(16711680, 0);
                this.visualTrack.graphics.drawRect(0, 0, skin.back.width, skin.back.height);
                this.visualTrack.graphics.endFill();
            }
            return;
        }

        internal function addListener():void
        {
            if (this.visualTrack) 
            {
                this.visualTrack.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onDragStart);
            }
            return;
        }

        internal function onDragStart(arg1:flash.events.MouseEvent):void
        {
			trace("start drag")
			skin.slider.time.visible = true;
			skin.slider.time.text  = com.adobe.utils.TimeUtil.swap2(Math.round((skin.playLine.width/skin.back.width) * this.metadata.duration));
			
            this.dragging = true;
            skin.slider.startDrag(false, new flash.geom.Rectangle(0, skin.slider.y, this.visualTrack.width, 0));
            skin.slider.x = this.visualTrack.mouseX;
            this.onMove();
            this.visualTrack.stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onMove);
            this.visualTrack.stage.addEventListener(flash.events.Event.MOUSE_LEAVE, this.onStopDrag);
            this.visualTrack.stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.onSeekTo);
            return;
        }

        internal function onMove(arg1:flash.events.MouseEvent=null):void
        {
            skin.playLine.width = skin.slider.x;
			
			skin.slider.time.text  = com.adobe.utils.TimeUtil.swap2(Math.round((skin.playLine.width/skin.back.width) * this.metadata.duration))
			
            return;
        }

        internal function onStopDrag(arg1:flash.events.Event):void
        {
			
            this.dragging = false;
            skin.slider.stopDrag();
            this.visualTrack.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onMove);
            this.visualTrack.stage.removeEventListener(flash.events.Event.MOUSE_LEAVE, this.onStopDrag);
            this.visualTrack.stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.onSeekTo);
            return;
        }

        internal function onSeekTo(arg1:flash.events.MouseEvent):void
        {
			
			trace("stop drag")
			skin.slider.time.visible = false;
			
            this.dragging = false;
            skin.slider.stopDrag();
            this.visualTrack.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onMove);
            this.visualTrack.stage.removeEventListener(flash.events.Event.MOUSE_LEAVE, this.onStopDrag);
            this.visualTrack.stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.onSeekTo);
            var loc1:*=this.visualTrack.mouseX / this.visualTrack.width;
            if (loc1 < 0) 
            {
                loc1 = 0;
            }
            else if (loc1 > 1) 
            {
                loc1 = 1;
            }
            var loc2:*=new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.SEEK_TO);
            loc2.dataProvider = loc1;
            dispatchEvent(loc2);
            return;
        }

        internal var visualTrack:flash.display.Sprite;

        internal var dragging:Boolean;
		
		public var metadata;
    }
}

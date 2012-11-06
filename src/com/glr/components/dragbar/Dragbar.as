package com.glr.components.dragbar 
{
    import com.glr.components.*;
    import com.glr.components.error.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    public class Dragbar extends com.glr.components.UIComponent
    {
        public function Dragbar(arg1:Object, arg2:String="horizontal", arg3:Boolean=false)
        {
            this.downSliderPoint = new flash.geom.Point(0, 0);
            this.downLocalPoint = new flash.geom.Point(0, 0);
            this.direction = arg2;
            this.sliderFlag = arg3;
            super(arg1);
            return;
        }

        public override function destroy():void
        {
            var loc1:*;
            super.destroy();
            try 
            {
                com.greensock.TweenLite.killTweensOf(skin.slider);
            }
            catch (e:Error)
            {
            };
            try 
            {
                com.greensock.TweenLite.killTweensOf(skin.maskTrack);
            }
            catch (e:Error)
            {
            };
            this.removeListener();
            this.onTrackUp();
            return;
        }

        public function set height(arg1:Number):void
        {
            skin.track.height = arg1;
            this.virtualTrack.graphics.clear();
            this.virtualTrack.graphics.beginFill(0, 0);
            this.virtualTrack.graphics.drawRect(0, 0, skin.track.width, skin.track.height);
            this.virtualTrack.graphics.endFill();
            return;
        }

        public function set width(arg1:Number):void
        {
            skin.track.width = arg1;
            this.virtualTrack.graphics.clear();
            this.virtualTrack.graphics.beginFill(0, 0);
            this.virtualTrack.graphics.drawRect(0, 0, skin.track.width, skin.track.height);
            this.virtualTrack.graphics.endFill();
            return;
        }

        public function set percent(arg1:Number):void
        {
            if (arg1 < 0) 
            {
                arg1 = 0;
            }
            if (arg1 > 1) 
            {
                arg1 = 1;
            }
            this._percent = arg1;
            this.renderer();
            return;
        }

        public function set sliderPercent(arg1:Number):void
        {
            var loc1:*=0;
            arg1 = 1 - arg1;
            arg1 = arg1 > 0.75 ? 0.75 : arg1;
            if (this.direction != com.glr.components.dragbar.DragbarDirection.VERTICAL) 
            {
                if (this.direction == com.glr.components.dragbar.DragbarDirection.HORIZONTAL) 
                {
                    loc1 = arg1 * skin.track.width;
                    skin.slider.width = loc1 < 50 ? 50 : loc1;
                }
            }
            else 
            {
                loc1 = arg1 * skin.track.height;
                skin.slider.height = loc1 < 50 ? 50 : loc1;
            }
            return;
        }

        public override function set visible(arg1:Boolean):void
        {
            if (skin.visible != arg1) 
            {
                skin.drag = false;
                skin.visible = arg1;
            }
            return;
        }

        public function get hadDrag():Boolean
        {
            var loc1:*;
            try 
            {
                return skin.drag;
            }
            catch (e:Error)
            {
            };
            return false;
        }

        public function get percent():Number
        {
            return this._percent;
        }

        public override function set enabled(arg1:Boolean):void
        {
            if (arg1) 
            {
                skin.mouseChildren = true;
                skin.mouseEnabled = true;
            }
            else 
            {
                skin.mouseChildren = false;
                skin.mouseEnabled = false;
            }
            return;
        }

        public function get useTrackWid():Number
        {
            if (this.sliderFlag) 
            {
                return this.virtualTrack.width - skin.slider.width;
            }
            return this.virtualTrack.width;
        }

        public function get useTrackHei():Number
        {
            if (this.sliderFlag) 
            {
                return this.virtualTrack.height - skin.slider.height;
            }
            return this.virtualTrack.height;
        }

        protected override function init():void
        {
            if (skin.track == null) 
            {
                throw new com.glr.components.error.ComponentError("[Component DragBarUI Error DragBar Has Not Slider]");
            }
            this.virtualTrack = new flash.display.Sprite();
            this.virtualTrack.graphics.clear();
            this.virtualTrack.graphics.beginFill(16711680, 0);
            this.virtualTrack.graphics.drawRect(0, 0, skin.track.width, skin.track.height);
            this.virtualTrack.graphics.endFill();
            this.virtualTrack.x = skin.track.x;
            this.virtualTrack.y = skin.track.y;
            if (skin.slider) 
            {
                skin.slider.buttonMode = true;
            }
            else 
            {
                skin.slider = new flash.display.MovieClip();
            }
            if (skin.maskTrack) 
            {
                skin.maskTrack.mouseEnabled = false;
                skin.maskTrack.mouseChildren = false;
            }
            skin.addChild(this.virtualTrack);
            skin.addChild(skin.slider);
            this.horizontalRect = new flash.geom.Rectangle(skin.track.x, skin.slider.y, this.useTrackWid, 0);
            this.verticalRect = new flash.geom.Rectangle(skin.slider.x, skin.track.y, 0, this.useTrackHei);
            this.addListener();
            return;
        }

        internal function addListener():void
        {
            skin.slider.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onSliderDown);
            this.virtualTrack.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onTrackDown);
            return;
        }

        internal function removeListener():void
        {
            skin.slider.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onSliderDown);
            this.virtualTrack.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onTrackDown);
            if (this.virtualTrack.stage) 
            {
                this.virtualTrack.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onTrackMove);
                this.virtualTrack.stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.onTrackUp);
            }
            return;
        }

        internal function onSliderDown(arg1:flash.events.MouseEvent):void
        {
            this.downLocalPoint = skin.globalToLocal(new flash.geom.Point(arg1.stageX, arg1.stageY));
            this.downSliderPoint = new flash.geom.Point(skin.slider.x, skin.slider.y);
            if (this.direction != com.glr.components.dragbar.DragbarDirection.HORIZONTAL) 
            {
                this.verticalRect = new flash.geom.Rectangle(skin.slider.x, 0, 0, this.useTrackHei);
            }
            else 
            {
                this.horizontalRect = new flash.geom.Rectangle(0, skin.slider.y, this.useTrackWid, 0);
            }
            skin.drag = true;
            skin.slider.drag = true;
            if (this.virtualTrack.stage) 
            {
                this.virtualTrack.stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onTrackMove);
                this.virtualTrack.stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.onTrackUp);
            }
            return;
        }

        internal function onTrackDown(arg1:flash.events.MouseEvent):void
        {
            if (this.virtualTrack.stage) 
            {
                this.virtualTrack.stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.onTrackUp);
            }
            return;
        }

        internal function onTrackMove(arg1:flash.events.MouseEvent):void
        {
            var loc2:*=NaN;
            var loc3:*=NaN;
            var loc4:*=NaN;
            var loc5:*=NaN;
            var loc1:*=skin.globalToLocal(new flash.geom.Point(arg1.stageX, arg1.stageY));
            if (this.direction != com.glr.components.dragbar.DragbarDirection.HORIZONTAL) 
            {
                if (this.direction == com.glr.components.dragbar.DragbarDirection.VERTICAL) 
                {
                    loc4 = loc1.y - this.downLocalPoint.y;
                    if ((loc5 = this.downSliderPoint.y + loc4) < this.verticalRect.y) 
                    {
                        skin.slider.y = this.verticalRect.y;
                    }
                    else if (loc5 > this.verticalRect.y + this.verticalRect.height) 
                    {
                        skin.slider.y = this.verticalRect.y + this.verticalRect.height;
                    }
                    else 
                    {
                        skin.slider.y = loc5;
                    }
                    if (skin.maskTrack) 
                    {
                        skin.maskTrack.height = skin.slider.y - this.virtualTrack.y;
                    }
                    this._percent = (skin.slider.y - this.virtualTrack.y) / this.useTrackHei;
                }
            }
            else 
            {
                loc2 = loc1.x - this.downLocalPoint.x;
                if ((loc3 = this.downSliderPoint.x + loc2) < this.horizontalRect.x) 
                {
                    skin.slider.x = this.horizontalRect.x;
                }
                else if (loc3 > this.horizontalRect.x + this.horizontalRect.width) 
                {
                    skin.slider.x = this.horizontalRect.x + this.horizontalRect.width;
                }
                else 
                {
                    skin.slider.x = loc3;
                }
                if (skin.maskTrack) 
                {
                    skin.maskTrack.width = skin.slider.x - this.virtualTrack.x;
                }
                this._percent = (skin.slider.x - this.virtualTrack.x) / this.useTrackWid;
            }
            if (this._percent < 0) 
            {
                this._percent = 0;
            }
            if (this._percent > 1) 
            {
                this._percent = 1;
            }
            this.sendChange();
            return;
        }

        internal function onTrackUp(arg1:flash.events.MouseEvent=null):void
        {
            if (this.virtualTrack.stage) 
            {
                this.virtualTrack.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onTrackMove);
                this.virtualTrack.stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.onTrackUp);
            }
            var loc1:*=0;
            if (this.direction != com.glr.components.dragbar.DragbarDirection.HORIZONTAL) 
            {
                if (this.direction == com.glr.components.dragbar.DragbarDirection.VERTICAL) 
                {
                    if (!skin.slider.hasOwnProperty("drag") || skin.slider.drag == false) 
                    {
                        loc1 = skin.mouseY;
                        if (loc1 > this.virtualTrack.y + this.useTrackHei) 
                        {
                            loc1 = this.virtualTrack.y + this.useTrackHei;
                        }
                        else if (loc1 < this.virtualTrack.y) 
                        {
                            loc1 = this.virtualTrack.y;
                        }
                        com.greensock.TweenLite.to(skin.slider, DRAGBAR_MOVE_SPEED, {"y":loc1});
                    }
                    else 
                    {
                        loc1 = this.virtualTrack.y + skin.slider.y;
                    }
                    this._percent = loc1 / this.useTrackHei;
                    if (skin.maskTrack) 
                    {
                        com.greensock.TweenLite.to(skin.maskTrack, DRAGBAR_MOVE_SPEED, {"height":loc1 - this.virtualTrack.y});
                    }
                }
            }
            else 
            {
                if (!skin.slider.hasOwnProperty("drag") || skin.slider.drag == false) 
                {
                    loc1 = skin.mouseX;
                    if (loc1 > this.virtualTrack.x + this.useTrackWid) 
                    {
                        loc1 = this.virtualTrack.x + this.useTrackWid;
                    }
                    else if (loc1 < this.virtualTrack.x) 
                    {
                        loc1 = this.virtualTrack.x;
                    }
                    com.greensock.TweenLite.to(skin.slider, DRAGBAR_MOVE_SPEED, {"x":loc1});
                }
                else 
                {
                    loc1 = this.virtualTrack.x + skin.slider.x;
                }
                this._percent = loc1 / this.useTrackWid;
                if (skin.maskTrack) 
                {
                    com.greensock.TweenLite.to(skin.maskTrack, DRAGBAR_MOVE_SPEED, {"width":loc1 - this.virtualTrack.x});
                }
            }
            skin.drag = true;
            skin.slider.drag = false;
            this.sendChange();
            return;
        }

        internal function sendChange():void
        {
            if (skin.txt) 
            {
                skin.txt.text = int(this.percent * 100) + "%";
            }
            var loc1:*=new com.glr.components.dragbar.DragbarEvent(com.glr.components.dragbar.DragbarEvent.CHANGE);
            loc1.percent = this.percent;
            dispatchEvent(loc1);
            return;
        }

        internal function renderer():void
        {
            var loc1:*=NaN;
            var loc2:*=NaN;
            if (this.direction != com.glr.components.dragbar.DragbarDirection.HORIZONTAL) 
            {
                if (this.direction == com.glr.components.dragbar.DragbarDirection.VERTICAL) 
                {
                    loc2 = this.virtualTrack.y + this.percent * this.useTrackHei;
                    com.greensock.TweenLite.to(skin.slider, DRAGBAR_MOVE_SPEED, {"y":loc2});
                    if (skin.maskTrack) 
                    {
                        com.greensock.TweenLite.to(skin.maskTrack, DRAGBAR_MOVE_SPEED, {"height":loc2 - this.virtualTrack.y});
                    }
                }
            }
            else 
            {
                loc1 = this.virtualTrack.x + this.percent * this.useTrackWid;
                com.greensock.TweenLite.to(skin.slider, DRAGBAR_MOVE_SPEED, {"x":loc1});
                if (skin.maskTrack) 
                {
                    com.greensock.TweenLite.to(skin.maskTrack, DRAGBAR_MOVE_SPEED, {"width":loc1 - this.virtualTrack.x});
                }
            }
            if (skin.txt) 
            {
                skin.txt.text = int(this.percent * 100) + "%";
            }
            return;
        }

        public static const DRAGBAR_MOVE_SPEED:Number=0.3;

        internal var direction:String="horizontal";

        internal var sliderFlag:Boolean;

        internal var virtualTrack:flash.display.Sprite;

        internal var horizontalRect:flash.geom.Rectangle;

        internal var verticalRect:flash.geom.Rectangle;

        internal var _percent:Number=0.5;

        internal var downSliderPoint:flash.geom.Point;

        internal var downLocalPoint:flash.geom.Point;
    }
}

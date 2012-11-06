package com.glr.vod.components.player.classes 
{
    import __AS3__.vec.*;
    
    import com.glr.components.*;
    import com.glr.components.dragbar.*;
    import com.glr.vod.components.player.classes.scroll.*;
    import com.glr.vod.model.specail.*;
    import com.greensock.*;
    import com.letv.aiLoader.tools.*;
    
    import flash.events.*;
    import flash.geom.*;
    
    public class ScrollUI extends com.glr.components.UIComponent
    {
        public function ScrollUI(arg1:Object, arg2:Object=null)
        {
            super(arg1, arg2);
            return;
        }

        public override function resize(arg1:flash.geom.Rectangle):void
        {
            if (skin && skin.stage) 
            {
                skin.back.width = arg1.width;
                skin.back.height = arg1.height;
                if (skin.groupMask) 
                {
                    skin.groupMask.x = skin.groupMask.y;
                    skin.groupMask.width = arg1.width;
                    skin.groupMask.height = arg1.height;
                }
                this.groupResize();
            }
            return;
        }

        public function zoomIn():void
        {
            var loc1:*=NaN;
            if (this.scroller) 
            {
                loc1 = skin.group.scaleX + 0.1;
                loc1 = loc1 > 2 ? 2 : loc1;
                var loc2:*;
                skin.group.scaleY = loc2 = loc1;
                skin.group.scaleX = loc2;
                this.groupMiddle();
            }
            return;
        }

        public function zoomOut():void
        {
            var loc1:*=NaN;
            if (this.scroller) 
            {
                loc1 = skin.group.scaleX - 0.1;
                loc1 = loc1 < 0.3 ? 0.3 : loc1;
                var loc2:*;
                skin.group.scaleY = loc2 = loc1;
                skin.group.scaleX = loc2;
                this.groupMiddle();
            }
            return;
        }

        public function set pageData(arg1:Object):void
        {
            var obj:Object;

            var loc1:*;
            obj = arg1;
            this.clearGraphics();
            try 
            {
                com.greensock.TweenLite.killTweensOf(this.scroller);
            }
            catch (e:Error)
            {
            };
            try 
            {
                skin.group.container.removeChild(this.scroller);
            }
            catch (e:Error)
            {
            };
            this.scroller = null;
            try 
            {
                (this.media)["destroy"]();
            }
            catch (e:Error)
            {
            };
            this.media = null;
            if (obj && obj.content) 
            {
                this.media = obj.content;
                if (this.media.content) 
                {
                    this.scroller = this.media.content;
                    try 
                    {
                        this.scroller.mouseEnabled = false;
                    }
                    catch (e:Error)
                    {
                    };
                    try 
                    {
                        this.scroller.mouseChildren = false;
                    }
                    catch (e:Error)
                    {
                    };
                    if (this.scroller) 
                    {
                        skin.group.container.addChild(this.scroller);
                        this.property = new com.glr.vod.components.player.classes.scroll.ScrollProperty(this.scroller);
                        this.groupResize();
                        this.addListener();
                        this.scroller.alpha = 0.5;
                        com.greensock.TweenLite.to(this.scroller, 0.3, {"alpha":1});
                    }
                }
            }
            return;
        }

        public function set penPosition(arg1:Object):void
        {
            if (skin.pen && this.property) 
            {
                skin.pen.visible = arg1.visible;
                if (arg1.visible) 
                {
                    this.pen_xscale = arg1.penScaleX;
                    this.pen_yscale = arg1.penScaleY;
                    skin.pen.x = arg1.penScaleX * skin.group.scaleX * this.property.wid + skin.group.x;
                    skin.pen.y = arg1.penScaleY * skin.group.scaleY * this.property.hei + skin.group.y;
                    if (arg1.color != this._drawColor) 
                    {
                        this.changePenColor(arg1.color);
                    }
                    if (arg1.draw) 
                    {
                        if (this.pen_draw) 
                        {
                            skin.group.canvas.graphics.lineTo(skin.group.container.width * arg1.penScaleX, skin.group.container.height * arg1.penScaleY);
                        }
                        else 
                        {
                            this.pen_draw = true;
                            skin.group.canvas.graphics.lineStyle(5, arg1.color);
                            skin.group.canvas.graphics.moveTo(skin.group.container.width * arg1.penScaleX, skin.group.container.height * arg1.penScaleY);
                        }
                    }
                    else 
                    {
                        this.pen_draw = false;
                        skin.group.canvas.graphics.endFill();
                    }
                }
            }
            return;
        }

        public function set textPen(arg1:Object):void
        {
            var loc1:*=null;
            if (this.textPens == null) 
            {
                this.textPens = new Vector.<com.glr.vod.components.player.classes.scroll.ScrollTextPenItem>();
            }
            if (arg1 && arg1.value && this.property) 
            {
                arg1 = arg1.value;
                loc1 = new com.glr.vod.components.player.classes.scroll.ScrollTextPenItem(arg1);
                loc1.x = loc1.textScaleX * this.property.wid;
                loc1.y = loc1.textScaleY * this.property.hei;
                skin.group.textarea.addChild(loc1);
                this.textPens.push(loc1);
            }
            return;
        }

        public function clearGraphics():void
        {
            var loc1:*;
            try 
            {
                this.pen_draw = false;
            }
            catch (e:Error)
            {
            };
            try 
            {
                skin.group.canvas.graphics.clear();
            }
            catch (e:Error)
            {
            };
            if (this.textPens) 
            {
                while (this.textPens.length > 0 && this.textPens[0]) 
                {
                    this.textPens[0].remove();
                    this.textPens[0] = null;
                    this.textPens.shift();
                }
            }
            this.textPens = null;
            com.letv.aiLoader.tools.GC.gc();
            return;
        }

        public function changePenColor(arg1:Object):void
        {
            this._drawColor = Number(arg1);
            skin.pen.graphics.clear();
            skin.pen.graphics.beginFill(this._drawColor);
            skin.pen.graphics.drawCircle(0, 0, 6);
            skin.pen.graphics.endFill();
            return;
        }

        protected override function init():void
        {
            if (skin) 
            {
                var loc1:*;
                skin.y = loc1 = 0;
                skin.x = loc1;
                skin.group.y = loc1 = 0;
                skin.group.x = loc1;
                skin.pen.visible = false;
                skin.pen.mouseEnabled = false;
                skin.pen.mouseChildren = false;
                skin.group.doubleClickEnabled = true;
                skin.group.canvas.mouseEnabled = false;
                skin.group.canvas.mouseChildren = false;
                skin.group.textarea.mouseEnabled = false;
                skin.group.textarea.mouseChildren = false;
                skin.group.container.mouseEnabled = false;
                skin.group.container.mouseChildren = false;
                if (skin.vdragbar) 
                {
                    skin.vdragbar.visible = false;
                    this.vbar = new com.glr.components.dragbar.Dragbar(skin.vdragbar, com.glr.components.dragbar.DragbarDirection.VERTICAL, true);
                    this.vbar.addEventListener(com.glr.components.dragbar.DragbarEvent.CHANGE, this.onVbarChange);
                }
                this.changePenColor(this._drawColor);
            }
            return;
        }

        protected function get useHei():Number
        {
            return skin.back.height - com.glr.vod.model.specail.Config.C_HEI;
        }

        protected function get useWid():Number
        {
            return skin.back.width;
        }

        internal function onVbarChange(arg1:com.glr.components.dragbar.DragbarEvent):void
        {
            var loc1:*=this.property.hei * skin.group.scaleY;
            skin.group.y = 0 - this.vbar.percent * (loc1 - this.useHei);
            return;
        }

        internal function setVdragbarVisible(arg1:Boolean):void
        {
            var loc1:*=NaN;
            if (this.vbar) 
            {
                skin.vdragbar.visible = arg1;
                if (arg1) 
                {
                    this.vbar.height = (this.useHei - 1);
                    skin.vdragbar.x = (skin.back.width - skin.vdragbar.width - 1);
                    skin.vdragbar.y = 1;
                    loc1 = this.property.hei * skin.group.scaleY;
                    this.vbar.sliderPercent = (loc1 - this.useHei) / loc1;
                    this.vbar.percent = (-skin.group.y) / (loc1 - this.useHei);
                }
            }
            return;
        }

        internal function addListener():void
        {
            if (skin) 
            {
				
				//trace(skin.width);
				skin.group.addEventListener(flash.events.MouseEvent.CLICK, this.onClicked);
                skin.addEventListener(flash.events.MouseEvent.ROLL_OVER, this.onShowDragbar);
                skin.addEventListener(flash.events.MouseEvent.ROLL_OUT, this.onHideDragbar);
            }
            return;
        }

        internal function revemoListener():void
        {
            if (skin) 
            {
                skin.addEventListener(flash.events.MouseEvent.ROLL_OVER, this.onShowDragbar);
                skin.addEventListener(flash.events.MouseEvent.ROLL_OUT, this.onHideDragbar);
            }
            return;
        }

		
		internal function onClicked(e:MouseEvent):void{
			
			dispatchEvent(e);
			
			
		}
		
        internal function groupResize():void
        {
            var loc1:*=NaN;
            if (this.scroller) 
            {
                loc1 = this.useWid / this.property.wid;
                var loc2:*;
                skin.group.scaleY = loc2 = loc1;
                skin.group.scaleX = loc2;
                this.groupMiddle();
            }
            return;
        }

        internal function groupMiddle():void
        {
            var loc1:*=0;
            var loc2:*=0;
            if (this.property) 
            {
                loc1 = this.property.wid * skin.group.scaleX;
                loc2 = this.property.hei * skin.group.scaleY;
                skin.group.x = 0;
                if (skin.group.height > this.useHei) 
                {
                    skin.group.y = 0;
                }
                else 
                {
                    skin.group.y = (this.useHei - loc2) / 2;
                }
                if (skin.pen) 
                {
                    skin.pen.x = this.pen_xscale * skin.group.scaleX * this.property.wid + skin.group.x;
                    skin.pen.y = this.pen_yscale * skin.group.scaleY * this.property.hei + skin.group.y;
                }
                if (loc2 > this.useHei) 
                {
                    this.setVdragbarVisible(true);
                }
                else 
                {
                    this.setVdragbarVisible(false);
                }
            }
            return;
        }

        internal function onShowDragbar(arg1:flash.events.MouseEvent):void
        {
            var event:flash.events.MouseEvent;

            var loc1:*;
            event = arg1;
            try 
            {
                com.greensock.TweenLite.to(skin.vdragbar, 0.5, {"alpha":1});
            }
            catch (e:Error)
            {
            };
            return;
        }

		
		
		
        internal function onHideDragbar(arg1:flash.events.MouseEvent):void
        {
            var event:flash.events.MouseEvent;

            var loc1:*;
            event = arg1;
            try 
            {
                com.greensock.TweenLite.to(skin.vdragbar, 0.5, {"alpha":0});
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal var media:Object;

        internal var scroller:Object;

        internal var _drawColor:Number=16711680;

        internal var property:com.glr.vod.components.player.classes.scroll.ScrollProperty;

        internal var drawing:Boolean;

        internal var textPens:__AS3__.vec.Vector.<com.glr.vod.components.player.classes.scroll.ScrollTextPenItem>;

        internal var hbar:com.glr.components.dragbar.Dragbar;

        internal var vbar:com.glr.components.dragbar.Dragbar;

        internal var pen_xscale:Number=0;

        internal var pen_yscale:Number=0;

        internal var pen_draw:Boolean;
    }
}

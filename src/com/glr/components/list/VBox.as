package com.glr.components.list 
{
    import __AS3__.vec.*;
    import com.glr.components.*;
    import com.glr.components.dragbar.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    
    public class VBox extends com.glr.components.UIComponent
    {
        public function VBox(arg1:Object, arg2:Object, arg3:int=15, arg4:int=200)
        {
            this._gap = arg3;
            this._max = arg4;
            super(arg1, arg2);
            return;
        }

        public function get verticalDragbar():com.glr.components.dragbar.Dragbar
        {
            return this._verticalDragbar;
        }

        public override function destroy():void
        {
            super.destroy();
            this.removeListener();
            this._verticalDragbar.destroy();
            this._verticalDragbar = null;
            return;
        }

        public function set height(arg1:Number):void
        {
            skin.masker.height = arg1;
            this.verticalDragbar.height = arg1;
            this.addItem(null);
            return;
        }

        public function set sort(arg1:uint):void
        {
            var loc1:*=0;
            var loc2:*=NaN;
            var loc3:*=0;
            if (!(arg1 == com.glr.components.list.BoxSort.SORT_BOTTOM) && !(arg1 == com.glr.components.list.BoxSort.SORT_TOP)) 
            {
                return;
            }
            if (arg1 != this._sort) 
            {
                this._sort = arg1;
                if (this.stack) 
                {
                    loc1 = this.stack.length;
                    if (loc1 > 0) 
                    {
                        skin.container.x = 0;
                        skin.container.y = 0;
                        loc2 = 0;
                        if (arg1 != com.glr.components.list.BoxSort.SORT_BOTTOM) 
                        {
                            if (arg1 == com.glr.components.list.BoxSort.SORT_TOP) 
                            {
                                --loc3;
                                while (loc3 >= 0) 
                                {
                                    this.stack[loc3].y = loc2;
                                    skin.container.addChild(this.stack[loc3]);
                                    loc2 = loc2 + (this.stack[loc3].height + this._gap);
                                    --loc3;
                                }
                            }
                        }
                        else 
                        {
                            loc3 = 0;
                            while (loc3 < loc1) 
                            {
                                this.stack[loc3].y = loc2;
                                skin.container.addChild(this.stack[loc3]);
                                loc2 = loc2 + (this.stack[loc3].height + this._gap);
                                ++loc3;
                            }
                        }
                        this.updateDragbarPercent();
                    }
                }
            }
            return;
        }

        public function set dataProvider(arg1:Array):void
        {
            var loc1:*=0;
            var loc2:*=0;
            this.removeAll();
            skin.container.x = 0;
            skin.container.y = 0;
            if (arg1) 
            {
                this.stack = new Vector.<flash.display.DisplayObject>();
                loc1 = arg1.length;
                loc2 = 0;
                while (loc2 < loc1) 
                {
                    this.stack[loc2] = arg1[loc2];
                    this.stack[loc2].y = skin.container.height + this._gap;
                    skin.container.addChild(this.stack[loc2]);
                    ++loc2;
                }
            }
            this.updateDragbarPercent();
            return;
        }

        public function addItem(arg1:Object):void
        {
            var loc1:*=NaN;
            var loc2:*=0;
            var loc3:*=0;
            var loc4:*=NaN;
            var loc5:*=NaN;
            if (this.stack == null) 
            {
                this.stack = new Vector.<flash.display.DisplayObject>();
            }
            if (this._sort != com.glr.components.list.BoxSort.SORT_TOP) 
            {
                if (arg1) 
                {
                    arg1.y = int(this.stack.length != 0 ? skin.container.height + this._gap : skin.container.height);
                    this.stack.push(arg1);
                    skin.container.addChild(arg1);
                }
                loc4 = this.verticalDragbar.percent;
                this.updateDragbarPercent();
                if (this.verticalDragbar.visible && (loc4 >= 0.8 || !this.verticalDragbar.hadDrag)) 
                {
                    this.verticalDragbar.percent = 1;
                    loc5 = skin.masker.y - 1 * (skin.container.height - skin.masker.height);
                    com.greensock.TweenLite.to(skin.container, 0.2, {"y":loc5});
                }
            }
            else 
            {
                if (arg1) 
                {
                    skin.container.x = 0;
                    skin.container.y = 0;
                    this.stack.push(arg1);
                }
                loc1 = 0;
                loc2 = this.stack.length;
                --loc3;
                while (loc3 >= 0) 
                {
                    this.stack[loc3].y = loc1;
                    skin.container.addChild(this.stack[loc3]);
                    loc1 = loc1 + (this.stack[loc3].height + this._gap);
                    --loc3;
                }
                this.updateDragbarPercent();
            }
            return;
        }

        public function removeItemAt(arg1:int):void
        {
            var loc1:*=0;
            var loc2:*=NaN;
            var loc3:*=0;
            if (this.stack[arg1]) 
            {
                skin.container.removeChild(this.stack[arg1]);
                var loc4:*;
                (loc4 = this.stack[arg1])["destroy"]();
                this.stack.splice(arg1, 1);
                loc1 = this.stack.length;
                loc2 = 0;
                loc3 = 0;
                while (loc3 < loc1) 
                {
                    this.stack[loc3].y = loc2;
                    loc2 = loc2 + this.stack[loc3].height;
                    ++loc3;
                }
            }
            if (this.verticalDragbar.visible) 
            {
                if (skin.container.height <= skin.masker.height) 
                {
                    skin.contianer.y = 0;
                }
                else 
                {
                    skin.container.y = skin.container.height - skin.masker.height;
                }
            }
            this.updateDragbarPercent();
            return;
        }

        protected function removeAll():void
        {
            this.verticalDragbar.visible = false;
            if (this.stack) 
            {
                while (this.stack.length > 0) 
                {
                    var loc1:*;
                    (loc1 = this.stack[0])["destroy"]();
                    skin.container.removeChild(this.stack[0]);
                    this.stack[0] = null;
                    this.stack.shift();
                }
            }
            this.stack = null;
            return;
        }

        protected override function init():void
        {
            this._verticalDragbar = new com.glr.components.dragbar.Dragbar(skin.dragbar, com.glr.components.dragbar.DragbarDirection.VERTICAL, true);
            this._verticalDragbar.visible = false;
            this.addListener();
            return;
        }

        internal function addListener():void
        {
            if (skin.container && skin.masker) 
            {
                this.verticalDragbar.addEventListener(com.glr.components.dragbar.DragbarEvent.CHANGE, this.onVerticalDragbarChange);
            }
            if (skin) 
            {
                skin.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.onWheel);
            }
            return;
        }

        internal function onWheel(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=this.verticalDragbar.percent;
            if (arg1.delta > 0) 
            {
                if (this.verticalDragbar.percent > 0) 
                {
                    loc1 = loc1 - 0.02;
                    if (loc1 > 0) 
                    {
                        this.verticalDragbar.percent = loc1;
                    }
                    else 
                    {
                        this.verticalDragbar.percent = 0;
                    }
                }
            }
            else if (this.verticalDragbar.percent < 1) 
            {
                loc1 = loc1 + 0.02;
                if (loc1 < 1) 
                {
                    this.verticalDragbar.percent = loc1;
                }
                else 
                {
                    this.verticalDragbar.percent = 1;
                }
            }
            this.updateContainerPosition();
            return;
        }

        internal function removeListener():void
        {
            this.verticalDragbar.removeEventListener(com.glr.components.dragbar.DragbarEvent.CHANGE, this.onVerticalDragbarChange);
            return;
        }

        internal function onVerticalDragbarChange(arg1:com.glr.components.dragbar.DragbarEvent):void
        {
            if (skin.container == null) 
            {
                return;
            }
            this.updateContainerPosition();
            return;
        }

        internal function updateContainerPosition():void
        {
            skin.container.y = skin.masker.y - this.verticalDragbar.percent * (skin.container.height - skin.masker.height);
            return;
        }

        internal function updateDragbarPercent():void
        {
            if (skin.container.height > skin.masker.height) 
            {
                this.verticalDragbar.visible = true;
                skin.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.onWheel);
                this.verticalDragbar.sliderPercent = (skin.container.height - skin.masker.height) / skin.container.height;
                this.verticalDragbar.percent = (skin.masker.y - skin.container.y) / (skin.container.height - skin.masker.height);
            }
            else 
            {
                this.verticalDragbar.visible = false;
                skin.container.y = 0;
                skin.removeEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.onWheel);
            }
            return;
        }

        protected var _gap:int=10;

        protected var _sort:uint=0;

        protected var _max:int=200;

        protected var _verticalDragbar:com.glr.components.dragbar.Dragbar;

        protected var _masker:flash.display.DisplayObject;

        protected var stack:__AS3__.vec.Vector.<flash.display.DisplayObject>;
    }
}

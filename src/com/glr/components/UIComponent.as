package com.glr.components 
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    
    public class UIComponent extends flash.events.EventDispatcher
    {
        public function UIComponent(arg1:Object, arg2:Object=null)
        {
            super();
            this.skin = arg1 as flash.display.MovieClip;
            this.config = arg2;
            if (this.skin) 
            {
                this.init();
            }
            return;
        }

        public function destroy():void
        {
            this.skin = null;
            return;
        }

        public function set enabled(arg1:Boolean):void
        {
            if (this.skin) 
            {
                if (arg1) 
                {
                    this.skin.mouseEnabled = true;
                    this.skin.mouseChildren = true;
                    this.skin.filters = null;
                    this.skin.alpha = 1;
                }
                else 
                {
                    this.skin.mouseEnabled = false;
                    this.skin.mouseChildren = false;
                    this.skin.filters = [new flash.filters.BlurFilter(5, 5)];
                    this.skin.alpha = 0.8;
                }
            }
            return;
        }

        public function set visible(arg1:Boolean):void
        {
            var flag:Boolean;

            var loc1:*;
            flag = arg1;
            try 
            {
                this.skin.visible = flag;
            }
            catch (e:Error)
            {
            };
            return;
        }

        public function get visible():Boolean
        {
            var loc1:*;
            try 
            {
                return this.skin.visible;
            }
            catch (e:Error)
            {
            };
            return false;
        }

        public function get surface():flash.display.MovieClip
        {
            return this.skin;
        }

        public function resize(arg1:flash.geom.Rectangle):void
        {
            return;
        }

        protected function init():void
        {
            return;
        }

        protected var config:Object;

        public var skin:flash.display.MovieClip;
    }
}

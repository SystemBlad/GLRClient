package com.glr.vod.components.player.classes.scroll 
{
    import flash.text.*;
    
    public class ScrollTextPenItem extends flash.text.TextField
    {
        public function ScrollTextPenItem(arg1:Object)
        {
            super();
            this._textScaleX = arg1[1];
            this._textScaleY = arg1[2];
            this.selectable = false;
            this.wordWrap = true;
            this.mouseEnabled = false;
            this.mouseWheelEnabled = false;
            var loc1:*=new flash.text.TextFormat();
            loc1.size = 16;
            loc1.color = 16711680;
            loc1.font = "Arial";
            this.autoSize = flash.text.TextFieldAutoSize.LEFT;
            this.defaultTextFormat = loc1;
            this.text = String(arg1[0]) + "";
            this.width = 250;
            return;
        }

        public function get textScaleX():Number
        {
            return this._textScaleX;
        }

        public function get textScaleY():Number
        {
            return this._textScaleY;
        }

        public function remove():void
        {
            var loc1:*;
            try 
            {
                parent.removeChild(this);
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal var _textScaleX:Number=0;

        internal var _textScaleY:Number=0;
    }
}

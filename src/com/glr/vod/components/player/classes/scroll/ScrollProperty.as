package com.glr.vod.components.player.classes.scroll 
{
    public class ScrollProperty extends Object
    {
        public function ScrollProperty(arg1:Object)
        {
            super();
            this._wid = arg1.width;
            this._hei = arg1.height;
            this._scale = this._wid / this._hei;
            return;
        }

        public function get scale():Number
        {
            return this._scale;
        }

        public function get wid():Number
        {
            return this._wid;
        }

        public function get hei():Number
        {
            return this._hei;
        }

        internal var _scale:Number=1.333;

        internal var _wid:Number=400;

        internal var _hei:Number=300;
    }
}

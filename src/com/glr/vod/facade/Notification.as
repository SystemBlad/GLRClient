package com.glr.vod.facade 
{
    public class Notification extends Object
    {
        public function Notification(arg1:String, arg2:Object=null)
        {
            super();
            this._name = arg1;
            this._body = arg2;
            return;
        }

        public function get name():String
        {
            return this._name;
        }

        public function get body():Object
        {
            return this._body;
        }

        internal var _name:String;

        internal var _body:Object;
    }
}

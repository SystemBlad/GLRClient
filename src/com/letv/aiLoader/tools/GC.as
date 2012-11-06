package com.letv.aiLoader.tools 
{
    import flash.net.*;
    
    public class GC extends Object
    {
        public function GC()
        {
            super();
            return;
        }

        public static function gc():void
        {
            var loc1:*;
            try 
            {
                new flash.net.LocalConnection().connect("letv");
                new flash.net.LocalConnection().connect("letv");
            }
            catch (e:Error)
            {
            };
            return;
        }
    }
}

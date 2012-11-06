package com.letv.aiLoader.utils 
{
    import flash.external.*;
    
    public class BrowserUtil extends Object
    {
        public function BrowserUtil()
        {
            super();
            return;
        }

        public static function getURL():String
        {
            var value:String;

            var loc1:*;
            value = null;
            try 
            {
                value = flash.external.ExternalInterface.call("function getURL(){return window.location.href;}");
            }
            catch (e:Error)
            {
            };
            return value;
        }
    }
}

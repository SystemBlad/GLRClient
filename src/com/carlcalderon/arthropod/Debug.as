package com.carlcalderon.arthropod 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    
    public class Debug extends Object
    {
        public function Debug()
        {
            super();
            return;
        }

        public static function snapshot(arg1:flash.display.Stage, arg2:String=null):Boolean
        {
            if (arg1) 
            {
                return bitmap(arg1, arg2);
            }
            return false;
        }

        public static function object(arg1:*):Boolean
        {
            return send(OBJECT_OPERATION, arg1, null);
        }

        public static function memory():Boolean
        {
            return send(MEMORY_OPERATION, flash.system.System.totalMemory, null);
        }

        internal static function send(arg1:String, arg2:*, arg3:*):Boolean
        {
            var operation:String;
            var value:*;
            var prop:*;

            var loc1:*;
            operation = arg1;
            value = arg2;
            prop = arg3;
            if (secure) 
            {
                lc.allowDomain(secureDomain);
            }
            else 
            {
                lc.allowInsecureDomain("*");
            }
            if (!hasEventListeners) 
            {
                if (ignoreStatus) 
                {
                    lc.addEventListener(flash.events.StatusEvent.STATUS, ignore);
                }
                else 
                {
                    lc.addEventListener(flash.events.StatusEvent.STATUS, status);
                }
                hasEventListeners = true;
            }
            if (allowLog) 
            {
                try 
                {
                    lc.send(TYPE + "#" + DOMAIN + CHECK + ":" + CONNECTION, operation, password, value, prop);
                    return true;
                }
                catch (e:*)
                {
                    return false;
                }
            }
            return false;
        }

        internal static function status(arg1:flash.events.StatusEvent):void
        {
            trace("Arthropod status:\n" + arg1.toString());
            return;
        }

        internal static function ignore(arg1:flash.events.StatusEvent):void
        {
            return;
        }

        
        {
            password = "CDC309AF";
            RED = 13369344;
            GREEN = 52224;
            BLUE = 6710988;
            PINK = 13369548;
            YELLOW = 13421568;
            LIGHT_BLUE = 52428;
            ignoreStatus = true;
            secure = false;
            secureDomain = "*";
            allowLog = true;
            lc = new flash.net.LocalConnection();
            hasEventListeners = false;
        }

        public static function log(arg1:*, arg2:uint=16711422):Boolean
        {
            return send(LOG_OPERATION, String(arg1), arg2);
        }

        public static function error(arg1:*):Boolean
        {
            return send(ERROR_OPERATION, String(arg1), 13369344);
        }

        public static function warning(arg1:*):Boolean
        {
            return send(WARNING_OPERATION, String(arg1), 13421568);
        }

        public static function clear():Boolean
        {
            return send(CLEAR_OPERATION, 0, 0);
        }

        public static function array(arg1:Array):Boolean
        {
            return send(ARRAY_OPERATION, arg1, null);
        }

        public static function bitmap(arg1:*, arg2:String=null):Boolean
        {
            var loc1:*=new flash.display.BitmapData(100, 100, true, 16777215);
            var loc2:*=new flash.geom.Matrix();
            var loc3:*=100 / (arg1.width >= arg1.height ? arg1.width : arg1.height);
            loc2.scale(loc3, loc3);
            loc1.draw(arg1, loc2, null, null, null, true);
            var loc4:*=new flash.geom.Rectangle(0, 0, Math.floor(arg1.width * loc3), Math.floor(arg1.height * loc3));
            return send(BITMAP_OPERATION, loc1.getPixels(loc4), {"bounds":loc4, "lbl":arg2});
        }

        public static const NAME:String="Debug";

        public static const VERSION:String="0.74";

        internal static const DOMAIN:String="com.carlcalderon.Arthropod";

        internal static const CHECK:String=".161E714B6C1A76DE7B9865F88B32FCCE8FABA7B5.1";

        internal static const TYPE:String="app";

        internal static const CONNECTION:String="arthropod";

        internal static const LOG_OPERATION:String="debug";

        internal static const ERROR_OPERATION:String="debugError";

        internal static const ARRAY_OPERATION:String="debugArray";

        internal static const BITMAP_OPERATION:String="debugBitmapData";

        internal static const OBJECT_OPERATION:String="debugObject";

        internal static const MEMORY_OPERATION:String="debugMemory";

        internal static const CLEAR_OPERATION:String="debugClear";

        internal static const WARNING_OPERATION:String="debugWarning";

        public static var password:String="CDC309AF";

        public static var RED:uint=13369344;

        public static var GREEN:uint=52224;

        public static var BLUE:uint=6710988;

        public static var PINK:uint=13369548;

        public static var YELLOW:uint=13421568;

        public static var LIGHT_BLUE:uint=52428;

        public static var ignoreStatus:Boolean=true;

        public static var secure:Boolean=false;

        public static var secureDomain:String="*";

        public static var allowLog:Boolean=true;

        internal static var lc:flash.net.LocalConnection;

        internal static var hasEventListeners:Boolean=false;
    }
}

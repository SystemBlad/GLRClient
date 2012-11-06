package org.lin.log4j 
{
    import flash.net.*;
    import flash.text.*;
    import org.lin.log4j.errors.*;
    import org.lin.log4j.logTarget.*;
    import org.lin.log4j.logType.*;
    
    public class Log extends Object
    {
        public function Log()
        {
            super();
            return;
        }

        public static function getLog(arg1:String):flash.text.TextField
        {
            if (_pluginLog == null) 
            {
                _pluginLog = {};
            }
            if (!_pluginLog.hasOwnProperty(arg1)) 
            {
                _pluginLog[arg1] = createText();
            }
            return _pluginLog[arg1];
        }

        internal static function createText():flash.text.TextField
        {
            var loc1:*=new flash.text.TextField();
            loc1.wordWrap = true;
            var loc2:*=new flash.text.TextFormat();
            loc2.size = 11;
            loc2.font = "Arial";
            loc2.color = 16777215;
            loc1.defaultTextFormat = loc2;
            return loc1;
        }

        public static function clearLocalLog():void
        {
            var item:String;

            var loc1:*;
            item = null;
            try 
            {
                htmlStr = "";
                var loc2 = 0;
                var loc3:*=_pluginLog;
                for (item in loc3) 
                {
                    if (!_pluginLog[item]) 
                    {
                        continue;
                    }
                    _pluginLog[item].text = "";
                }
            }
            catch (e:Error)
            {
                trace("[Error] In Log.clearLocalLog");
            }
            return;
        }

        public static function getLocalLog():void
        {
            var loc1:*=new Date();
            var loc2:*=loc1.fullYear + "-" + String(loc1.month + 1) + "-" + loc1.date + " ";
            loc2 = loc2 + (loc1.hours + ":" + loc1.minutes + ":" + loc1.seconds + " ");
            var loc3:*=new flash.net.FileReference();
            var loc4:*=(loc4 = (loc4 = (loc4 = (loc4 = (loc4 = (loc4 = (loc4 = (loc4 = (loc4 = (loc4 = (loc4 = "<!DOCTYPE html PUBLIC \'-//W3C//DTD XHTML 1.0 Transitional//EN\' \'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\'><html xmlns=\'http://www.w3.org/1999/xhtml\'>") + "<head><meta http-equiv=\'Content-Type\' content=\'text/html; charset=utf-8\'/>") + "<title>Arthropod Log</title><style type=\'text/css\'>") + "body {background: #151515;font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 15px;color: #fefefe;}") + "#main-container{margin: 10px;clear: both;}") + "#container{background: #252525;border: 1px solid #000;padding: 20px;}") + "#header {font-family: \'Trebuchet MS\', Verdana, Arial, Helvetica, sans-serif;font-size: 25px;font-weight: bold;color: #fefefe;height: 85px;padding: 10px;}") + "</style>") + ("</head><body><div id=\'main-container\'><div id=\'header\'>Letv Log(乐视播放器日志)<br /> Date:" + loc2 + "</div>")) + "<div id=\'container\'>") + (htmlStr + "</div></div>")) + "Author : LinYang  @http://www.finalria.com  Weibo:Final_Ria</body></html>";
            loc3.save(loc4, "letv_log.html");
            return;
        }

        public static function set filter(arg1:Array):void
        {
            if (arg1 == null) 
            {
                throw new org.lin.log4j.errors.LogError(org.lin.log4j.errors.LogError.EXCEPTION);
            }
            _stack = arg1;
            return;
        }

        public static function get filter():Array
        {
            return _stack;
        }

        public static function getLogger(arg1:String="", arg2:String="trace"):org.lin.log4j.ILogger
        {
            var loc1:*=null;
            var loc2:*=arg2;
            switch (loc2) 
            {
                case org.lin.log4j.logType.LogType.TRACE:
                {
                    loc1 = new org.lin.log4j.logTarget.TracerAndDebugger();
                    break;
                }
            }
            loc1.setPackager(arg1);
            return loc1;
        }

        public static function getTimeStr():String
        {
            var loc1:*=new Date();
            var loc2:*="[" + loc1.fullYear + "-" + String(loc1.month + 1) + "-" + loc1.date + " ";
            loc2 = loc2 + (loc1.hours + ":" + loc1.minutes + ":" + loc1.seconds + " ");
            return loc2;
        }

        
        {
            arthropodDebug = true;
            htmlStr = "";
        }

        public static const VERSION:String="1.0.0";

        public static var arthropodDebug:Boolean=true;

        public static var htmlStr:String="";

        internal static var _pluginLog:Object;

        internal static var _stack:Array;
    }
}

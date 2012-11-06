package com.glr.vod.model.specail 
{
    import flash.geom.*;
    
    public class Config extends Object
    {
        public function Config()
        {
            super();
            return;
        }

        
        {
            rootRect = new flash.geom.Rectangle(0, 0, 960, 640);
            maxRect = new flash.geom.Rectangle(0, 0, 1024, 768);
        }

        public static const VERSION:String="GLR.1.2012_10_24_1_Vod";

        public static const CSS:String="a{color:#0066FF;}a:hover{color:#0033FF;text-decoration:underline}";

        public static const VOLUME_MAX:uint=3;

        public static const CHAT_WID:uint=330;

        public static const C_HEI:uint=30;

        public static const DATA:XML=new XML("<root>\r\n\t\t\t\t<media>\r\n\t\t\t\t\t<vod>\r\n\t\t\t\t\t\t<notice>\r\n\t\t\t\t\t\t<![CDATA[欢迎使用过来人公开课平台——直播知识,成就梦想]]>\r\n\t\t\t\t\t\t</notice>\r\n\t\t\t\t\t</vod>\r\n\t\t\t\t</media>\r\n\t\t\t\t<skin><![CDATA[plugins/skin.swf]]></skin>\r\n\t\t\t</root>");

        public static var rootRect:flash.geom.Rectangle;

        public static var maxRect:flash.geom.Rectangle;
    }
}

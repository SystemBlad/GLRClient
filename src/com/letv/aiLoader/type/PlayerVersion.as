package com.letv.aiLoader.type 
{
    import flash.system.*;
    
    public class PlayerVersion extends Object
    {
        public function PlayerVersion()
        {
            super();
            return;
        }

        public static function get support():String
        {
            var loc1:*=flash.system.Capabilities.version;
            loc1 = loc1.split(" ")[1];
            var loc2:*=loc1.split(",");
            var loc3:*=int(loc2[0]);
            var loc4:*=int(loc2[1]);
            if (loc3 >= 10 && loc3 < 11) 
            {
                if (loc4 == 0) 
                {
                    return VERSION_10_0;
                }
                if (loc4 == 1) 
                {
                    return VERSION_10_1;
                }
                if (loc4 >= 2) 
                {
                    return VERSION_10_2;
                }
            }
            else if (loc3 == 11) 
            {
                return VERSION_11;
            }
            return VERSION_INVALID;
        }

        public static function get is_10_0():Boolean
        {
            if (support == VERSION_10_0) 
            {
                return true;
            }
            return false;
        }

        public static function get supportP2P():Boolean
        {
            var loc1:*=support;
            switch (loc1) 
            {
                case VERSION_INVALID:
                case VERSION_10_0:
                {
                    return false;
                }
            }
            return true;
        }

        public static function get supportStageVideo():Boolean
        {
            var loc1:*=support;
            switch (loc1) 
            {
                case VERSION_10_2:
                case VERSION_11:
                {
                    return true;
                }
            }
            return false;
        }

        public static function get supportStage3D():Boolean
        {
            var loc1:*=support;
            switch (loc1) 
            {
                case VERSION_11:
                {
                    return true;
                }
            }
            return false;
        }

        public static const VERSION_INVALID:String="versionInvalid";

        public static const VERSION_10_0:String="version10,0";

        public static const VERSION_10_1:String="version10,1";

        public static const VERSION_10_2:String="version10,2";

        public static const VERSION_11:String="version11";
    }
}

package com.adobe.utils 
{
    public class TimeUtil extends Object
    {
        public function TimeUtil()
        {
            super();
            return;
        }

        public static function swap(arg1:int):String
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*;
            if ((loc3 = int(arg1 / 60)) < 10) 
            {
                loc1 = "0" + loc3 + ":";
            }
            else 
            {
                loc1 = loc3 + ":";
            }
            var loc4:*;
            if ((loc4 = int(arg1 % 60)) < 10) 
            {
                loc2 = "0" + loc4 + "";
            }
            else 
            {
                loc2 = loc4 + "";
            }
            return loc1 + loc2;
        }

        public static function swap2(arg1:int):String
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*;
            if ((loc4 = int(arg1 / 3600)) != 0) 
            {
                if (loc4 < 10) 
                {
                    loc1 = "0" + loc4 + ":";
                }
                else 
                {
                    loc1 = loc4 + ":";
                }
            }
            else 
            {
                loc1 = "";
            }
            var loc5:*=arg1 % 3600;
            if ((loc5 = int(loc5 / 60)) < 10) 
            {
                loc2 = "0" + loc5 + ":";
            }
            else 
            {
                loc2 = loc5 + ":";
            }
            var loc6:*;
            if ((loc6 = int(arg1 % 60)) < 10) 
            {
                loc3 = "0" + loc6 + "";
            }
            else 
            {
                loc3 = loc6 + "";
            }
            return loc1 + loc2 + loc3;
        }

        public static function swapHour(arg1:int):String
        {
            var loc1:*=arg1 <= 9 ? "0" + arg1 : String(arg1);
            return loc1;
        }

        public static function swapMinute(arg1:int):String
        {
            var loc1:*=arg1 <= 9 ? "0" + arg1 : String(arg1);
            return loc1;
        }
    }
}

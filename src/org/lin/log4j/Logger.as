package org.lin.log4j 
{
    import com.carlcalderon.arthropod.*;
    
    public class Logger extends Object implements org.lin.log4j.ILogger
    {
        public function Logger()
        {
            super();
            return;
        }

        protected function get filterFlag():Boolean
        {
            var loc2:*=0;
            var loc3:*=0;
            var loc4:*=null;
            var loc5:*=null;
            var loc6:*=null;
            var loc1:*=org.lin.log4j.Log.filter;
            if (loc1) 
            {
                loc2 = loc1.length;
                if (loc2 == 0) 
                {
                    return false;
                }
                loc3 = 0;
                while (loc3 < loc2) 
                {
                    loc4 = loc1[loc3];
                    if ((loc5 = loc4.charAt((loc4.length - 1))) != ".") 
                    {
                        if (loc5 != "*") 
                        {
                            if (this.packager.indexOf(loc4) != -1) 
                            {
                                if (this.packager.length > loc4.length) 
                                {
                                    if (this.packager.charAt(loc4.length) == ".") 
                                    {
                                        return false;
                                    }
                                }
                                else 
                                {
                                    return false;
                                }
                            }
                        }
                        else 
                        {
                            loc6 = loc4.substr(0, loc4.length - 2);
                            if (this.packager.indexOf(loc6) != -1) 
                            {
                                return false;
                            }
                        }
                    }
                    else 
                    {
                        loc6 = loc4.substr(0, (loc4.length - 1));
                        if (this.packager.indexOf(loc6) != -1) 
                        {
                            return false;
                        }
                    }
                    ++loc3;
                }
            }
            else 
            {
                return false;
            }
            return true;
        }

        protected function sendLog(arg1:String, arg2:String=null, arg3:int=16777215):void
        {
            if (org.lin.log4j.Log.arthropodDebug) 
            {
                com.carlcalderon.arthropod.Debug.log(arg1, arg3);
            }
            org.lin.log4j.Log.htmlStr = org.lin.log4j.Log.htmlStr + ("<div class=\'item\'><div class=\'item-value\'><span style=\'color:#fefefe\' >" + arg1 + "</span></div></div><br />");
            org.lin.log4j.Log.getLog("all").appendText(arg1 + "\n");
            if (arg2) 
            {
                org.lin.log4j.Log.getLog(arg2).appendText(arg1 + "\n");
            }
            return;
        }

        public function setPackager(arg1:String):void
        {
            this.packager = arg1;
            return;
        }

        public function info(arg1:String, arg2:String=null):void
        {
            return;
        }

        public function warn(arg1:String, arg2:String=null):void
        {
            return;
        }

        public function error(arg1:String, arg2:String=null):void
        {
            return;
        }

        public function fault(arg1:String, arg2:String=null):void
        {
            return;
        }

        protected var packager:String;
    }
}

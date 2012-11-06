package org.lin.log4j.errors 
{
    public class LogError extends Error
    {
        public function LogError(arg1:String="", arg2:int=0)
        {
            super(arg1, arg2);
            return;
        }

        public static const EXCEPTION:String="exception";
    }
}

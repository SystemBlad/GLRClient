package com.letv.aiLoader.errors 
{
    public class AIError extends Error
    {
        public function AIError(arg1:*="", arg2:*=0)
        {
            super(arg1, arg2);
            return;
        }

        public function clone():com.letv.aiLoader.errors.AIError
        {
            return new com.letv.aiLoader.errors.AIError(this.message, this.errorID);
        }

        public static const IO_ERROR:int=0;

        public static const TIMEOUT_ERROR:int=1;

        public static const SECURITY_ERROR:int=2;

        public static const ANALY_ERROR:int=3;

        public static const OTHER_ERROR:int=9;
    }
}

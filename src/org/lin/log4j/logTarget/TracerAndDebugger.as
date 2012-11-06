package org.lin.log4j.logTarget 
{
    import org.lin.log4j.*;
    
    public class TracerAndDebugger extends org.lin.log4j.Logger
    {
        public function TracerAndDebugger()
        {
            super();
            return;
        }

        protected override function sendLog(arg1:String, arg2:String=null, arg3:int=16777215):void
        {
            super.sendLog(arg1, arg2, arg3);
            if (!filterFlag) 
            {
                trace(arg1);
            }
            return;
        }

        public override function info(arg1:String, arg2:String=null):void
        {
            arg1 = org.lin.log4j.Log.getTimeStr() + "info] " + arg1;
            this.sendLog(arg1, arg2, this.INFO_COLOR);
            return;
        }

        public override function warn(arg1:String, arg2:String=null):void
        {
            arg1 = org.lin.log4j.Log.getTimeStr() + "warn] " + arg1;
            this.sendLog(arg1, arg2, this.WARN_COLOR);
            return;
        }

        public override function error(arg1:String, arg2:String=null):void
        {
            arg1 = org.lin.log4j.Log.getTimeStr() + "error] " + arg1;
            this.sendLog(arg1, arg2, this.ERROR_COLOR);
            return;
        }

        public override function fault(arg1:String, arg2:String=null):void
        {
            arg1 = org.lin.log4j.Log.getTimeStr() + "fault] " + arg1;
            this.sendLog(arg1, arg2, this.FAULT_COLOR);
            return;
        }

        internal const INFO_COLOR:uint=16777215;

        internal const WARN_COLOR:uint=39423;

        internal const ERROR_COLOR:uint=16750848;

        internal const FAULT_COLOR:uint=16711680;
    }
}

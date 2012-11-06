package com.letv.aiLoader.kernel 
{
    import com.letv.aiLoader.errors.*;
    import com.letv.aiLoader.multiMedia.*;
    import flash.events.*;
    
    public class BaseKernel extends flash.events.EventDispatcher implements com.letv.aiLoader.kernel.IKernel
    {
        public function BaseKernel()
        {
            super();
            return;
        }

        public function destroy():void
        {
            return;
        }

        public function start(arg1:Array):void
        {
            if (arg1 == null || arg1.length <= 0) 
            {
                throw new com.letv.aiLoader.errors.AIError("加载器所需描述信息不完整1");
            }
            this.list = com.letv.aiLoader.multiMedia.AIDataFactory.transformData(arg1);
            if (this.list == null || this.list.length <= 0) 
            {
                throw new com.letv.aiLoader.errors.AIError("加载器所需描述信息不完整2");
            }
            return;
        }

        protected var list:Array;
    }
}

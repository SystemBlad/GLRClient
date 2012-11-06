package com.letv.aiLoader 
{
    import com.letv.aiLoader.events.*;
    import com.letv.aiLoader.kernel.*;
    import com.letv.aiLoader.tools.*;
    import com.letv.aiLoader.type.*;
    import flash.events.*;
    
    public class AILoader extends flash.events.EventDispatcher implements com.letv.aiLoader.IAILoader
    {
        public function AILoader(arg1:String="loadSingle")
        {
            super();
            if (!(arg1 == com.letv.aiLoader.type.LoadOrderType.LOAD_SINGLE) && !(arg1 == com.letv.aiLoader.type.LoadOrderType.LOAD_MULTIPLE)) 
            {
                arg1 = com.letv.aiLoader.type.LoadOrderType.LOAD_SINGLE;
            }
            this._loadOrderType = arg1;
            return;
        }

        public function get loadOrderType():String
        {
            return this._loadOrderType;
        }

        public function destroy():void
        {
            if (this.kernel) 
            {
                this.kernel.destroy();
                this.kernel.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.WHOLE_COMPLETE, this.onAllComplete);
                this.kernel.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onLoadComplete);
                this.kernel.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onLoadError);
                this.kernel.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_STATE_CHANGE, this.onMediaStateChange);
            }
            this.kernel = null;
            com.letv.aiLoader.tools.GC.gc();
            return;
        }

        public function setup(arg1:Array):void
        {
            this.kernel = com.letv.aiLoader.KernelFactory.create(this.loadOrderType);
            this.kernel.addEventListener(com.letv.aiLoader.events.AILoaderEvent.WHOLE_COMPLETE, this.onAllComplete);
            this.kernel.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onLoadComplete);
            this.kernel.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onLoadError);
            this.kernel.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_STATE_CHANGE, this.onMediaStateChange);
            this.kernel.start(arg1);
            return;
        }

        internal function onAllComplete(arg1:com.letv.aiLoader.events.AILoaderEvent):void
        {
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.WHOLE_COMPLETE);
            loc1.dataProvider = arg1.dataProvider;
            this.dispatchEvent(loc1);
            return;
        }

        internal function onLoadComplete(arg1:com.letv.aiLoader.events.AILoaderEvent):void
        {
			
			
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, arg1.sourceType, arg1.index, arg1.retry);
            loc1.dataProvider = arg1.dataProvider;
            this.dispatchEvent(loc1);
            return;
        }

        internal function onLoadError(arg1:com.letv.aiLoader.events.AILoaderEvent):void
        {
			
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, arg1.sourceType, arg1.index, arg1.retry);
            loc1.dataProvider = arg1.dataProvider;
            loc1.errorCode = arg1.errorCode;
            loc1.infoCode = arg1.infoCode;
            this.dispatchEvent(loc1);
            return;
        }

        internal function onMediaStateChange(arg1:com.letv.aiLoader.events.AILoaderEvent):void
        {
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_STATE_CHANGE, arg1.sourceType, arg1.index, arg1.retry);
            loc1.dataProvider = arg1.dataProvider;
            loc1.infoCode = arg1.infoCode;
            loc1.errorCode = arg1.errorCode;
            this.dispatchEvent(loc1);
            return;
        }

        public static const VERSION:String="1.0.0";

        protected var kernel:com.letv.aiLoader.kernel.IKernel;

        internal var _loadOrderType:String="loadSingle";
    }
}

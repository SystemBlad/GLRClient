package com.letv.aiLoader.kernel 
{
    import com.letv.aiLoader.events.*;
    import com.letv.aiLoader.multiMedia.*;
    
    public class MultiPleKernel extends com.letv.aiLoader.kernel.BaseKernel
    {
        public function MultiPleKernel()
        {
            super();
            return;
        }

        public override function destroy():void
        {
            var loc3:*=null;
            if (this.mediaStack == null) 
            {
                return;
            }
            var loc1:*=this.mediaStack.length;
            var loc2:*=0;
            while (loc2 < loc1) 
            {
                loc3 = this.mediaStack[loc2];
                if (loc3) 
                {
                    loc3.destroy();
                    loc3.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onMediaComplete);
                    loc3.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onMediaError);
                    loc3.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_STATE_CHANGE, this.onMediaStateChange);
                }
                ++loc2;
            }
            this.mediaStack = null;
            list = null;
            return;
        }

        public override function start(arg1:Array):void
        {
            super.start(arg1);
            this.loopAll();
            return;
        }

        internal function removeListener():void
        {
            var loc3:*=null;
            if (this.mediaStack == null) 
            {
                return;
            }
            var loc1:*=this.mediaStack.length;
            var loc2:*=0;
            while (loc2 < loc1) 
            {
                loc3 = this.mediaStack[loc2];
                if (loc3) 
                {
                    loc3.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onMediaComplete);
                    loc3.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onMediaError);
                    loc3.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_STATE_CHANGE, this.onMediaStateChange);
                }
                ++loc2;
            }
            return;
        }

        internal function loopAll():void
        {
            var loc3:*=null;
            var loc1:*=list.length;
            if (this.mediaStack == null) 
            {
                this.mediaStack = [];
            }
            var loc2:*=0;
            while (loc2 < loc1) 
            {
                loc3 = com.letv.aiLoader.multiMedia.AIDataFactory.createMedia(loc2, list[loc2]);
                if (loc3 != null) 
                {
                    this.mediaStack.push(loc3);
                    loc3.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onMediaComplete);
                    loc3.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onMediaError);
                    loc3.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_STATE_CHANGE, this.onMediaStateChange);
                    loc3.start();
                }
                ++loc2;
            }
            return;
        }

        internal function addNums():void
        {
            var loc1:*=null;
            var loc2:*;
            var loc3:*=((loc2 = this).count + 1);
            loc2.count = loc3;
            if (this.count >= list.length) 
            {
                this.removeListener();
                loc1 = new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.WHOLE_COMPLETE);
                loc1.dataProvider = this.mediaStack;
                this.dispatchEvent(loc1);
            }
            return;
        }

        internal function onMediaComplete(arg1:com.letv.aiLoader.events.AILoaderEvent):void
        {
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, arg1.sourceType, arg1.index, arg1.retry);
            loc1.dataProvider = arg1.dataProvider;
            this.dispatchEvent(loc1);
            this.addNums();
            return;
        }

        internal function onMediaError(arg1:com.letv.aiLoader.events.AILoaderEvent):void
        {
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, arg1.sourceType, arg1.index, arg1.retry);
            loc1.dataProvider = arg1.dataProvider;
            loc1.infoCode = arg1.infoCode;
            loc1.errorCode = arg1.errorCode;
            this.dispatchEvent(loc1);
            this.addNums();
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

        internal var mediaStack:Array;

        internal var count:int;
    }
}

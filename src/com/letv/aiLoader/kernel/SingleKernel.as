package com.letv.aiLoader.kernel 
{
    import com.letv.aiLoader.errors.*;
    import com.letv.aiLoader.events.*;
    import com.letv.aiLoader.multiMedia.*;
    
    public class SingleKernel extends com.letv.aiLoader.kernel.BaseKernel
    {
        public function SingleKernel()
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
            this.loop();
            return;
        }

        internal function loop():void
        {
			
			trace("loop");
            var loc1:*=null;
            var loc2:*;
            var loc3:*=((loc2 = this).currentIndex + 1);
            loc2.currentIndex = loc3;
            if (list == null) 
            {
                return;
            }
            if (this.currentIndex == list.length) 
            {
                loc1 = new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.WHOLE_COMPLETE);
                loc1.dataProvider = this.mediaStack;
                this.dispatchEvent(loc1);
                return;
            }
            if (list[this.currentIndex] == null) 
            {
                throw new com.letv.aiLoader.errors.AIError("加载器所需描述信息单元为空,资源长度：" + list.length);
            }
            this.media = com.letv.aiLoader.multiMedia.AIDataFactory.createMedia(this.currentIndex, list[this.currentIndex]);
			
			
			
            if (this.media == null) 
            {
                this.loop();
            }
            if (this.mediaStack == null) 
            {
                this.mediaStack = [];
            }
            this.mediaStack.push(this.media);
            this.media.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onMediaComplete);
            this.media.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onMediaError);
            this.media.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_STATE_CHANGE, this.onMediaStateChange);
            this.media.start();
            return;
        }

        internal function onMediaComplete(arg1:com.letv.aiLoader.events.AILoaderEvent):void
        {
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, arg1.sourceType, arg1.index, arg1.retry);
            loc1.dataProvider = arg1.dataProvider;
			
			this.dispatchEvent(loc1);
			
            this.loop();
            return;
        }

        internal function onMediaError(arg1:com.letv.aiLoader.events.AILoaderEvent):void
        {
            var loc1:*=new com.letv.aiLoader.events.AILoaderEvent(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, arg1.sourceType, arg1.index, arg1.retry);
            loc1.dataProvider = arg1.dataProvider;
            loc1.infoCode = arg1.infoCode;
            loc1.errorCode = arg1.errorCode;
            this.dispatchEvent(loc1);
            this.loop();
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

        internal var currentIndex:int=-1;

        internal var media:com.letv.aiLoader.multiMedia.IMedia;

        internal var mediaStack:Array;
    }
}

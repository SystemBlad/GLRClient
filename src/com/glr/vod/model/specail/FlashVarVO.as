package com.glr.vod.model.specail 
{
    import com.letv.aiLoader.utils.*;
    
    public class FlashVarVO extends Object
    {
        public function FlashVarVO()
        {
            super();
            return;
        }

        public function flush(arg1:Object):void
        {
            var loc1:*=null;
            if (arg1) 
            {
                var loc2:*=0;
                var loc3:*=arg1;
                for (loc1 in loc3) 
                {
                    if (!this.hasOwnProperty(loc1)) 
                    {
                        continue;
                    }
                    this[loc1] = arg1[loc1];
                }
            }
            this.url = com.letv.aiLoader.utils.BrowserUtil.getURL();
            return;
        }

        public static function getInstance():com.glr.vod.model.specail.FlashVarVO
        {
            if (_instance == null) 
            {
                _instance = new FlashVarVO();
            }
            return _instance;
        }

        public var appid:String;

        public var url:String;

        internal static var _instance:com.glr.vod.model.specail.FlashVarVO;
    }
}

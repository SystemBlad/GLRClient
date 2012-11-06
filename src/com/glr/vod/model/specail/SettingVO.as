package com.glr.vod.model.specail 
{
    public class SettingVO extends Object
    {
        public function SettingVO()
        {
            this.beforeAction = [];
            super();
            return;
        }

        public static function getInstance():com.glr.vod.model.specail.SettingVO
        {
            if (_instance == null) 
            {
                _instance = new SettingVO();
            }
            return _instance;
        }

        public var volume:Number=1;

        public var flv:String;

        public var totalPage:int;

        public var currentPage:int;

        public var currentUrl:String;

        public var action:Array;

        public var beforeAction:Array;

        public var delayAction:Array;

        internal static var _instance:com.glr.vod.model.specail.SettingVO;
    }
}

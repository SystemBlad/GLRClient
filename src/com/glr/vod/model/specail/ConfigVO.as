package com.glr.vod.model.specail 
{
    import flash.system.*;
    
    public class ConfigVO extends Object
    {
        public function ConfigVO()
        {
            super();
            return;
        }

        public function flush(arg1:XML):void
        {
            var xml:XML;

            var loc1:*;
            xml = arg1;
            if (xml == null) 
            {
                xml = com.glr.vod.model.specail.Config.DATA;
            }
            try 
            {
                this._notice = String(xml.media[0].vod[0].notice[0]);
            }
            catch (e:Error)
            {
                _notice = null;
            }
            return;
        }

        public function initRemote(arg1:Object):void
        {
            if (arg1.hasOwnProperty("uid")) 
            {
                this.userid = arg1["uid"];
            }
            if (arg1.hasOwnProperty("uname")) 
            {
                this.username = arg1["uname"];
            }
            if (arg1.hasOwnProperty("avatar")) 
            {
                this.avatar = arg1["avatar"];
            }
            if (arg1.hasOwnProperty("space")) 
            {
                this.space = arg1["space"];
            }
            if (arg1.hasOwnProperty("flv_path")) 
            {
                this.flv_path = arg1["flv_path"];
            }
            if (arg1.hasOwnProperty("action_path")) 
            {
                this.action_path = arg1["action_path"];
            }
            return;
        }

        public function get notice():Object
        {
            return this._notice;
        }

        public static function getInstance():com.glr.vod.model.specail.ConfigVO
        {
            if (_instance == null) 
            {
                _instance = new ConfigVO();
            }
            return _instance;
        }

        public var skinDomain:flash.system.ApplicationDomain;

        internal var _notice:Object;

        public var username:String;

        public var userid:String;

        public var avatar:String;

        public var space:String;

        public var avatar_t:String;

        public var space_t:String;

        public var flv_path:String;

        public var action_path:String;

        internal static var _instance:com.glr.vod.model.specail.ConfigVO;
    }
}

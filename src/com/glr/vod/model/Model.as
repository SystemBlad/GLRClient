package com.glr.vod.model 
{
    import com.glr.vod.model.specail.*;
    
    public class Model extends Object
    {
        public function Model()
        {
            this.flashvars = com.glr.vod.model.specail.FlashVarVO.getInstance();
            this.config = com.glr.vod.model.specail.ConfigVO.getInstance();
            this.setting = com.glr.vod.model.specail.SettingVO.getInstance();
            super();
            return;
        }

        public function initFlashVars(arg1:Object):void
        {
            this.flashvars.flush(arg1);
            return;
        }

        public function initConfig(arg1:XML):void
        {
            this.config.flush(arg1);
            return;
        }

        public function initRemote(arg1:Object):void
        {
            this.config.initRemote(arg1);
            return;
        }

        public function set list(arg1:Object):void
        {
            this.setting.action = arg1 as Array;
            return;
        }

        public function set action(arg1:Object):void
        {
            var loc1:*=false;
            var loc2:*=NaN;
            var loc3:*=null;
            var loc4:*=NaN;
            var loc5:*=0;
            var loc6:*=null;
            this.setting.action = arg1 as Array;
            if (this.setting.action && this.setting.action.length > 0) 
            {
                loc2 = 0;
                loc3 = APP_DISCONNECT;
                loc4 = 0;
                loc5 = 0;
                while (loc5 < this.setting.action.length) 
                {
                    if (this.setting.action[loc5].type != APP_DISCONNECT) 
                    {
                        if (this.setting.action[loc5].type != APP_CONNECT) 
                        {
                            if (this.setting.action[loc5].type != STREAM_START) 
                            {
                                if (loc1) 
                                {
                                    if (loc3 != APP_DISCONNECT) 
                                    {
                                        if (loc3 == STREAM_START) 
                                        {
                                            this.setting.action[loc5].valid = true;
                                            this.setting.action[loc5].time = (loc4 + this.setting.action[loc5].time - loc2) / 1000;
                                        }
                                    }
                                    else 
                                    {
                                        this.setting.action[loc5].valid = true;
                                        this.setting.action[loc5].time = loc4 / 1000;
                                    }
                                }
                                else 
                                {
                                    if ((loc6 = this.setting.action.splice(loc5, 1)[0]).type == "onSendMsg" || loc6.type == "page") 
                                    {
                                        this.setting.beforeAction.push(loc6);
                                    }
                                    --loc5;
                                }
                            }
                            else 
                            {
                                loc1 = true;
                                if (loc3 == STREAM_START && loc2 > 0) 
                                {
                                    loc4 = loc4 + (this.setting.action[loc5].time - loc2);
                                }
                                loc3 = STREAM_START;
                                loc2 = this.setting.action[loc5].time;
                                this.setting.action.splice(loc5, 1);
                                --loc5;
                            }
                        }
                        else 
                        {
                            this.setting.action.splice(loc5, 1);
                            --loc5;
                        }
                    }
                    else 
                    {
                        if (loc3 == STREAM_START && loc2 > 0) 
                        {
                            loc4 = loc4 + (this.setting.action[loc5].time - loc2);
                        }
                        loc3 = APP_DISCONNECT;
                        this.setting.action.splice(loc5, 1);
                        --loc5;
                    }
                    ++loc5;
                }
            }
            return;
        }

        public static const APP_CONNECT:String="appConnect";

        public static const APP_DISCONNECT:String="appDisconnect";

        public static const STREAM_START:String="streamRecordStart";

        public var flashvars:com.glr.vod.model.specail.FlashVarVO;

        public var config:com.glr.vod.model.specail.ConfigVO;

        public var setting:com.glr.vod.model.specail.SettingVO;
    }
}

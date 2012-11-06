package com.letv.aiLoader.multiMedia 
{
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    
    public interface IMedia extends flash.events.IEventDispatcher
    {
        function destroy():void;

        function start(arg1:String=null):void;

        function get domain():flash.system.ApplicationDomain;

        function get index():int;

        function get rect():flash.geom.Rectangle;

        function get url():String;

        function get size():int;

        function get speed():int;

        function get utime():int;

        function get resourceType():String;

        function get content():Object;

        function get hadError():Boolean;

        function mute(arg1:Number=1):void;

        function pause():Boolean;

        function resume():void;

        function set visible(arg1:Boolean):void;
    }
}

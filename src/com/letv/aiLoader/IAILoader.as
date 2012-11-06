package com.letv.aiLoader 
{
    import flash.events.*;
    
    public interface IAILoader extends flash.events.IEventDispatcher
    {
        function setup(arg1:Array):void;

        function destroy():void;

        function get loadOrderType():String;
    }
}

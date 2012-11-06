package org.lin.log4j 
{
    public interface ILogger
    {
        function setPackager(arg1:String):void;

        function info(arg1:String, arg2:String=null):void;

        function warn(arg1:String, arg2:String=null):void;

        function error(arg1:String, arg2:String=null):void;

        function fault(arg1:String, arg2:String=null):void;
    }
}

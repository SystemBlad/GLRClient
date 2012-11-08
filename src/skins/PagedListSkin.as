package skins
{
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;

import mx.core.DPIClassification;
import mx.core.ScrollPolicy;
import mx.events.FlexEvent;
import mx.events.TouchInteractionEvent;

import spark.events.IndexChangeEvent;
import spark.events.RendererExistenceEvent;
import spark.skins.mobile.ListSkin;
import spark.skins.mobile.supportClasses.MobileSkin;

public class PagedListSkin extends ListSkin
{
    private var pageIndicator:Sprite;
    private var indicatorSize:uint;
    private var _isHorizontal:Boolean;
    private var _suspendPageIndicatorShortcut:Boolean;
    
    public function PagedListSkin()
    {
        super();
        
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                indicatorSize = 32;
                break;
            }
            case DPIClassification.DPI_240:
            {
                indicatorSize = 24;
                break;
            }
            default:
            {
                indicatorSize = 16;
                break;
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    override protected function createChildren():void
    {
        super.createChildren();
        
        scroller.setStyle("skinClass", PagedListScrollerSkin);
        
        // page indicator
        pageIndicator = new Sprite();
        
        // TODO (jasonsj): extend pageIndicator hit area to use the entire 
        // width/height of the List as a shortcut. Currently this only works
        // in the tiny area where the indicators are.
        //pageIndicator.addEventListener(MouseEvent.MOUSE_DOWN, pageIndicaterMouseHandler);
        //pageIndicator.addEventListener(MouseEvent.MOUSE_UP, pageIndicaterMouseHandler);
        //pageIndicator.addEventListener(MouseEvent.MOUSE_MOVE, pageIndicaterMouseHandler);
        
        addChild(pageIndicator);
        
        // listen for changes to the list
        dataGroup.addEventListener(FlexEvent.UPDATE_COMPLETE, dataGroupUpdateComplete);
        scroller.addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START, touchInteractionStart);
        scroller.addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END, positionChanged);
    }

    override protected function commitProperties():void
    {
        super.commitProperties();
        
        // isHorizontal
        var hScrollPolicy:Boolean = getStyle("horizontalScrollPolicy") == ScrollPolicy.ON;
        var vScrollPolicy:Boolean = getStyle("verticalScrollPolicy") == ScrollPolicy.ON;
        _isHorizontal = hScrollPolicy && !vScrollPolicy;
    }
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.drawBackground(unscaledWidth, unscaledHeight);
        
        var pos:Number = (isHorizontal) ? scroller.viewport.horizontalScrollPosition :
            scroller.viewport.verticalScrollPosition;
        var viewportSize:Number = (isHorizontal) ? scroller.viewport.width :
            scroller.viewport.height;
        
        var selectedIndex:int = Math.round(pos / viewportSize);
        var numElements:int = dataGroup.numElements;
        
        var g:Graphics = pageIndicator.graphics;
        g.clear();
        
        var axisPos:Number = 0;
        var centerPos:Number = indicatorSize / 2;
        var radius:Number = indicatorSize / 4;
        var selectionColor:Number = getStyle("selectionColor");
        
        for (var i:uint = 0; i < numElements; i++)
        {
            if (i == selectedIndex)
                g.beginFill(selectionColor, 1);
            else
                g.beginFill(0, .25);
            
            if (isHorizontal)
                g.drawCircle(axisPos + centerPos, centerPos, radius);
            else
                g.drawCircle(centerPos, axisPos + centerPos, radius);
            
            g.endFill();
            
            axisPos += indicatorSize;
        }
        
        var pageIndicatorX:Number = (isHorizontal) ? (unscaledWidth - axisPos) / 2 :
            unscaledWidth - (indicatorSize * 1.5);
        var pageIndicatorY:Number = (isHorizontal) ? unscaledHeight - (indicatorSize * 1.5):
            (unscaledHeight - axisPos) / 2;
        
        setElementPosition(pageIndicator, Math.floor(pageIndicatorX), Math.floor(pageIndicatorY));
    }
    
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
        
        var allStyles:Boolean = !styleProp || styleProp == "styleName";
        
        if (allStyles || styleProp == "horizontalScrollPolicy" ||
            styleProp == "verticalScrollPolicy")
        {
            invalidateProperties();
            invalidateDisplayList();
        }
    }
    
    private function get isHorizontal():Boolean
    {
        return _isHorizontal;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    private function dataGroupUpdateComplete(event:FlexEvent):void
    {
        invalidateDisplayList();
    }
    
    private function touchInteractionStart(event:TouchInteractionEvent):void
    {
        _suspendPageIndicatorShortcut = true;
    }
    
    private function positionChanged(event:TouchInteractionEvent):void
    {
        invalidateDisplayList();
        _suspendPageIndicatorShortcut = false;
    }
    
    private function pageIndicaterMouseHandler(event:MouseEvent):void
    {
        event.preventDefault();
        
        if (_suspendPageIndicatorShortcut)
            return;
        
        // Mouse events on the pageIndicator sprite will jump to the selected page
        var pos:Number = (isHorizontal) ? event.localX : event.localY;
        var size:Number = (isHorizontal) ? pageIndicator.width : pageIndicator.height;
        
        pos = Math.min(Math.max(pos, 0), size) - (indicatorSize / 2);
        
        var viewportSize:Number = (isHorizontal) ? scroller.viewport.width : scroller.viewport.height;
        viewportSize = viewportSize * dataGroup.numElements;
        
        var viewportPosition:Number = (pos / size) * viewportSize;
        
        if (isHorizontal)
            scroller.viewport.horizontalScrollPosition = viewportPosition;
        else
            scroller.viewport.verticalScrollPosition = viewportPosition;
    }
}
}
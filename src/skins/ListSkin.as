////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package skins
{   
	import mx.core.ClassFactory;
	import mx.core.DPIClassification;
	
	import renderers.StyledIconItemRenderer;
	
	import spark.components.DataGroup;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalLayout;
	import spark.skins.mobile.ListSkin;
	
	public class ListSkin extends spark.skins.mobile.ListSkin
	{
		public function ListSkin()
		{
			super();
			
			switch (applicationDPI)
			{
				case DPIClassification.DPI_320:
				{
					padding = 20;
					break;
				}
				case DPIClassification.DPI_240:
				{
					padding = 15;
					break;
				}
				default:
				{
					// default DPI_160
					padding = 10;
					break;
				}
			}
		}
		
		private var padding:Number;
		
		override protected function createChildren():void
		{
			// Create the DataGroup and layout here. super.createChildren()
			// will check for an existing dataGroup and use it.
			var layout:VerticalLayout = new VerticalLayout();
			layout.requestedMinRowCount = 5;
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.gap = 0;
			
			// Add padding
			layout.paddingTop = layout.paddingBottom = layout.paddingLeft = layout.paddingRight = padding;
			
			dataGroup = new DataGroup();
			dataGroup.layout = layout;
			dataGroup.itemRenderer = new ClassFactory(StyledIconItemRenderer);
			
			super.createChildren();
		}
	}
}
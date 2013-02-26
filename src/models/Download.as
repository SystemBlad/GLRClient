package models
{
	import classes.Constants;
	import classes.DataManager;
	import classes.DownloadStatus;
	import classes.Utils;
	
	import events.DownloadChangeEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class Download extends EventDispatcher
	{
		public var subject:String;
		public var editing:Boolean = false;
		
		public var picUrl:String;
		public var avatarUrl:String;
		
		private var flvUrl:String;
		private var actionUrl:String;
		
		private var _description:String;
		private var _percentage:Number = 0;
		private var _status:Number;
		private var currentSize:Number;
		
		private var _kvideoid:Number;
		private var _courseid:Number;
		private var loader:URLLoader;
		private var jsonLoader:URLLoader;
		
		private var _loadedBytes:Number = 0;
		private var _picBytes:Number;
		private var _flvBytes:Number;
		private var _actionBytes:Number;
		
		
		//need store one because the work of getting this is onerous;
		private var _swfList:Array;
		private var currentSwfLoaderIndex:int = 0;
		private var _swfBytes:Number = 0;
		private var firstPageUrl:String;
		private var isActionDownload:Boolean = false;
		private var currentContentSize:Number;
		
		
		
		public function Download(kvideoid:Number, courseid:Number)
		{
			_kvideoid = kvideoid;
			_courseid = courseid;
			
			_status = DownloadStatus.NONE;
			addEventListener(DownloadChangeEvent.name, handleChange);
			
			loader = new URLLoader();
			loader.addEventListener(Event.OPEN, loaderOpenHandler);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			
			jsonLoader = new URLLoader();
			jsonLoader.addEventListener(Event.COMPLETE, jsonLoaded);
		}
		
		public function get kvideoid():Number {return _kvideoid;}
		public function get courseid():Number {return _courseid;}
		public function get status():Number {return _status;}
		public function get totalBytes():Number {
			
			
			return _picBytes + _flvBytes  + _swfBytes;
		}
		
		private function jsonLoaded(event:Event):void
		{
			var json:String = String(jsonLoader.data);
			var obj:Object = JSON.parse(json);
			this.flvUrl = obj.flv_path;
			this.actionUrl = obj.action_path;
			
			
			/***********************save config json!!**********************/
			obj.flv_path = this.buildLocalUrlViaUrl(obj.flv_path)
			obj.action_path = this.buildLocalUrlViaUrl(obj.action_path);
			
			var configJson:String = JSON.stringify(obj);
			
			var name:String = courseid + '/config.txt';
			var file:File = File.documentsDirectory.resolvePath(name);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(configJson);
			stream.close();
			
			/***************************************************************/
			
			calculateNext();
		}
		
		/***************************utils******************************/
		
		
		private function getFileNameViaUrl(fileurl:String):String{
			
			var strArr:Array = fileurl.split("/");
			return strArr[strArr.length-1];
			
		}
		
		private function buildLocalUrlViaUrl(fileurl:String):String{
			
			var file:File = File.documentsDirectory;
			var path:String = file.url + "/" + courseid + "/" +getFileNameViaUrl(fileurl);
			
			return path;
			
		}
		
		//only use this function once, and this function will change it parameter permanently!!!!
		private function getCoursePageURLList(actionObj:Object):Array{
			
			var swfList:Array = new Array();
			
			for(var item in actionObj)
			{
				if(actionObj[item].hasOwnProperty("value"))
				{
					if(actionObj[item].value.hasOwnProperty("url"))
					{
						var url:String = actionObj[item].value.url;
						swfList.push(url);
						actionObj[item].value.url = buildLocalUrlViaUrl(actionObj[item].value.url);
					}
				}
			}
			removeRepeat(swfList);
			return swfList;
			
		}
		
		private function removeRepeat(data:Array):void{
			for(var i:int=0; i<data.length;i++){
				for(var j:int=i+1; j<data.length; j++){
					if(data[i]==data[j]){
						data.splice(j,1);
						j--;
					}
				}
			}
		}
		
		
		private function calculateCoursePage():void{
			
			if(currentSwfLoaderIndex<_swfList.length)
			{
				loader.addEventListener(ProgressEvent.PROGRESS, swfCalculatedHandler);	
				loader.load(new URLRequest(_swfList[currentSwfLoaderIndex]));
			}
			else
			{
				
				currentSwfLoaderIndex = 0;	
				isActionDownload = true;
				calculateNext();
				
			}
			
			
		}
		
		private function swfCalculatedHandler(e:ProgressEvent):void{
			
			_swfBytes += e.bytesTotal;
			loader.removeEventListener(ProgressEvent.PROGRESS, swfCalculatedHandler);
			currentSwfLoaderIndex ++;
			calculateCoursePage();
			
		}
		
		private function downloadAction():void{
			var url:String;
			
			loader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(Event.COMPLETE, actionLoaderCompleteHandler);
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			url = actionUrl;
			var request:URLRequest = new URLRequest();
			request.url = url;
			loader.load(request);
			
		}
		
		private function actionLoaderCompleteHandler(e:Event):void{
			loader.removeEventListener(Event.COMPLETE, actionLoaderCompleteHandler);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			
			//what a shitting output from the service???
			var json:String =  "["+ String(loader.data).substr(1) + "]";
			
			var obj:Object = JSON.parse(json);
			_swfList = getCoursePageURLList(obj);
			firstPageUrl = _swfList[0];	
			
			//save action file here
			var actionJson:String = JSON.stringify(obj);
			var name:String = courseid + '/' +this.getFileNameViaUrl(this.actionUrl);
			var file:File = File.documentsDirectory.resolvePath(name);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(actionJson);
			stream.close();
			
			calculateCoursePage();
			
		}
		
		
		/**************************************************************/
		
		
		private function handleChange(event:DownloadChangeEvent):void
		{
			_description = '';
			if (event.loadedBytes && event.totalBytes) {
				_description = Utils.getFileSize(event.loadedBytes) + '/' + Utils.getFileSize(event.totalBytes);
				_percentage = event.loadedBytes * 100 / event.totalBytes;
			}
			else if (status < DownloadStatus.DOWNLOAD_PIC) {
				_description = '正在准备下载';
			}
			else if (status == DownloadStatus.COMPLETED) {
				_description = '已完成下载';
				DataManager.instance.insertCourse(Constants.TYPE_DOWNLOAD, subject, kvideoid, courseid, picUrl, avatarUrl);
			}
			dispatchEvent(new Event('downloadDescriptionEvent'));
		}
		
		[Bindable(event="downloadDescriptionEvent")]
		public function get statusDescription():String
		{
			return _description;
		}
		
		[Bindable(event="downloadDescriptionEvent")]
		public function get downloadPercentage():Number
		{
			return _percentage;
		}
		
		[Bindable(event="downloadDescriptionEvent")]
		public function get leftPercentage():Number
		{
			return 100 - _percentage;
		}
		
		public function start():void
		{
			_status = DownloadStatus.INITIALIZED;
			dispatchEvent(new DownloadChangeEvent());
			
			var url:String = 'http://www.glr.cn/appapi/app_course_view.php?appid=' + courseid + '&token=' + DataManager.instance.user.token;
			var req:URLRequest = new URLRequest(url);
			jsonLoader.load(req);
		}
		
		private function calculateNext():void
		{
			if (_status == DownloadStatus.CALCULATE_FLV&&!isActionDownload) {
				
				downloadAction();
				return;
			}
			
			_status++;
			var url:String;
			switch (_status)
			{
				case DownloadStatus.CALCULATE_PIC:
					loader.dataFormat = URLLoaderDataFormat.BINARY;
					url = picUrl;
					break;
				case DownloadStatus.CALCULATE_FLV:
					loader.dataFormat = URLLoaderDataFormat.BINARY;
					url = flvUrl;
					break;
				
				case DownloadStatus.CALCULATE_SWFS:
					
					loader.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
					downloadNext();
					return;
					
			}
			loader.addEventListener(ProgressEvent.PROGRESS, calculateProgressHandler);
			
			var request:URLRequest = new URLRequest();
			request.url = url;
			loader.load(request);
		}
		
		private function downloadNext():void
		{
			if(_status<DownloadStatus.DOWNLOAD_SWFS)
				_status++;
			var url:String;
			switch (_status)
			{
				case DownloadStatus.DOWNLOAD_PIC:
					
					loader.dataFormat = URLLoaderDataFormat.BINARY;
					url = picUrl;
					break;
				case DownloadStatus.DOWNLOAD_FLV:
					
					loader.dataFormat = URLLoaderDataFormat.BINARY;
					url = flvUrl;
					break;
				
				case DownloadStatus.DOWNLOAD_SWFS:
					//_status = DownloadStatus.DOWNLOAD_SWFS;
					
					loader.dataFormat = URLLoaderDataFormat.BINARY;
					if(this.currentSwfLoaderIndex == 0)
					{
						url = firstPageUrl;
					}
					else
					{
						
						url = this._swfList[currentSwfLoaderIndex];
					}
					break;
				
			}
			
			var request:URLRequest = new URLRequest();
			request.url = url;
			loader.load(request);
		}
		
		public function pause():void
		{
		}
		
		public function resume():void
		{
			
		}
		
		public function cancel():void
		{
			loader.close();
			_status = DownloadStatus.CANCELLED;
		}
		
		private function save():void
		{
			var name:String;
			switch (_status)
			{
				case DownloadStatus.DOWNLOAD_PIC:
					name = courseid + '/cover.jpg';
					break;
				case DownloadStatus.DOWNLOAD_FLV:
					name = courseid + '/' + this.getFileNameViaUrl(this.flvUrl);
					break;
				case DownloadStatus.DOWNLOAD_SWFS:
					name = courseid + "/" +getFileNameViaUrl(this._swfList[currentSwfLoaderIndex-1]);
					break;
			}
			var file:File = File.documentsDirectory.resolvePath(name);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(loader.data);
			stream.close();
		}
		
		private function loaderOpenHandler(event:Event):void
		{
			
		}
		
		private function calculateProgressHandler(event:ProgressEvent):void
		{
			switch (status) {
				case DownloadStatus.CALCULATE_PIC:
					_picBytes = event.bytesTotal;
					break;
				case DownloadStatus.CALCULATE_FLV:
					_flvBytes = event.bytesTotal;
					break;
				
			}
			
			loader.removeEventListener(ProgressEvent.PROGRESS, calculateProgressHandler);
			calculateNext();
		}
		
		private function loaderProgressHandler(event:ProgressEvent):void
		{
			//trace(_loadedBytes + event.bytesLoaded, totalBytes);
			currentContentSize = event.bytesTotal;
			var evt:DownloadChangeEvent = new DownloadChangeEvent(_loadedBytes + event.bytesLoaded, totalBytes);
			dispatchEvent(evt);
		}
		
		private function loaderCompleteHandler(event:Event):void
		{
			switch (status) {
				case DownloadStatus.DOWNLOAD_PIC:
					_loadedBytes += _picBytes;
					break;
				case DownloadStatus.DOWNLOAD_FLV:
					_loadedBytes += _flvBytes;
					break;
				case DownloadStatus.DOWNLOAD_SWFS:
					
					
					
					_loadedBytes += currentContentSize;
					currentSwfLoaderIndex ++;
					
					break;
			}
			if(currentSwfLoaderIndex<=this._swfList.length)
				save();
			
			// start download other content
			if (_status == DownloadStatus.DOWNLOAD_SWFS&&currentSwfLoaderIndex>=this._swfList.length) {
				_status = DownloadStatus.COMPLETED;
				var evt:DownloadChangeEvent = new DownloadChangeEvent();
				evt.status = _status;
				dispatchEvent(evt);
			}
			else {
				
				downloadNext();
			}
		}
	}
}
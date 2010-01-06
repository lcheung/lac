package app.core.utl{

        import flash.events.Event;
        import flash.events.EventDispatcher;
        import flash.events.IEventDispatcher;
        import flash.net.URLLoader;
        import flash.net.URLRequest;
        import flash.utils.Proxy;
        import flash.utils.flash_proxy;
       
        dynamic public class Settings extends Proxy implements IEventDispatcher {
               
                public static const INIT:String = 'init';
                private static var __instance:Settings;
                private var eventDispatcher:EventDispatcher;
                private var data:XML;
                private var urlLoader:URLLoader;
               
                public function get isLoaded():Boolean {
                        return data != null;
                }
               
                public function Settings(enforcer:SingletonEnforcer) {
                        eventDispatcher = new EventDispatcher();
                }
               
                private function onXMLDataLoaded(event:Event):void {
                        data = XML(urlLoader.data);
                        dispatchEvent(new Event(Settings.INIT, true, true));
                }
               
                public static function get instance ():Settings{
                        if(Settings.__instance == null) {
                                Settings.__instance = new Settings(new SingletonEnforcer());
                        }
                        return Settings.__instance;
                }
               
                /**
                 * @depricated
                 **/
                public static function getInstance():Settings {
                        return instance;       
                }
               
                flash_proxy override function getProperty(name:*):* {
                        var temp_data:XMLList = data.property.(@id == String(name));
                        switch(temp_data.@type.toString())
                        {
                            case 'string':
                                return temp_data.toString();
                                break;
                            case 'number':
                                return Number(temp_data);
                                break;
                            case 'array':
                                var temp_array:Array = temp_data.toString().split(',');
                                return temp_array;
                                break;
                            default:
                                return temp_data;
                                break;
                        }
                }
               
                public function loadSettings(url:String):void {
                        var urlRequest:URLRequest = new URLRequest(url);
                        urlLoader = new URLLoader();
                        urlLoader.addEventListener(Event.COMPLETE, onXMLDataLoaded, false, 0, true);
                        urlLoader.load(urlRequest);
                }
               
                public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void {
                        eventDispatcher.addEventListener(type, listener, useCapture, priority, weakRef);
                }
               
                public function dispatchEvent(event:Event):Boolean {
                        return eventDispatcher.dispatchEvent(event);
                }
               
                public function hasEventListener(type:String):Boolean {
                        return eventDispatcher.hasEventListener(type);
                }
               
                public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
                        eventDispatcher.removeEventListener(type, listener, useCapture);
                }
               
                public function willTrigger(type:String):Boolean {
                        return eventDispatcher.willTrigger(type);
                }
               
        }
       
}

class SingletonEnforcer {}
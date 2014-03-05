package lib 
{
	/**
	 * ...
	 * @author Brett Slabaugh
	 * Each Layer is a sprite added to Stage
	 * Adding elements to the layers = adding child elements
	 */
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	public class LayerManager 
	{
		private static var m_layermanager:LayerManager;
		private static var m_layerDictionary:Dictionary;
		private static var m_pStage:Stage;
		public static function get stage():Stage { return m_pStage };
		
		public static function init( stage:Stage ):void
		{
			m_layerDictionary = new Dictionary();
			m_pStage = stage;
			
			if ( !m_pStage )
			{
				trace("Stager is null");
			}
		}
		
		public static function addLayer( layerName:String ):void
		{
			if (m_layerDictionary)
			{
				var newLayer:Sprite = new Sprite();
				m_layerDictionary[layerName] = newLayer;
				m_pStage.addChild( newLayer );
			}
		}
		
		public static function removeLayer(layerName:String):void
		{
			if (m_layerDictionary)
			{
				if (m_layerDictionary[layerName])
				{
					delete m_layerDictionary[layerName];
				}else {
					trace("Layer doesn't exist");
				}
			}else {
				trace("Initialize Layermanager");
			}
		}
		
		public static function addToLayer( objectToAdd:DisplayObject, layerToAddTo:String ):void
		{
			if (m_layerDictionary)
			{
				m_layerDictionary[layerToAddTo].addChild(objectToAdd);
			}
		}
		
		public static function removeFromLayer(objectToRemove:DisplayObject, layer:String):void
		{
			if (m_layerDictionary)
			{
				m_layerDictionary[layer].removeChild(objectToRemove);
			}
		}
		
		public static function removeFromParent(objectToRemove:DisplayObject):void
		{
			if (m_layerDictionary)
			{
				objectToRemove.parent.removeChild(objectToRemove);
			}
		}
	}

}
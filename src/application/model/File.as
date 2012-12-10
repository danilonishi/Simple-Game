package application.model 
{
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class File 
	{
		public var id:String = null;
		public var name:String = null;
		public var path:String = null;
		public var loaderType:String = null;
		public var loadedData:FileData;
		public var isLoaded:Boolean = false;
		
		public function File() 
		{
			loadedData = new FileData();
		}
		
	}
	
}

internal class FileData
{
	public var data:String;
	public var object:*;
}
package application.model 
{
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class FileList 
	{
		public var files:Vector.<File> = null;
		
		public function FileList() 
		{
			files = new Vector.<File>();
		}
		
		public function getFileByID(id:String):File
		{
			for (var i:uint = 0; i < files.length; i++)
			{
				if (files[i].id == id) {
					return files[i];
				}
			}
			throw new Error("FileList::getFileByID: id \"" + id + "\" not found on \"files\"");
		}
		
	}

}
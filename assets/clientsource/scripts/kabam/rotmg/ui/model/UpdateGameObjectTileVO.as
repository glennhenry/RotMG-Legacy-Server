package kabam.rotmg.ui.model
{
   import com.company.assembleegameclient.objects.GameObject;
   
   public class UpdateGameObjectTileVO
   {
      
      public var tileX:int;
      
      public var tileY:int;
      
      public var gameObject:GameObject;
      
      public function UpdateGameObjectTileVO(param1:int, param2:int, param3:GameObject)
      {
         super();
         this.tileX = param1;
         this.tileY = param2;
         this.gameObject = param3;
      }
   }
}


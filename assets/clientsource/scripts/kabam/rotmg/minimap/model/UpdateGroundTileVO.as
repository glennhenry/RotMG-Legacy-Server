package kabam.rotmg.minimap.model
{
   public class UpdateGroundTileVO
   {
      
      public var tileX:int;
      
      public var tileY:int;
      
      public var tileType:uint;
      
      public function UpdateGroundTileVO(param1:int, param2:int, param3:uint)
      {
         super();
         this.tileX = param1;
         this.tileY = param2;
         this.tileType = param3;
      }
   }
}


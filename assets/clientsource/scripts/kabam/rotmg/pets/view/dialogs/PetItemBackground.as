package kabam.rotmg.pets.view.dialogs
{
   import com.company.util.GraphicsUtil;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   
   public class PetItemBackground extends Sprite
   {
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(5526612);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      public function PetItemBackground(param1:int, param2:Array)
      {
         super();
         var _loc3_:Vector.<IGraphicsData> = new <IGraphicsData>[this.backgroundFill_,this.path_,GraphicsUtil.END_FILL];
         GraphicsUtil.drawCutEdgeRect(0,0,param1,param1,param1 / 12,param2,this.path_);
         graphics.drawGraphicsData(_loc3_);
      }
   }
}


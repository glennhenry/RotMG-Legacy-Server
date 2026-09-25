package kabam.rotmg.pets.view.components
{
   import com.company.util.GraphicsUtil;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathWinding;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class FeedFuseArrow extends Sprite
   {
      
      private var designFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var designPath_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>(),GraphicsPathWinding.NON_ZERO);
      
      private const designGraphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.designFill_,this.designPath_,GraphicsUtil.END_FILL];
      
      public function FeedFuseArrow()
      {
         super();
         this.setColor(6710886);
      }
      
      public function setColor(param1:uint) : void
      {
         graphics.clear();
         GraphicsUtil.clearPath(this.designPath_);
         this.designFill_.color = param1;
         this.drawArrow();
         GraphicsUtil.drawRect(26,11.5,24,19,this.designPath_);
         graphics.drawGraphicsData(this.designGraphicsData_);
      }
      
      public function highlight(param1:Boolean) : void
      {
         var _loc2_:ColorTransform = transform.colorTransform;
         _loc2_.color = param1 ? 16777103 : 5526612;
         transform.colorTransform = _loc2_;
      }
      
      private function drawArrow() : void
      {
         this.designPath_.moveTo(0,20);
         this.designPath_.lineTo(26,0);
         this.designPath_.lineTo(26,40);
         this.designPath_.lineTo(0,20);
         graphics.drawGraphicsData(this.designGraphicsData_);
      }
   }
}


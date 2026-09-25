package kabam.rotmg.util.components
{
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import org.osflash.signals.Signal;
   
   public class RadioButton extends Sprite
   {
      
      public const changed:Signal = new Signal(Boolean);
      
      private const WIDTH:int = 28;
      
      private const HEIGHT:int = 28;
      
      private var unselected:Shape;
      
      private var selected:Shape;
      
      public function RadioButton()
      {
         super();
         addChild(this.unselected = this.makeUnselected());
         addChild(this.selected = this.makeSelected());
         this.setSelected(false);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this.unselected.visible = !param1;
         this.selected.visible = param1;
         this.changed.dispatch(param1);
      }
      
      private function makeUnselected() : Shape
      {
         var _loc1_:Shape = new Shape();
         this.drawOutline(_loc1_.graphics);
         return _loc1_;
      }
      
      private function makeSelected() : Shape
      {
         var _loc1_:Shape = new Shape();
         this.drawOutline(_loc1_.graphics);
         this.drawFill(_loc1_.graphics);
         return _loc1_;
      }
      
      private function drawOutline(param1:Graphics) : void
      {
         var _loc2_:GraphicsSolidFill = new GraphicsSolidFill(0,0.01);
         var _loc3_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
         var _loc4_:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,_loc3_);
         var _loc5_:GraphicsPath = new GraphicsPath();
         GraphicsUtil.drawCutEdgeRect(0,0,this.WIDTH,this.HEIGHT,4,GraphicsUtil.ALL_CUTS,_loc5_);
         var _loc6_:Vector.<IGraphicsData> = new <IGraphicsData>[_loc4_,_loc2_,_loc5_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
         param1.drawGraphicsData(_loc6_);
      }
      
      private function drawFill(param1:Graphics) : void
      {
         var _loc2_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
         var _loc3_:GraphicsPath = new GraphicsPath();
         GraphicsUtil.drawCutEdgeRect(4,4,this.WIDTH - 8,this.HEIGHT - 8,2,GraphicsUtil.ALL_CUTS,_loc3_);
         var _loc4_:Vector.<IGraphicsData> = new <IGraphicsData>[_loc2_,_loc3_,GraphicsUtil.END_FILL];
         param1.drawGraphicsData(_loc4_);
      }
   }
}


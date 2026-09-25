package kabam.rotmg.util.components
{
   import com.company.rotmg.graphics.StarGraphic;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class StarsView extends Sprite
   {
      
      private static const TOTAL:int = 5;
      
      private static const MARGIN:int = 4;
      
      private static const CORNER:int = 15;
      
      private static const BACKGROUND_COLOR:uint = 2434341;
      
      private static const EMPTY_STAR_COLOR:uint = 8618883;
      
      private static const FILLED_STAR_COLOR:uint = 16777215;
      
      private const stars:Vector.<StarGraphic> = this.makeStars();
      
      private const background:Sprite = this.makeBackground();
      
      public function StarsView()
      {
         super();
      }
      
      private function makeStars() : Vector.<StarGraphic>
      {
         var _loc1_:Vector.<StarGraphic> = this.makeStarList();
         this.layoutStars(_loc1_);
         return _loc1_;
      }
      
      private function makeStarList() : Vector.<StarGraphic>
      {
         var _loc1_:Vector.<StarGraphic> = new Vector.<StarGraphic>(TOTAL,true);
         var _loc2_:int = 0;
         while(_loc2_ < TOTAL)
         {
            _loc1_[_loc2_] = new StarGraphic();
            addChild(_loc1_[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function layoutStars(param1:Vector.<StarGraphic>) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < TOTAL)
         {
            param1[_loc2_].x = MARGIN + param1[0].width * _loc2_;
            param1[_loc2_].y = MARGIN;
            _loc2_++;
         }
      }
      
      private function makeBackground() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         this.drawBackground(_loc1_.graphics);
         addChildAt(_loc1_,0);
         return _loc1_;
      }
      
      private function drawBackground(param1:Graphics) : void
      {
         var _loc2_:StarGraphic = this.stars[0];
         var _loc3_:int = _loc2_.width * TOTAL + 2 * MARGIN;
         var _loc4_:int = _loc2_.height + 2 * MARGIN;
         param1.clear();
         param1.beginFill(BACKGROUND_COLOR);
         param1.drawRoundRect(0,0,_loc3_,_loc4_,CORNER,CORNER);
         param1.endFill();
      }
      
      public function setStars(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < TOTAL)
         {
            this.updateStar(_loc2_,param1);
            _loc2_++;
         }
      }
      
      private function updateStar(param1:int, param2:int) : void
      {
         var _loc3_:StarGraphic = this.stars[param1];
         var _loc4_:ColorTransform = _loc3_.transform.colorTransform;
         _loc4_.color = param1 < param2 ? FILLED_STAR_COLOR : EMPTY_STAR_COLOR;
         _loc3_.transform.colorTransform = _loc4_;
      }
   }
}


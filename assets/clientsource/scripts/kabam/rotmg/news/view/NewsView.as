package kabam.rotmg.news.view
{
   import flash.display.Sprite;
   import kabam.rotmg.news.model.NewsCellVO;
   
   public class NewsView extends Sprite
   {
      
      private const LARGE_CELL_WIDTH:Number = 306;
      
      private const LARGE_CELL_HEIGHT:Number = 194;
      
      private const SMALL_CELL_WIDTH:Number = 151;
      
      private const SMALL_CELL_HEIGHT:Number = 189;
      
      private const SPACER:Number = 4;
      
      private const cellOne:NewsCell = new NewsCell(this.LARGE_CELL_WIDTH,this.LARGE_CELL_HEIGHT);
      
      private const cellTwo:NewsCell = new NewsCell(this.SMALL_CELL_WIDTH,this.SMALL_CELL_HEIGHT);
      
      private const cellThree:NewsCell = new NewsCell(this.SMALL_CELL_WIDTH,this.SMALL_CELL_HEIGHT);
      
      public function NewsView()
      {
         super();
         this.tabChildren = false;
         this.addChildren();
         this.positionChildren();
      }
      
      private function addChildren() : void
      {
         addChild(this.cellOne);
         addChild(this.cellTwo);
         addChild(this.cellThree);
      }
      
      private function positionChildren() : void
      {
         this.cellTwo.y = this.LARGE_CELL_HEIGHT + this.SPACER;
         this.cellThree.x = this.SMALL_CELL_WIDTH + this.SPACER;
         this.cellThree.y = this.LARGE_CELL_HEIGHT + this.SPACER;
      }
      
      internal function update(param1:Vector.<NewsCellVO>) : void
      {
         this.cellOne.init(param1[0]);
         this.cellTwo.init(param1[1]);
         this.cellThree.init(param1[2]);
         this.cellOne.load();
         this.cellTwo.load();
         this.cellThree.load();
      }
   }
}


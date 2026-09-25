package kabam.rotmg.friends.view
{
   import com.company.ui.BaseSimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.game.view.components.TabBackground;
   import kabam.rotmg.game.view.components.TabConstants;
   import kabam.rotmg.game.view.components.TabTextView;
   import kabam.rotmg.game.view.components.TabView;
   import org.osflash.signals.Signal;
   
   public class FriendTabView extends Sprite
   {
      
      public const tabSelected:Signal = new Signal(String);
      
      private const TAB_WIDTH:int = 120;
      
      private const TAB_HEIGHT:int = 30;
      
      private const tabSprite:Sprite = new Sprite();
      
      private const background:Sprite = new Sprite();
      
      private const containerSprite:Sprite = new Sprite();
      
      public var tabs:Vector.<TabView> = new Vector.<TabView>();
      
      public var currentTabIndex:int;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var contents:Vector.<Sprite> = new Vector.<Sprite>();
      
      public function FriendTabView(param1:Number, param2:Number)
      {
         super();
         this._width = param1;
         this._height = param2;
         this.tabSprite.addEventListener(MouseEvent.CLICK,this.onTabClicked);
         addChild(this.tabSprite);
         this.drawBackground();
         addChild(this.containerSprite);
      }
      
      public function destroy() : void
      {
         while(numChildren > 0)
         {
            this.removeChildAt(numChildren - 1);
         }
         this.tabSprite.removeEventListener(MouseEvent.CLICK,this.onTabClicked);
         this.tabs = null;
         this.contents = null;
      }
      
      public function addTab(param1:BaseSimpleText, param2:Sprite) : void
      {
         var _loc3_:int = int(this.tabs.length);
         var _loc4_:TabView = this.addTextTab(_loc3_,param1 as BaseSimpleText);
         this.tabs.push(_loc4_);
         this.tabSprite.addChild(_loc4_);
         param2.y = this.TAB_HEIGHT + 5;
         this.contents.push(param2);
         this.containerSprite.addChild(param2);
         if(_loc3_ > 0)
         {
            param2.visible = false;
         }
         else
         {
            _loc4_.setSelected(true);
            this.showContent(0);
            this.tabSelected.dispatch(param2.name);
         }
      }
      
      public function clearTabs() : void
      {
         var _loc1_:uint = 0;
         this.currentTabIndex = 0;
         var _loc2_:uint = this.tabs.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.tabSprite.removeChild(this.tabs[_loc1_]);
            this.containerSprite.removeChild(this.contents[_loc1_]);
            _loc1_++;
         }
         this.tabs = new Vector.<TabView>();
         this.contents = new Vector.<Sprite>();
      }
      
      public function removeTab() : void
      {
      }
      
      public function setSelectedTab(param1:uint) : void
      {
         this.selectTab(this.tabs[param1]);
      }
      
      public function showTabBadget(param1:uint, param2:int) : void
      {
         var _loc3_:TabView = this.tabs[param1];
         (_loc3_ as TabTextView).setBadge(param2);
      }
      
      private function onTabClicked(param1:MouseEvent) : void
      {
         this.selectTab(param1.target.parent as TabView);
      }
      
      private function selectTab(param1:TabView) : void
      {
         var _loc2_:TabView = null;
         if(param1)
         {
            _loc2_ = this.tabs[this.currentTabIndex];
            if(_loc2_.index != param1.index)
            {
               _loc2_.setSelected(false);
               param1.setSelected(true);
               this.showContent(param1.index);
               this.tabSelected.dispatch(this.contents[param1.index].name);
            }
         }
      }
      
      private function addTextTab(param1:int, param2:BaseSimpleText) : TabTextView
      {
         var _loc4_:TabTextView = null;
         var _loc3_:Sprite = new TabBackground(this.TAB_WIDTH,this.TAB_HEIGHT);
         _loc4_ = new TabTextView(param1,_loc3_,param2);
         _loc4_.x = param1 * (param2.width + 12);
         _loc4_.y = 4;
         return _loc4_;
      }
      
      private function showContent(param1:int) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         if(param1 != this.currentTabIndex)
         {
            _loc2_ = this.contents[this.currentTabIndex];
            _loc3_ = this.contents[param1];
            _loc2_.visible = false;
            _loc3_.visible = true;
            this.currentTabIndex = param1;
         }
      }
      
      private function drawBackground() : void
      {
         var _loc1_:GraphicsSolidFill = new GraphicsSolidFill(TabConstants.BACKGROUND_COLOR,1);
         var _loc2_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
         var _loc3_:Vector.<IGraphicsData> = new <IGraphicsData>[_loc1_,_loc2_,GraphicsUtil.END_FILL];
         GraphicsUtil.drawCutEdgeRect(0,0,this._width,this._height - TabConstants.TAB_TOP_OFFSET,6,[1,1,1,1],_loc2_);
         this.background.graphics.drawGraphicsData(_loc3_);
         this.background.y = TabConstants.TAB_TOP_OFFSET;
         addChild(this.background);
      }
   }
}


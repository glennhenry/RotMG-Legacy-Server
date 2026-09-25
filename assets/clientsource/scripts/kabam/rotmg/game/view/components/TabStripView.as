package kabam.rotmg.game.view.components
{
   import com.company.assembleegameclient.objects.ImageFactory;
   import com.company.assembleegameclient.ui.icons.IconButton;
   import com.company.assembleegameclient.ui.icons.IconButtonFactory;
   import com.company.ui.BaseSimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.Bitmap;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   
   public class TabStripView extends Sprite
   {
      
      public var iconButtonFactory:IconButtonFactory;
      
      public var imageFactory:ImageFactory;
      
      public const tabSelected:Signal = new Signal(String);
      
      public const WIDTH:Number = 186;
      
      public const HEIGHT:Number = 153;
      
      private const tabSprite:Sprite = new Sprite();
      
      private const background:Sprite = new Sprite();
      
      private const containerSprite:Sprite = new Sprite();
      
      private var _width:Number;
      
      private var _height:Number;
      
      public var tabs:Vector.<TabView> = new Vector.<TabView>();
      
      private var contents:Vector.<Sprite> = new Vector.<Sprite>();
      
      public var currentTabIndex:int;
      
      public var friendsBtn:IconButton;
      
      public function TabStripView(param1:Number = 186, param2:Number = 153)
      {
         super();
         this._width = param1;
         this._height = param2;
         this.tabSprite.addEventListener(MouseEvent.CLICK,this.onTabClicked);
         addChild(this.tabSprite);
         this.drawBackground();
         addChild(this.containerSprite);
         this.containerSprite.y = TabConstants.TAB_TOP_OFFSET;
      }
      
      public function initFriendList(param1:ImageFactory, param2:IconButtonFactory, param3:Function) : void
      {
         this.friendsBtn = param2.create(param1.getImageFromSet("lofiInterfaceBig",13),"",TextKey.OPTIONS_FRIEND,"");
         this.friendsBtn.x = 160;
         this.friendsBtn.y = 6;
         this.friendsBtn.addEventListener(MouseEvent.CLICK,param3);
         addChild(this.friendsBtn);
      }
      
      private function onTabClicked(param1:MouseEvent) : void
      {
         this.selectTab(param1.target.parent as TabView);
      }
      
      public function setSelectedTab(param1:uint) : void
      {
         this.selectTab(this.tabs[param1]);
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
      
      public function drawBackground() : void
      {
         var _loc1_:GraphicsSolidFill = new GraphicsSolidFill(TabConstants.BACKGROUND_COLOR,1);
         var _loc2_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
         var _loc3_:Vector.<IGraphicsData> = new <IGraphicsData>[_loc1_,_loc2_,GraphicsUtil.END_FILL];
         GraphicsUtil.drawCutEdgeRect(0,0,this._width,this._height - TabConstants.TAB_TOP_OFFSET,6,[1,1,1,1],_loc2_);
         this.background.graphics.drawGraphicsData(_loc3_);
         this.background.y = TabConstants.TAB_TOP_OFFSET;
         addChild(this.background);
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
      
      public function addTab(param1:*, param2:Sprite) : void
      {
         var _loc4_:TabView = null;
         var _loc3_:int = int(this.tabs.length);
         if(param1 is Bitmap)
         {
            _loc4_ = this.addIconTab(_loc3_,param1 as Bitmap);
         }
         else if(param1 is BaseSimpleText)
         {
            _loc4_ = this.addTextTab(_loc3_,param1 as BaseSimpleText);
         }
         this.tabs.push(_loc4_);
         this.tabSprite.addChild(_loc4_);
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
      
      public function removeTab() : void
      {
      }
      
      private function addIconTab(param1:int, param2:Bitmap) : TabIconView
      {
         var _loc4_:TabIconView = null;
         var _loc3_:Sprite = new TabBackground();
         _loc4_ = new TabIconView(param1,_loc3_,param2);
         _loc4_.x = param1 * (_loc3_.width + TabConstants.PADDING);
         _loc4_.y = TabConstants.TAB_Y_POS;
         return _loc4_;
      }
      
      private function addTextTab(param1:int, param2:BaseSimpleText) : TabTextView
      {
         var _loc3_:Sprite = new TabBackground();
         var _loc4_:TabTextView = new TabTextView(param1,_loc3_,param2);
         _loc4_.x = param1 * (_loc3_.width + TabConstants.PADDING);
         _loc4_.y = TabConstants.TAB_Y_POS;
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
   }
}


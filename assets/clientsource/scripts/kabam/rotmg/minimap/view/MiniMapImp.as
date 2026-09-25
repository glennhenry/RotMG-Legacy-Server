package kabam.rotmg.minimap.view
{
   import com.company.assembleegameclient.map.AbstractMap;
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.objects.Character;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.GuildHallPortal;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.objects.Portal;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
   import com.company.assembleegameclient.ui.tooltip.PlayerGroupToolTip;
   import com.company.util.AssetLibrary;
   import com.company.util.PointUtil;
   import com.company.util.RectangleUtil;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class MiniMapImp extends MiniMap
   {
      
      public static const MOUSE_DIST_SQ:int = 5 * 5;
      
      private static var objectTypeColorDict_:Dictionary = new Dictionary();
      
      public var _width:int;
      
      public var _height:int;
      
      public var zoomIndex:int = 0;
      
      public var windowRect_:Rectangle;
      
      public var active:Boolean = true;
      
      public var maxWH_:Point;
      
      public var miniMapData_:BitmapData;
      
      public var zoomLevels:Vector.<Number> = new Vector.<Number>();
      
      public var blueArrow_:BitmapData;
      
      public var groundLayer_:Shape;
      
      public var characterLayer_:Shape;
      
      private var focus:GameObject;
      
      private var zoomButtons:MiniMapZoomButtons;
      
      private var isMouseOver:Boolean = false;
      
      private var tooltip:PlayerGroupToolTip = null;
      
      private var menu:PlayerGroupMenu = null;
      
      private var mapMatrix_:Matrix = new Matrix();
      
      private var arrowMatrix_:Matrix = new Matrix();
      
      private var players_:Vector.<Player> = new Vector.<Player>();
      
      private var tempPoint:Point = new Point();
      
      private var _rotateEnableFlag:Boolean;
      
      public function MiniMapImp(param1:int, param2:int)
      {
         super();
         this._width = param1;
         this._height = param2;
         this._rotateEnableFlag = Parameters.data_.allowMiniMapRotation;
         this.makeVisualLayers();
         this.addMouseListeners();
      }
      
      public static function gameObjectToColor(param1:GameObject) : uint
      {
         var _loc2_:* = param1.objectType_;
         if(!objectTypeColorDict_.hasOwnProperty(_loc2_))
         {
            objectTypeColorDict_[_loc2_] = param1.getColor();
         }
         return objectTypeColorDict_[_loc2_];
      }
      
      override public function setMap(param1:AbstractMap) : void
      {
         this.map = param1;
         this.makeViewModel();
      }
      
      override public function setFocus(param1:GameObject) : void
      {
         this.focus = param1;
      }
      
      private function makeViewModel() : void
      {
         this.windowRect_ = new Rectangle(-this._width / 2,-this._height / 2,this._width,this._height);
         this.maxWH_ = new Point(map.width_,map.height_);
         this.miniMapData_ = new BitmapDataSpy(this.maxWH_.x,this.maxWH_.y,false,0);
         var _loc1_:Number = Math.max(this._width / this.maxWH_.x,this._height / this.maxWH_.y);
         var _loc2_:Number = 4;
         while(_loc2_ > _loc1_)
         {
            this.zoomLevels.push(_loc2_);
            _loc2_ /= 2;
         }
         this.zoomLevels.push(_loc1_);
         this.zoomButtons && this.zoomButtons.setZoomLevels(this.zoomLevels.length);
      }
      
      private function makeVisualLayers() : void
      {
         this.blueArrow_ = AssetLibrary.getImageFromSet("lofiInterface",54).clone();
         this.blueArrow_.colorTransform(this.blueArrow_.rect,new ColorTransform(0,0,1));
         graphics.clear();
         graphics.beginFill(1776411);
         graphics.drawRect(0,0,this._width,this._height);
         graphics.endFill();
         this.groundLayer_ = new Shape();
         this.groundLayer_.x = this._width / 2;
         this.groundLayer_.y = this._height / 2;
         addChild(this.groundLayer_);
         this.characterLayer_ = new Shape();
         this.characterLayer_.x = this._width / 2;
         this.characterLayer_.y = this._height / 2;
         addChild(this.characterLayer_);
         this.zoomButtons = new MiniMapZoomButtons();
         this.zoomButtons.x = this._width - 20;
         this.zoomButtons.zoom.add(this.onZoomChanged);
         this.zoomButtons.setZoomLevels(this.zoomLevels.length);
         addChild(this.zoomButtons);
      }
      
      private function addMouseListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.RIGHT_CLICK,this.onMapRightClick);
         addEventListener(MouseEvent.CLICK,this.onMapClick);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.active = false;
         this.removeDecorations();
      }
      
      public function dispose() : void
      {
         this.miniMapData_.dispose();
         this.miniMapData_ = null;
         this.removeDecorations();
      }
      
      private function onZoomChanged(param1:int) : void
      {
         this.zoomIndex = param1;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.isMouseOver = true;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.isMouseOver = false;
      }
      
      private function onMapRightClick(param1:MouseEvent) : void
      {
         this._rotateEnableFlag = !this._rotateEnableFlag && Boolean(Parameters.data_.allowMiniMapRotation);
      }
      
      private function onMapClick(param1:MouseEvent) : void
      {
         if(this.tooltip == null || this.tooltip.parent == null || this.tooltip.players_ == null || this.tooltip.players_.length == 0)
         {
            return;
         }
         this.removeMenu();
         this.addMenu();
         this.removeTooltip();
      }
      
      private function addMenu() : void
      {
         this.menu = new PlayerGroupMenu(map,this.tooltip.players_);
         this.menu.x = this.tooltip.x + 12;
         this.menu.y = this.tooltip.y;
         menuLayer.addChild(this.menu);
      }
      
      override public function setGroundTile(param1:int, param2:int, param3:uint) : void
      {
         var _loc4_:uint = GroundLibrary.getColor(param3);
         this.miniMapData_.setPixel(param1,param2,_loc4_);
      }
      
      override public function setGameObjectTile(param1:int, param2:int, param3:GameObject) : void
      {
         var _loc4_:uint = gameObjectToColor(param3);
         this.miniMapData_.setPixel(param1,param2,_loc4_);
      }
      
      private function removeDecorations() : void
      {
         this.removeTooltip();
         this.removeMenu();
      }
      
      private function removeTooltip() : void
      {
         if(this.tooltip != null)
         {
            if(this.tooltip.parent != null)
            {
               this.tooltip.parent.removeChild(this.tooltip);
            }
            this.tooltip = null;
         }
      }
      
      private function removeMenu() : void
      {
         if(this.menu != null)
         {
            if(this.menu.parent != null)
            {
               this.menu.parent.removeChild(this.menu);
            }
            this.menu = null;
         }
      }
      
      override public function draw() : void
      {
         var _loc7_:Graphics = null;
         var _loc10_:GameObject = null;
         var _loc15_:uint = 0;
         var _loc16_:Player = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         this._rotateEnableFlag = this._rotateEnableFlag && Boolean(Parameters.data_.allowMiniMapRotation);
         this.groundLayer_.graphics.clear();
         this.characterLayer_.graphics.clear();
         if(!this.focus)
         {
            return;
         }
         if(!this.active)
         {
            return;
         }
         var _loc1_:Number = this.zoomLevels[this.zoomIndex];
         this.mapMatrix_.identity();
         this.mapMatrix_.translate(-this.focus.x_,-this.focus.y_);
         this.mapMatrix_.scale(_loc1_,_loc1_);
         var _loc2_:Point = this.mapMatrix_.transformPoint(PointUtil.ORIGIN);
         var _loc3_:Point = this.mapMatrix_.transformPoint(this.maxWH_);
         var _loc4_:Number = 0;
         if(_loc2_.x > this.windowRect_.left)
         {
            _loc4_ = this.windowRect_.left - _loc2_.x;
         }
         else if(_loc3_.x < this.windowRect_.right)
         {
            _loc4_ = this.windowRect_.right - _loc3_.x;
         }
         var _loc5_:Number = 0;
         if(_loc2_.y > this.windowRect_.top)
         {
            _loc5_ = this.windowRect_.top - _loc2_.y;
         }
         else if(_loc3_.y < this.windowRect_.bottom)
         {
            _loc5_ = this.windowRect_.bottom - _loc3_.y;
         }
         this.mapMatrix_.translate(_loc4_,_loc5_);
         _loc2_ = this.mapMatrix_.transformPoint(PointUtil.ORIGIN);
         if(_loc1_ >= 1 && this._rotateEnableFlag)
         {
            this.mapMatrix_.rotate(-Parameters.data_.cameraAngle);
         }
         var _loc6_:Rectangle = new Rectangle();
         _loc6_.x = Math.max(this.windowRect_.x,_loc2_.x);
         _loc6_.y = Math.max(this.windowRect_.y,_loc2_.y);
         _loc6_.right = Math.min(this.windowRect_.right,_loc2_.x + this.maxWH_.x * _loc1_);
         _loc6_.bottom = Math.min(this.windowRect_.bottom,_loc2_.y + this.maxWH_.y * _loc1_);
         _loc7_ = this.groundLayer_.graphics;
         _loc7_.beginBitmapFill(this.miniMapData_,this.mapMatrix_,false);
         _loc7_.drawRect(_loc6_.x,_loc6_.y,_loc6_.width,_loc6_.height);
         _loc7_.endFill();
         _loc7_ = this.characterLayer_.graphics;
         var _loc8_:Number = mouseX - this._width / 2;
         var _loc9_:Number = mouseY - this._height / 2;
         this.players_.length = 0;
         for each(_loc10_ in map.goDict_)
         {
            if(!(_loc10_.props_.noMiniMap_ || _loc10_ == this.focus))
            {
               _loc16_ = _loc10_ as Player;
               if(_loc16_ != null)
               {
                  if(_loc16_.isPaused())
                  {
                     _loc15_ = 8355711;
                  }
                  else if(_loc16_.isFellowGuild_)
                  {
                     _loc15_ = 65280;
                  }
                  else
                  {
                     _loc15_ = 16776960;
                  }
               }
               else if(_loc10_ is Character)
               {
                  if(_loc10_.props_.isEnemy_)
                  {
                     _loc15_ = 16711680;
                  }
                  else
                  {
                     _loc15_ = gameObjectToColor(_loc10_);
                  }
               }
               else
               {
                  if(!(_loc10_ is Portal || _loc10_ is GuildHallPortal))
                  {
                     continue;
                  }
                  _loc15_ = 255;
               }
               _loc17_ = this.mapMatrix_.a * _loc10_.x_ + this.mapMatrix_.c * _loc10_.y_ + this.mapMatrix_.tx;
               _loc18_ = this.mapMatrix_.b * _loc10_.x_ + this.mapMatrix_.d * _loc10_.y_ + this.mapMatrix_.ty;
               if(_loc17_ <= -this._width / 2 || _loc17_ >= this._width / 2 || _loc18_ <= -this._height / 2 || _loc18_ >= this._height / 2)
               {
                  RectangleUtil.lineSegmentIntersectXY(this.windowRect_,0,0,_loc17_,_loc18_,this.tempPoint);
                  _loc17_ = this.tempPoint.x;
                  _loc18_ = this.tempPoint.y;
               }
               if(_loc16_ != null && this.isMouseOver && (this.menu == null || this.menu.parent == null))
               {
                  _loc19_ = _loc8_ - _loc17_;
                  _loc20_ = _loc9_ - _loc18_;
                  _loc21_ = _loc19_ * _loc19_ + _loc20_ * _loc20_;
                  if(_loc21_ < MOUSE_DIST_SQ)
                  {
                     this.players_.push(_loc16_);
                  }
               }
               _loc7_.beginFill(_loc15_);
               _loc7_.drawRect(_loc17_ - 2,_loc18_ - 2,4,4);
               _loc7_.endFill();
            }
         }
         if(this.players_.length != 0)
         {
            if(this.tooltip == null)
            {
               this.tooltip = new PlayerGroupToolTip(this.players_);
               menuLayer.addChild(this.tooltip);
            }
            else if(!this.areSamePlayers(this.tooltip.players_,this.players_))
            {
               this.tooltip.setPlayers(this.players_);
            }
         }
         else if(this.tooltip != null)
         {
            if(this.tooltip.parent != null)
            {
               this.tooltip.parent.removeChild(this.tooltip);
            }
            this.tooltip = null;
         }
         var _loc11_:Number = this.focus.x_;
         var _loc12_:Number = this.focus.y_;
         var _loc13_:Number = this.mapMatrix_.a * _loc11_ + this.mapMatrix_.c * _loc12_ + this.mapMatrix_.tx;
         var _loc14_:Number = this.mapMatrix_.b * _loc11_ + this.mapMatrix_.d * _loc12_ + this.mapMatrix_.ty;
         this.arrowMatrix_.identity();
         this.arrowMatrix_.translate(-4,-5);
         this.arrowMatrix_.scale(8 / this.blueArrow_.width,32 / this.blueArrow_.height);
         if(!(_loc1_ >= 1 && this._rotateEnableFlag))
         {
            this.arrowMatrix_.rotate(Parameters.data_.cameraAngle);
         }
         this.arrowMatrix_.translate(_loc13_,_loc14_);
         _loc7_.beginBitmapFill(this.blueArrow_,this.arrowMatrix_,false);
         _loc7_.drawRect(_loc13_ - 16,_loc14_ - 16,32,32);
         _loc7_.endFill();
      }
      
      private function areSamePlayers(param1:Vector.<Player>, param2:Vector.<Player>) : Boolean
      {
         var _loc3_:int = int(param1.length);
         if(_loc3_ != param2.length)
         {
            return false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1[_loc4_] != param2[_loc4_])
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      override public function zoomIn() : void
      {
         this.zoomIndex = this.zoomButtons.setZoomLevel(this.zoomIndex - 1);
      }
      
      override public function zoomOut() : void
      {
         this.zoomIndex = this.zoomButtons.setZoomLevel(this.zoomIndex + 1);
      }
      
      override public function deactivate() : void
      {
      }
   }
}


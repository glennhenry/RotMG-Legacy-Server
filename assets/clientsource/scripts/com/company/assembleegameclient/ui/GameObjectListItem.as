package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.TemplateBuilder;
   import org.osflash.signals.Signal;
   
   public class GameObjectListItem extends Sprite
   {
      
      public var portrait:Bitmap;
      
      private var text:TextFieldDisplayConcrete;
      
      private var builder:TemplateBuilder;
      
      private var color:uint;
      
      public var isLongVersion:Boolean;
      
      public var go:GameObject;
      
      public var textReady:Signal;
      
      private var objname:String;
      
      private var type:int;
      
      private var level:int;
      
      private var positionClassBelow:Boolean;
      
      public function GameObjectListItem(param1:uint, param2:Boolean, param3:GameObject, param4:Boolean = false)
      {
         super();
         this.positionClassBelow = param4;
         this.isLongVersion = param2;
         this.color = param1;
         this.portrait = new Bitmap();
         this.portrait.x = -4;
         this.portrait.y = param4 ? -1 : -4;
         addChild(this.portrait);
         this.text = new TextFieldDisplayConcrete().setSize(13).setColor(param1).setHTML(param2);
         if(!param2)
         {
            this.text.setTextWidth(66).setTextHeight(20).setBold(true);
         }
         this.text.x = 32;
         this.text.y = 6;
         this.text.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.text);
         this.textReady = this.text.textChanged;
         this.draw(param3);
      }
      
      public function draw(param1:GameObject, param2:ColorTransform = null) : void
      {
         var _loc3_:Boolean = false;
         _loc3_ = this.isClear();
         this.go = param1;
         visible = param1 != null;
         if(visible && (this.hasChanged() || _loc3_))
         {
            this.redraw();
            transform.colorTransform = param2 || MoreColorUtil.identity;
         }
      }
      
      public function clear() : void
      {
         this.go = null;
         visible = false;
      }
      
      public function isClear() : Boolean
      {
         return this.go == null && visible == false;
      }
      
      private function hasChanged() : Boolean
      {
         var _loc1_:Boolean = this.go.name_ != this.objname || this.go.level_ != this.level || this.go.objectType_ != this.type;
         _loc1_ && this.updateData();
         return _loc1_;
      }
      
      private function updateData() : void
      {
         this.objname = this.go.name_;
         this.level = this.go.level_;
         this.type = this.go.objectType_;
      }
      
      private function redraw() : void
      {
         this.portrait.bitmapData = this.go.getPortrait();
         this.text.setStringBuilder(this.prepareText());
         this.text.setColor(this.getDrawColor());
         this.text.update();
      }
      
      private function prepareText() : TemplateBuilder
      {
         this.builder = this.builder || new TemplateBuilder();
         if(this.isLongVersion)
         {
            this.applyLongTextToBuilder();
         }
         else if(this.isNameDefined())
         {
            this.builder.setTemplate(this.objname);
         }
         else
         {
            this.builder.setTemplate(ObjectLibrary.typeToDisplayId_[this.type]);
         }
         return this.builder;
      }
      
      private function applyLongTextToBuilder() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = {};
         if(this.isNameDefined())
         {
            if(this.positionClassBelow)
            {
               _loc1_ = "<b>{name}</b>\n({type}{level})";
            }
            else
            {
               _loc1_ = "<b>{name}</b> ({type}{level})";
            }
            if(this.go.name_.length > 8 && !this.positionClassBelow)
            {
               _loc2_.name = this.go.name_.slice(0,6) + "...";
            }
            else
            {
               _loc2_.name = this.go.name_;
            }
            _loc2_.type = ObjectLibrary.typeToDisplayId_[this.type];
            _loc2_.level = this.level < 1 ? "" : " " + this.level;
         }
         else
         {
            _loc1_ = "<b>{name}</b>";
            _loc2_.name = ObjectLibrary.typeToDisplayId_[this.type];
         }
         this.builder.setTemplate(_loc1_,_loc2_);
      }
      
      private function isNameDefined() : Boolean
      {
         return this.go.name_ != null && this.go.name_ != "";
      }
      
      private function getDrawColor() : int
      {
         var _loc1_:Player = this.go as Player;
         if(_loc1_ == null)
         {
            return this.color;
         }
         if(_loc1_.isFellowGuild_)
         {
            return Parameters.FELLOW_GUILD_COLOR;
         }
         if(_loc1_.nameChosen_)
         {
            return Parameters.NAME_CHOSEN_COLOR;
         }
         return this.color;
      }
   }
}


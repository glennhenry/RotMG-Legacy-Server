package com.company.assembleegameclient.map
{
   import com.company.assembleegameclient.background.Background;
   import com.company.assembleegameclient.game.AGameSprite;
   import com.company.assembleegameclient.map.mapoverlay.MapOverlay;
   import com.company.assembleegameclient.map.partyoverlay.PartyOverlay;
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.assembleegameclient.objects.Party;
   import com.company.assembleegameclient.objects.Player;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import org.osflash.signals.Signal;
   
   public class AbstractMap extends Sprite
   {
      
      public var goDict_:Dictionary = new Dictionary();
      
      public var gs_:AGameSprite;
      
      public var name_:String;
      
      public var player_:Player = null;
      
      public var showDisplays_:Boolean;
      
      public var width_:int;
      
      public var height_:int;
      
      public var back_:int;
      
      protected var allowPlayerTeleport_:Boolean;
      
      public var background_:Background = null;
      
      public var map_:Sprite = new Sprite();
      
      public var hurtOverlay_:HurtOverlay = null;
      
      public var gradientOverlay_:GradientOverlay = null;
      
      public var mapOverlay_:MapOverlay = null;
      
      public var partyOverlay_:PartyOverlay = null;
      
      public var squareList_:Vector.<com.company.assembleegameclient.map.Square> = new Vector.<com.company.assembleegameclient.map.Square>();
      
      public var squares_:Vector.<com.company.assembleegameclient.map.Square> = new Vector.<com.company.assembleegameclient.map.Square>();
      
      public var boDict_:Dictionary = new Dictionary();
      
      public var merchLookup_:Object = new Object();
      
      public var party_:Party = null;
      
      public var quest_:Quest = null;
      
      public var signalRenderSwitch:Signal = new Signal(Boolean);
      
      protected var wasLastFrameGpu:Boolean = false;
      
      public var isPetYard:Boolean = false;
      
      public function AbstractMap()
      {
         super();
      }
      
      public function setProps(param1:int, param2:int, param3:String, param4:int, param5:Boolean, param6:Boolean) : void
      {
      }
      
      public function addObj(param1:BasicObject, param2:Number, param3:Number) : void
      {
      }
      
      public function setGroundTile(param1:int, param2:int, param3:uint) : void
      {
      }
      
      public function initialize() : void
      {
      }
      
      public function dispose() : void
      {
      }
      
      public function update(param1:int, param2:int) : void
      {
      }
      
      public function pSTopW(param1:Number, param2:Number) : Point
      {
         return null;
      }
      
      public function removeObj(param1:int) : void
      {
      }
      
      public function draw(param1:Camera, param2:int) : void
      {
      }
      
      public function allowPlayerTeleport() : Boolean
      {
         return this.name_ != Map.NEXUS && this.allowPlayerTeleport_;
      }
   }
}


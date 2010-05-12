package com.bored.games.darts.ui 
{
	import caurina.transitions.Tweener;
	import com.bored.games.darts.assets.hud.PowerSlot_MC;
	import com.bored.games.darts.assets.icons.BeelineIcon_MC;
	import com.bored.games.darts.assets.icons.DoOverIcon_MC;
	import com.bored.games.darts.assets.icons.ShieldIcon_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.ui.store.StoreManager;
	import com.bored.services.AbstractExternalService;
	import com.bored.services.StoreItem;
	import com.greensock.TweenLite;
	import com.inassets.events.ObjectEvent;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.sven.utils.ImageFactory;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class GameStoreScreen extends ContentHolder
	{
		public static const BACK_CLICKED_EVT:String = "backClicked";
		
		private var _dartFilterBtnImg:MovieClip;
		private var _dartFilterBtn:MightyButton;
		
		private var _powersFilterBtnImg:MovieClip;
		private var _powersFilterBtn:MightyButton;
		
		private var _premiumFilterBtnImg:MovieClip;
		private var _premiumFilterBtn:MightyButton;
		
		private var _backBtnImg:MovieClip;
		private var _backBtn:MightyButton;
		
		private var _storeSlotOne:MovieClip;
		private var _storeSlotTwo:MovieClip;
		private var _storeSlotThree:MovieClip;
		
		private var _slotLoaderOne:Loader;
		private var _slotLoaderTwo:Loader;
		private var _slotLoaderThree:Loader;
		
		private var _slotBitmapOne:Bitmap;
		private var _slotBitmapTwo:Bitmap;
		private var _slotBitmapThree:Bitmap;
		
		private var _shieldSlot:MovieClip;
		private var _beelineSlot:MovieClip;
		private var _dooverSlot:MovieClip;
		
		private var _slotPriceOne:TextField;
		private var _slotPriceTwo:TextField;
		private var _slotPriceThree:TextField;
		
		private var _slotAddBtnImgOne:MovieClip;
		private var _slotAddBtnImgTwo:MovieClip;
		private var _slotAddBtnImgThree:MovieClip;
		
		private var _slotAddBtnOne:MightyButton;
		private var _slotAddBtnTwo:MightyButton;
		private var _slotAddBtnThree:MightyButton;
		
		private var _pageSelectLeftBtn:MightyButton;
		private var _pageSelectLeftBtnImg:MovieClip;
		
		private var _pageSelectRightBtn:MightyButton;
		private var _pageSelectRightBtnImg:MovieClip;
		
		private var _background:Sprite;
		private var _buildBackground:Boolean = false;
		
		private var _items:Vector.<StoreItem>;
		private var _itemInd:int;
		
		public function GameStoreScreen(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true, a_buildBackground:Boolean = false) 
		{
			super(a_img, a_buildFromAllDescendants, a_bAddContents);
			
			_buildBackground = a_buildBackground;
			
			if (this.stage)
			{
				addedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
			
		}//end GameReadyPopup() constructor.
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			_dartFilterBtnImg = descendantsDict["dartsFilterBtn_mc"] as MovieClip;
			_powersFilterBtnImg = descendantsDict["powersFilterBtn_mc"] as MovieClip;
			//_premiumFilterBtnImg = descendantsDict["premiumFilterBtn_mc"] as MovieClip;
						
			_backBtnImg = descendantsDict["backBtn_mc"] as MovieClip;
			
			_storeSlotOne = descendantsDict["storeSlotOne_mc"] as MovieClip;
			_storeSlotTwo = descendantsDict["storeSlotTwo_mc"] as MovieClip;
			_storeSlotThree = descendantsDict["storeSlotThree_mc"] as MovieClip;
			
			_slotBitmapOne = new Bitmap();
			_storeSlotOne.addChild(_slotBitmapOne);
			_slotBitmapTwo = new Bitmap();
			_storeSlotTwo.addChild(_slotBitmapTwo);
			_slotBitmapThree = new Bitmap();
			_storeSlotThree.addChild(_slotBitmapThree);
			
			_items = new Vector.<StoreItem>();
						
			_slotPriceOne = descendantsDict["slotPriceOne_mc"] as TextField;
			_slotPriceTwo = descendantsDict["slotPriceTwo_mc"] as TextField;
			_slotPriceThree = descendantsDict["slotPriceThree_mc"] as TextField;
			
			_slotAddBtnImgOne = descendantsDict["slotAddBtnOne_mc"] as MovieClip;
			_slotAddBtnImgTwo = descendantsDict["slotAddBtnTwo_mc"] as MovieClip;
			_slotAddBtnImgThree = descendantsDict["slotAddBtnThree_mc"] as MovieClip;
			
			_pageSelectLeftBtnImg = descendantsDict["pageSelectLeftBtn_mc"] as MovieClip;
			_pageSelectRightBtnImg = descendantsDict["pageSelectRightBtn_mc"] as MovieClip;
			
			if (_dartFilterBtnImg)
			{
				_dartFilterBtn = new MightyButton(_dartFilterBtnImg, false);
				_dartFilterBtn.pause(false);
				_dartFilterBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onDartsClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _dartFilterBtnImg=" + _dartFilterBtnImg);
			}
						
			if (_powersFilterBtnImg)
			{
				_powersFilterBtn = new MightyButton(_powersFilterBtnImg, false);
				_powersFilterBtn.pause(false);
				_powersFilterBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPowersClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _powersFilterBtnImg=" + _powersFilterBtnImg);
			}
			
			/*
			if (_premiumFilterBtnImg)
			{
				_premiumFilterBtn = new MightyButton(_premiumFilterBtnImg, false);
				_premiumFilterBtn.pause(false);
				_premiumFilterBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPremiumClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _premiumFilterBtnImg=" + _premiumFilterBtnImg);
			}
			*/
			
			if (_backBtnImg)
			{
				_backBtn = new MightyButton(_backBtnImg, false);
				_backBtn.pause(false);
				_backBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onBackClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _backBtnImg=" + _backBtnImg);
			}
			
			if (_slotAddBtnImgOne)
			{
				_slotAddBtnOne = new MightyButton(_slotAddBtnImgOne, false);
				_slotAddBtnOne.pause(false);
				_slotAddBtnOne.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onAddSlotOneClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _slotAddBtnImgOne=" + _slotAddBtnImgOne);
			}
			
			if (_slotAddBtnImgTwo)
			{
				_slotAddBtnTwo = new MightyButton(_slotAddBtnImgTwo, false);
				_slotAddBtnTwo.pause(false);
				_slotAddBtnTwo.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onAddSlotTwoClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _slotAddBtnImgTwo=" + _slotAddBtnImgTwo);
			}
			
			if (_slotAddBtnImgThree)
			{
				_slotAddBtnThree = new MightyButton(_slotAddBtnImgThree, false);
				_slotAddBtnThree.pause(false);
				_slotAddBtnThree.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onAddSlotThreeClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _slotAddBtnImgThree=" + _slotAddBtnImgThree);
			}
			
			if (_pageSelectLeftBtnImg)
			{
				_pageSelectLeftBtn = new MightyButton(_pageSelectLeftBtnImg, false);
				_pageSelectLeftBtn.pause(false);
				_pageSelectLeftBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPageLeftClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _pageSelectLeftBtnImg=" + _pageSelectLeftBtnImg);
			}
			
			if (_pageSelectRightBtnImg)
			{
				_pageSelectRightBtn = new MightyButton(_pageSelectRightBtnImg, false);
				_pageSelectRightBtn.pause(false);
				_pageSelectRightBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPageRightClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _pageSelectRightBtnImg=" + _pageSelectRightBtnImg);
			}
						
			if(_buildBackground)
			{
				_background = new Sprite();
			}
			
			StoreManager.generateDartList();
			
			processStoreItems(StoreManager.storeContents);
			
			_dartFilterBtn.pause(true);
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			// build our background.
			if (_background)
			{
				_background.graphics.beginFill(0x000000, .75);
				_background.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
				_background.graphics.endFill();
			}
			
			this.contentsMC.alpha = 1;
			
			this.alpha = 0;
			
			if(_background)
			{
				var contentIndex:int = this.getChildIndex(this.contents);
				this.addChildAt(_background, contentIndex);
			}
			
			this.contentsMC.x = (this.stage.stageWidth / 2) - (this.contentsMC.width / 2);
			this.contentsMC.y = (this.stage.stageHeight / 2) - (this.contentsMC.height / 2);
			
			TweenLite.to(this, 2, { alpha:1 } );
			
		}//end addedToStage()
		
		private function onDartsClicked(evt:Event):void
		{
			StoreManager.generateDartList();
			
			processStoreItems(StoreManager.storeContents);
			
			_dartFilterBtn.pause(true);
			_powersFilterBtn.pause(false);
		}//end onPowersClicked()
		
		private function onPowersClicked(evt:Event):void
		{
			StoreManager.generatePowerList();
			
			processStoreItems(StoreManager.storeContents);
			
			_dartFilterBtn.pause(false);
			_powersFilterBtn.pause(true);
		}//end onPowersClicked()
		
		/*
		private function onPremiumClicked(evt:Event):void
		{
			if(_storeSlotOne.contains(_shieldSlot)) _storeSlotOne.removeChild(_shieldSlot);
			if(_storeSlotTwo.contains(_beelineSlot)) _storeSlotTwo.removeChild(_beelineSlot);
			if(_storeSlotThree.contains(_dooverSlot)) _storeSlotThree.removeChild(_dooverSlot);
			
			_storeSlotOne.addChild(_slotBitmapOne);
			_storeSlotTwo.addChild(_slotBitmapTwo);
			_storeSlotThree.addChild(_slotBitmapThree);			
			
			DartsGlobals.instance.externalServices.initializeStore();
			DartsGlobals.instance.externalServices.addEventListener(AbstractExternalService.STORE_ITEMS_AVAILABLE, onStoreItemsAvailable);
		}//end onPowersClicked()
		*/
		
		private function onPageLeftClicked(evt:Event):void
		{
			_itemInd -= 3;
			
			if (_itemInd < 0) _itemInd = Math.floor((_items.length - 1)/ 3) * 3;
			
			refreshStoreList();
		}//end onPageLeftClicked()
		
		private function onPageRightClicked(evt:Event):void
		{
			_itemInd += 3;
			
			if (_itemInd >= _items.length) _itemInd = 0;
			
			refreshStoreList();
		}//end onPageRightClicked()
		
		private function onAddSlotOneClicked(evt:Event):void
		{
			if ( checkCanAfford(_items[_itemInd].price) ) 
			{
				if( _items[_itemInd].doPurchase() )
					processPurchase(_items[_itemInd].price);
			}
			refreshStoreList();
		}//end onAddSlotOneClicked()
		
		private function onAddSlotTwoClicked(evt:Event):void
		{
			if ( checkCanAfford(_items[_itemInd + 1].price) ) 
			{
				if( _items[_itemInd + 1].doPurchase() )
					processPurchase(_items[_itemInd + 1].price);
			}
			refreshStoreList();
		}//end onAddSlotTwoClicked()
		
		private function onAddSlotThreeClicked(evt:Event):void
		{
			if ( checkCanAfford(_items[_itemInd + 2].price) ) 
			{
				if( _items[_itemInd + 2].doPurchase() )
					processPurchase(_items[_itemInd + 2].price);
			}
			refreshStoreList();
		}//end onAddSlotThreeClicked()
		
		private function onStoreItemsAvailable(a_evt:ObjectEvent):void
		{
			processStoreItems(a_evt.obj);
		}//end onStoreHidden()
		
		private function processStoreItems(obj:Object):void
		{
			_items = obj as Vector.<StoreItem>;
			_itemInd = 0;
			refreshStoreList();
		}//end processStoreItems()
		
		private function refreshStoreList():void
		{
			if ( _items.length > _itemInd ) 
			{
				if ( checkIfOwned(_items[_itemInd].id) ) {
					_slotAddBtnOne.pause(true);
				} else {
					_slotAddBtnOne.pause(false);
				}
				
				_slotBitmapOne.visible = true;
				_slotBitmapOne.bitmapData = new BitmapData(_items[_itemInd].storeIcon.width, _items[_itemInd].storeIcon.height, true, 0x00000000);
				_slotBitmapOne.bitmapData.draw(_items[_itemInd].storeIcon);
				_slotBitmapOne.smoothing = true;
				
				_slotPriceOne.text = "$" + _items[_itemInd].price.toString();
				
				_slotAddBtnOne.buttonContents.visible = true;
			} else {
				_slotBitmapOne.visible = false;
				
				_slotPriceOne.text = "";
				
				_slotAddBtnOne.pause(true);
				_slotAddBtnOne.buttonContents.visible = false;
			}
			
			if ( _items.length > _itemInd+1 ) 
			{
				if ( checkIfOwned(_items[_itemInd+1].id) ) {
					_slotAddBtnTwo.pause(true);
				} else {
					_slotAddBtnTwo.pause(false);
				}
				
				_slotBitmapTwo.visible = true;
				_slotBitmapTwo.bitmapData = new BitmapData(_items[_itemInd+1].storeIcon.width, _items[_itemInd+1].storeIcon.height, true, 0x00000000);
				_slotBitmapTwo.bitmapData.draw(_items[_itemInd+1].storeIcon);
				_slotBitmapTwo.smoothing = true;
				
				_slotPriceTwo.text = "$" + _items[_itemInd+1].price.toString();	
				
				_slotAddBtnTwo.buttonContents.visible = true;
			} else {
				_slotBitmapTwo.visible = false;
				
				_slotPriceTwo.text = "";
				
				_slotAddBtnTwo.pause(true);
				_slotAddBtnTwo.buttonContents.visible = false;
			}
			
			if ( _items.length > _itemInd+2 ) 
			{
				if ( checkIfOwned(_items[_itemInd+2].id) ) {
					_slotAddBtnThree.pause(true);
				} else {
					_slotAddBtnThree.pause(false);
				}
				
				_slotBitmapThree.visible = true;
				_slotBitmapThree.bitmapData = new BitmapData(_items[_itemInd+2].storeIcon.width, _items[_itemInd+2].storeIcon.height, true, 0x00000000);
				_slotBitmapThree.bitmapData.draw(_items[_itemInd+2].storeIcon);
				_slotBitmapThree.smoothing = true;
				
				_slotPriceThree.text = "$" + _items[_itemInd+2].price.toString();
				
				_slotAddBtnThree.buttonContents.visible = true;
			} else {
				_slotBitmapThree.visible = false;
				
				_slotPriceThree.text = "";
				
				_slotAddBtnThree.pause(true);
				_slotAddBtnThree.buttonContents.visible = false;
			}
		}//end refreshStoreList()
		
		private function checkIfOwned(a_id:String):Boolean
		{
			var arr:Array = DartsGlobals.instance.externalServices.getData("ownedSkins");
			for each( var obj:Object in arr )
			{
				if ( obj.skinid.toLowerCase() == a_id.toLowerCase() ) return true;
			}
			return false;
		}//end checkIfOwned()
		
		private function checkCanAfford(a_price:int):Boolean
		{
			var cash:int = DartsGlobals.instance.externalServices.getData("gameCash");
			if ( cash >= a_price ) return true;	
			return false;
		}//end checkIfOwned()
		
		private function processPurchase(a_price:int):void
		{
			var cash:int = DartsGlobals.instance.externalServices.getData("gameCash");
			cash -= a_price;
			DartsGlobals.instance.externalServices.setData("gameCash", cash);
		}//end checkIfOwned()
		
		private function onBackClicked(evt:Event):void
		{
			DartsGlobals.instance.externalServices.pushUserData();
			
			this.dispatchEvent(new Event(BACK_CLICKED_EVT));
			
			TweenLite.to(this, 0.4, { alpha:0, onComplete:destroy } );
		}//end onBackClicked()
		
		override public function destroy(...args):void
		{
			super.destroy();
									
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_background = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
	
	}//end GameStoreScreen
	
}//end package com.bored.games.darts.ui 
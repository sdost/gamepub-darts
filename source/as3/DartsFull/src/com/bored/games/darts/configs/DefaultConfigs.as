package com.bored.games.darts.configs 
{
	/**
	 * ...
	 * @author Sam
	 */
	public class DefaultConfigs
	{
		public static const data:XML = <appsettings>
			<add key="throwsPerTurn" type="int" value="3" />

			<add key="externalServicesProvider" type="String" value="com.bored.services.ExternalService_BoredAPI" />
			<add key="externalServicesGameId" type="String" value="e85ee5f3a09f56cf" />

			<add key="attractScreenSprite" type="String" value="com.bored.games.darts.assets.screens.TitleScreen_MC" />
			<add key="opponentSelectScreenSprite" type="String" value="com.bored.games.assets.OpponentSelectScreen_MC" />
			<add key="multiplayerConfirmScreenSprite" type="String" value="com.bored.games.darts.assets.screen.MultiplayerConfirmScreen_MC" />
			<add key="confirmScreenSprite" type="String" value="com.bored.games.darts.assets.screen.ConfirmScreen_MC" />
			<add key="gameStoreScreenSprite" type="String" value="com.bored.games.darts.assets.screen.GameStore_MC" />
			<add key="splashLogo" type="String" value="com.bored.games.assets.MonsterproofLogo" />

			<add key="clickModalSprite" type="String" value="com.bored.games.darts.assets.modal.ContinueClick_MC" />
			<add key="bullOffAnnounceModalSprite" type="String" value="com.bored.games.darts.assets.modal.BullOffAnnounceModal_MC" />
			<add key="bullOffWinnerModalSprite" type="String" value="com.bored.games.darts.assets.modal.BullOffWinnerModal_MC" />
			<add key="throwTutorialModalSprite" type="String" value="com.bored.games.darts.assets.ThrowTutorialModal_MC" />
			<add key="practiceModalSprite" type="String" value="com.bored.games.darts.assets.modal.PracticeModal_MC" />
			<add key="tutorialModalSprite" type="String" value="com.bored.games.darts.assets.modal.TutorialModal_MC" />
			<add key="resultsModalSprite" type="String" value="com.bored.games.darts.assets.modal.ResultsModal_MC" />
			<add key="multiplayerResultsModalSprite" type="String" value="com.bored.games.darts.assets.modal.MultiplayerResultsModal_MC" />
			<add key="storyHelpModalSprite" type="String" value="com.bored.games.darts.assets.StoryHelpModal_MC" />
			<add key="basicCricketHelpModalSprite" type="String" value="com.bored.games.darts.assets.BasicCricketHelpModal_MC" />
			<add key="basic501HelpModalSprite" type="String" value="com.bored.games.darts.assets.Basic501HelpModal_MC" />
			<add key="turnAnnounceModalSprite" type="String" value="com.bored.games.darts.assets.modal.TurnAnnounce_MC" />
			<add key="achievementsModalSprite" type="String" value="com.bored.games.darts.assets.AcheivementsModal_MC" />
			<add key="basicTutorialModalSprite" type="String" value="com.bored.games.darts.assets.modal.BasicThrowTutorialModal_MC" />

			<add key="resultModalSprite" type="String" value="com.bored.games.darts.assets.modal.ResultsModal_MC" />
			<add key="quitModalSprite" type="String" value="com.bored.games.darts.assets.modal.QuitModal_MC" />
			<add key="multiplayerQuitModalSprite" type="String" value="com.bored.games.darts.assets.modal.MultiplayerQuitModal_MC" />
			<add key="opponentQuitModalSprite" type="String" value="com.bored.games.darts.assets.modal.OpponentQuitModal_MC" />
			<add key="turnAnnounceModalSprite" type="String" value="com.bored.games.darts.assets.modal.TurnAnnounceModal_MC" />

			<add key="defaultPlayerPic" type="String" value="com.bored.games.darts.assets.icons.Protagonist_Portrait_BMP" />
			<add key="defaultMultiplayerPic" type="String" value="com.bored.games.darts.assets.icons.BoredBob_Portrait_BMP" />

			<add key="cricketMultiplayerGameId" type="int" value="4" />
			<add key="fiveOhOneMultiplayerGameId" type="int" value="5" />

			<add key="away3dEngineScale" type="int" value="100" />

			<!-- Affects Throw Mechanics -->
			<add key="overthrowExponent" type="Number" value="4" />
			<add key="overthrowScale" type="Number" value="5" />
			<add key="overthrowOffset" type="Number" value="0.5" />
			<add key="underthrowAngle" type="Number" value="10" />
			<add key="overthrowAngle" type="Number" value="12" />

			<add key="dartPointRadius" type="int" value="1" />
			<add key="dartMinThrust" type="int" value="6" />
			<add key="dartMaxThrust" type="int" value="18" />
			<add key="dartSweetSpotMin" type="int" value="10" />
			<add key="dartSweetSpotThrust" type="int" value="12" />
			<add key="dartSweetSpotMax" type="int" value="14" />
			<add key="dartThrustScale" type="Number" value="0.0125" />
			<add key="dartRollSpeed" type="Number" value="3" />
			<add key="dartLeanScale" type="Number" value="0.001" />
			<add key="defaultMinThrustThreshold" type="int" value="8" />

			<add key="simulationStepScale" type="Number" value="0.045" />

			<add key="aiOpponentName" type="String" value="testai" />
			<add key="aiOptimumThrust" type="Number" value="12" />
			<add key="aiThrustErrorRangeMin" type="Number" value="0.001" /> <!-- 0.8 -->
			<add key="aiThrustErrorRangeMax" type="Number" value="7" /> <!-- 2.4 -->
			<add key="aiLeanRangeMin" type="Number" value="0.001" /> <!-- 0.3 -->
			<add key="aiLeanRangeMax" type="Number" value="5" /> <!-- 0.9 -->

			<add key="wallTextureBitmap" type="String" value="com.bored.games.assets.WallTexture_BMP" />
			<add key="wallTextureWidth" type="int" value="700" />
			<add key="wallTextureHeight" type="int" value="550" />

			<add key="boardTextureBitmap" type="String" value="com.bored.games.assets.DartboardTexture_BMP" />
			<add key="boardTextureWidth" type="int" value="236" />
			<add key="boardTextureHeight" type="int" value="237" />

			<add key="playerDartTexture" type="String" value="dartuv_plaid" />
			<add key="opponentDartTexture" type="String" value="dartuv_simon" />
			<add key="dartTextureWidth" type="int" value="256" />
			<add key="dartTextureHeight" type="int" value="256" />

			<add key="dartModelScale" type="Number" value="4" />

			<add key="boardCollisionMap" type="String" value="com.bored.games.assets.DartboardColorMap_MC" />

			<add key="cameraPositionX" type="Number" value="0" />
			<add key="cameraPositionY" type="Number" value="0" />
			<add key="cameraPositionZ" type="Number" value="-4" />

			<add key="defaultAngle" type="Number" value="10" />
			<add key="defaultGravity" type="Number" value="9.8" />
			<add key="defaultStartPositionX" type="Number" value="-1000" />
			<add key="defaultStartPositionY" type="Number" value="0" />
			<add key="defaultStartPositionZ" type="Number" value="0" />

			<add key="dartboardPositionX" type="Number" value="0" />
			<add key="dartboardPositionY" type="Number" value="0" />
			<add key="dartboardPositionZ" type="Number" value="5" />
			<add key="dartboardScale" type="Number" value="1.3" />

			<add key="cursorPositionZ" type="Number" value="4" />

			<add key="mochiDockPositionX" type="Number" value="17" />
			<add key="mochiDockPositionY" type="Number" value="10" />

			<add key="skipButtonPositionX" type="Number" value="590" />
			<add key="skipButtonPositionY" type="Number" value="505" />

			<add key="cricketScoreboardMovie" type="String" value="com.bored.games.assets.hud.CricketScoreboard_MC" />
			<add key="fiveOhOneScoreboardMovie" type="String" value="com.bored.games.assets.hud.FiveOhOneScoreboard_MC" />
			<add key="scoreboardPositionX" type="Number" value="80" />
			<add key="scoreboardPositionY" type="Number" value="200" />
			<add key="throwIndicatorMovie" type="String" value="com.bored.games.assets.hud.ThrowIndicatorV3_MC" />
			<add key="throwIndicatorPositionX" type="Number" value="645" />
			<add key="throwIndicatorPositionY" type="Number" value="410" />
			<add key="multiplayerThrowIndicatorMovie" type="String" value="com.bored.games.assets.hud.ThrowIndicatorV4_MC" />
			<add key="abilityDockMovie" type="String" value="com.bored.games.assets.hud.AbilityDock_MC" />
			<add key="abilityDockPositionX" type="Number" value="16" />
			<add key="abilityDockPositionY" type="Number" value="473" />
			<add key="cashPanelMovie" type="String" value="com.bored.games.assets.hud.Cash_MC" />
			<add key="cashPanelPositionX" type="Number" value="257" />
			<add key="cashPanelPositionY" type="Number" value="10" />
			<add key="controlPanelMovie" type="String" value="com.bored.games.assets.hud.ButtonPanel_MC" />
			<add key="controlPanelPositionX" type="Number" value="15" />
			<add key="controlPanelPositionY" type="Number" value="15" />
			<add key="dartDockMovie" type="String" value="com.bored.games.assets.hud.DartDock_MC" />
			<add key="dartDockPositionX" type="Number" value="637" />
			<add key="dartDockPositionY" type="Number" value="490" />

			<add key="sammyAccuracy" type="Number" value="0.02" />
			<add key="mackAccuracy" type="Number" value="0.2" />
			<add key="anthonyAccuracy" type="Number" value="0.4" /> <!-- would have been 5, but he hits 3 triples right away, so we artificially drop his accuracy to 0.3 -->
			<add key="simonAccuracy" type="Number" value="0.5" />
			<add key="ireneAccuracy" type="Number" value="0.7" />
			<add key="bigBillAccuracy" type="Number" value="0.8" />
			<add key="professorAccuracy" type="Number" value="0.9" />

			<add key="sammyStepScale" type="Number" value="0.05" />
			<add key="mackStepScale" type="Number" value="0.05" />
			<add key="anthonyStepScale" type="Number" value="0.05" />
			<add key="simonStepScale" type="Number" value="0.05" />
			<add key="ireneStepScale" type="Number" value="0.05" />
			<add key="bigBillStepScale" type="Number" value="0.05" />
			<add key="professorStepScale" type="Number" value="0.05" />

			<add key="simpleThrowUpdate" type="Number" value="33" />
			<add key="expertThrowUpdate" type="Number" value="50" />

			<add key="beelineSpeed" type="Number" value="16" />
		</appsettings>;
		
	}//end DefaultConfigs

}//end package
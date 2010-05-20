package com.gs.games.darts;

import it.gotoandplay.smartfoxserver.data.Room;
import it.gotoandplay.smartfoxserver.data.User;

import java.util.LinkedList;
import java.util.concurrent.TimeUnit;

import org.json.JSONObject;

import com.gs.games.TurnBasedExtension;
import com.gs.tasks.NextRoundTask;

public class Darts extends TurnBasedExtension {
		
	private int[] _boardArrangement = {6,13,4,18,1,20,5,12,9,14,1,8,16,7,19,3,17,2,15,10};
	private CricketScoreboard _scoreboard;
	
	public Darts() 
	{
		super();
		_scoreboard = new CricketScoreboard();
	}
	
	@Override
	public void handleReady(JSONObject jso, User u, int fromRoom)
	{
		super.trace("Darts::handleReady -- pid: " + u.getPlayerIndex());
		
		super.handleReady(jso, u, fromRoom);
		_scoreboard.registerPlayer(u.getPlayerIndex());
	} // End handleReady
	
	/**
	 * Save message from current player.
	 */
	@Override
	public boolean handleTurnUpdate(JSONObject jso, User u, int fromRoom)
	{
		Room rm = super.getRoom(fromRoom);
		
		if(super.handleTurnUpdate(jso, u, fromRoom))
		{
			double x0 = jso.optDouble("x");
			double y0 = jso.optDouble("y");
			double z0 = jso.optDouble("z");
			int thrust = jso.optInt("thr");
			int angle = jso.optInt("a");
			double theta = Math.PI / 180 * angle;
			double gravity = jso.optDouble("g");
			double lean = jso.optDouble("lean");
			double zF = jso.optDouble("zf");
			double step = jso.optDouble("step");
			
			double unitX = 1;
			double unitY = 0;
			
			double rotX = unitX * Math.cos(theta) - unitY * Math.sin(theta);
			double rotY = unitX * Math.sin(theta) + unitY * Math.cos(theta);
			
			double thrustVectorX = rotX * thrust;
			double thrustVectorY = rotY * thrust;
			
			double zDiff = zF - z0;
			double finalY = y0 + zDiff * (thrustVectorY / thrustVectorX) - .5 * Math.pow(zDiff, 2) * gravity / Math.pow(thrustVectorX, 2);
			double finalX = x0 + (zDiff / thrustVectorX) * lean * step;
			
			double coord_Theta = Math.atan2(finalY, finalX);
			double coord_Radius = Math.sqrt( finalX * finalX + finalY * finalY ) * 90;
			
			int coord_Angle = (int) (coord_Theta * 180 / Math.PI);
			if( coord_Angle < 0 ) coord_Angle += 360;
			
			int board_SectionIndex = Math.round(coord_Angle/18);
			if( board_SectionIndex >= 20 ) board_SectionIndex = 0;
			
			int board_Section = _boardArrangement[board_SectionIndex];
			int board_Multiplier = 1;
			if( coord_Radius < 3 ) {
				board_Section = 25;
				board_Multiplier = 2;
			} else if ( coord_Radius < 7 ) {
				board_Section = 25;
				board_Multiplier = 1;
			} else if ( coord_Radius < 56 && coord_Radius >= 52 ) {
				board_Multiplier = 3;
			} else if ( coord_Radius < 90 && coord_Radius >= 85 ) {
				board_Multiplier = 2;
			}
			
			_scoreboard.submitThrow(super._curPlayer.getPlayerIndex(), board_Section, board_Multiplier);
			
			jso = this.getJSONTurnUpdateObject(null);
			super.setJSONArg(jso, "action", "p_r");
			_scoreboard.getJSONObject(jso);
			super.setJSONArg(jso, "p", board_Section);
			super.setJSONArg(jso, "m", board_Multiplier);
			
			LinkedList ll = rm.getChannellList();
			
			super.sendResponse(jso, fromRoom, SERVER, ll);
			
			return true;
		}

		return false;
	}
	
	@Override
	public void checkRestrictions(int fromRoom, LinkedList<?> ll)
	{
		cleanExpiredFuture();

		User holdPlayer = _curPlayer;
		_curPlayer = null;

		if(_curTurn < _maxTurns)
		{
			// Do Next Turn for current player
			startTurn(fromRoom, ll, holdPlayer);
		}
		else if(_playedList.size() < _maxPlayers)
		{
			chooseNextPlayer(fromRoom);
		}
		else // if(_curRound < _maxRounds) /* Unnecessary to limit game rounds */
		{
			handleRoundEnd(fromRoom, ll);

			super.trace("Adding to scheduler NextRoundTask");
			// Create task to call nextRound in a number of seconds
			_expiredFuture = super._scheduler.schedule(new NextRoundTask(this,
					fromRoom, ll, null), _nrt, TimeUnit.SECONDS);
		}
		
		/* 
		else
		// Game End
		{
			handleRoundEnd(fromRoom, ll);

			handleGameEnd(fromRoom, ll);

			// Kick out all users for now
			Room rm = super.getRoom(fromRoom);
			User[] users = rm.getAllUsers();
			super.redirectUsers(users, fromRoom);
			super.destroyRoom(rm);
		}
		*/
		
		//TODO: Catch win condition for end of game.
	} // End checkRestrictions
}

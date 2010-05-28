package com.gs.games.darts;

import it.gotoandplay.smartfoxserver.data.Room;
import it.gotoandplay.smartfoxserver.data.User;

import java.nio.channels.SocketChannel;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.concurrent.TimeUnit;

import org.json.JSONException;
import org.json.JSONObject;

import com.gs.games.TurnBasedExtension;
import com.gs.tasks.NextRoundTask;

public class Darts extends TurnBasedExtension {
			
	private int[] _boardArrangement = {6,13,4,18,1,20,5,12,9,14,1,8,16,7,19,3,17,2,15,10};
	private Scoreboard _scoreboard;
	private boolean _bullOff = false;
	private HashMap<Integer, Double> _bullOffResults;
	private int _bullOffWinner = -1;
	private DartSkin[] _playerSkins;
	
	private long _startTime;
	private long _endTime;
	
	private int[] _doublesCount;
	private int[] _triplesCount;
	
	private int[] _throwsCount;
	
	public Darts() 
	{
		super();
	
		_scoreboard = new CricketScoreboard();
		//_scoreboard = new FiveOhOneScoreboard();
		_bullOffResults = new HashMap<Integer, Double>();
		_playerSkins = new DartSkin[super._maxPlayers];
		
		_doublesCount = new int[super._maxPlayers];
		_triplesCount = new int[super._maxPlayers];
		
		_throwsCount = new int[super._maxPlayers];
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public boolean handleReady(JSONObject jso, User u, int fromRoom)
	{
		_scoreboard.registerPlayer(u.getPlayerIndex());
		
		_bullOffResults.put(u.getPlayerIndex(), -1.0);
		
		DartSkin skin = new DartSkin();
		skin.skinid = jso.optString("skinid");
		skin.flightid = jso.optString("flightid");
		
		_playerSkins[u.getPlayerIndex()-1] = skin;
				
		if(_bGameStart)
		{
			super.trace("Game already started for user " + u.getName() + ".\n");
			return false;
		}

		if(_readyPlayersSet.contains(u))
		{
			super.trace("User " + u.getName() + " already sent a ready message.\n");
			return _bGameStart;
		}

		super.trace("::handleReady adding client " + u.getName()
				+ " to ready set.\n");

		_readyPlayersSet.add(u);

		super.trace("::handleReady Ready Set contains " + _readyPlayersSet.size()
				+ " users.\n");

		Room rm = super.getRoom(fromRoom);

		/**
		 * We are assuming that game rooms are created
		 * with max number of players as there are
		 * currently sending READY messages
		 */

		// Find state and channel list
		LinkedList<SocketChannel> ll;
		String state;
		// Are all players ready?
		if(_readyPlayersSet.size() == rm.getMaxUsers())
		{
			state = GAME_START;
			ll = rm.getChannellList();
			_bGameStart = true;
			jso = new JSONObject();
			try {
				for( int i = 0; i < _playerSkins.length; i++ ) {
					jso.put("skin_" + (i+1), _playerSkins[i].getJSONObject());
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else
		// Wait for other players to be ready
		{
			state = GAME_WAIT;
			ll = new LinkedList<SocketChannel>();
			ll.add(u.getChannel());
			jso = new JSONObject();
		}

		super.trace("::handleReady Sending " + state + " to client " + u.getName());
		
		// Create JSON object and send decided state
		JSONObject js = getJSONStateObject(state, jso);
		super.trace("JSON object " + js + ".\n");
		super.sendResponse(js, fromRoom, SERVER, ll);

		if(_bGameStart)
		{
			_curRound = 0;
			
			_startTime = System.currentTimeMillis();
			
			_bullOff = true;

			jso = new JSONObject();
			try {
				jso.put("bulloff", _bullOff);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			
			// Send ROUND_START to all users
			nextRound(fromRoom, null, jso);
		}

		return _bGameStart;
	} // End handleReady
	
	/**
	 * Save message from current player.
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean handleTurnUpdate(JSONObject jso, User u, int fromRoom)
	{
		Room rm = super.getRoom(fromRoom);
		
		LinkedList<SocketChannel> ll = (LinkedList<SocketChannel>) rm.getChannellList();
		
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
						
			coord_Theta += 2*Math.PI;
			coord_Theta = coord_Theta % (2*Math.PI);
			
			int coord_Angle = (int) ( coord_Theta * 180 / Math.PI);
			if( coord_Angle < 0 ) coord_Angle += 360;
			
			int board_SectionIndex = (int) Math.round(coord_Angle/18.0);
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
			
			if( _bullOff ) {
				double dx = 0.0 - finalX;
				double dy = 0.0 - finalY;
				
				double dist = Math.sqrt( dx * dx + dy * dy );
				
				_bullOffResults.put(super._curPlayer.getPlayerIndex(), dist);
				
				User[] users = rm.getAllPlayers();
				
				boolean bullOffComplete = true;
				
				for( int i = 0; i < users.length; i++ )
				{				
					double result = _bullOffResults.get(users[i].getPlayerIndex());
					
					if( result < 0 )
					{
						bullOffComplete = false;
					}
				}
				
				jso = this.getJSONTurnUpdateObject(null);
				super.setJSONArg(jso, "action", "p_r");
				super.setJSONArg(jso, "p", board_Section);
				super.setJSONArg(jso, "m", board_Multiplier);
				
				super.sendResponse(jso, fromRoom, SERVER, ll);
				
				double minDist = Double.MAX_VALUE;
				if( bullOffComplete )
				{
					for(int i = 0; i < users.length ; i++)
					{
						if( minDist > _bullOffResults.get(users[i].getPlayerIndex()) )
						{
							minDist = _bullOffResults.get(users[i].getPlayerIndex());
							_bullOffWinner = users[i].getPlayerIndex();
						}
					}
					
					_bullOff = false;
				}
			} else {
				
				if( board_Multiplier == 2 )
				{
					_doublesCount[super._curPlayer.getPlayerIndex()-1]++;
				}
				else if( board_Multiplier == 3 )
				{
					_triplesCount[super._curPlayer.getPlayerIndex()-1]++;
				}
				
				_throwsCount[super._curPlayer.getPlayerIndex()-1]++;
				
				_scoreboard.submitThrow(super._curPlayer.getPlayerIndex(), board_Section, board_Multiplier, super._curTurn);
				
				jso = this.getJSONTurnUpdateObject(null);
				super.setJSONArg(jso, "action", "p_r");
				super.setJSONArg(jso, "p", board_Section);
				super.setJSONArg(jso, "m", board_Multiplier);
				
				try {
					_scoreboard.getJSONObject(jso);
								
					super.sendResponse(jso, fromRoom, SERVER, ll);
					
					if( _scoreboard.checkForWin(super._curPlayer.getPlayerIndex()) )
					{
						_endTime = System.currentTimeMillis();
						
						finishGame(fromRoom, ll, super._curPlayer.getPlayerIndex());
					}
				} catch( Exception e ) {}
			}
			
			return true;
		}

		return false;
	}
	
	@Override
	protected User getNextPlayer(User[] players)
	{
		User nextPlayer = null;
		
		if( _bullOffWinner > 0 && _playedList.isEmpty() )
		{
			super.trace("Bulloff Winner: " + _bullOffWinner);
			
			nextPlayer = players[_bullOffWinner-1];
			_playedList.add(nextPlayer);
		} else {
			int total = players.length;
			for(int i = 0; i < total; i++)
			{
				// Check played vector list
				if(_playedList.contains(players[i]))
				{
					continue;
				}
	
				nextPlayer = players[i];
				_playedList.add(nextPlayer);
				break;
			}
		}

		return nextPlayer;
	}
	
	@Override
	public void checkRestrictions(int fromRoom, LinkedList<SocketChannel> ll)
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
	} // End checkRestrictions
	
	private void finishGame(int fromRoom, LinkedList<SocketChannel> ll, int winner) throws JSONException
	{
		Room rm = super.getRoom(fromRoom);
		
		User[] users = rm.getAllPlayers();
		
		handleRoundEnd(fromRoom, ll);

		// GAME_END message
		super.sendResponse(super.getJSONStateObject(GAME_END, null), fromRoom,
				SERVER, ll);

		// GAME_RESULTS message
		JSONObject jso = getJSONGameResultObject(null);
		jso.put("gameTime", (_endTime - _startTime));
		for( int i = 0; i < users.length; i++ ) {
			jso.put("doubles_" + users[i].getPlayerIndex(), _doublesCount[i]);
			jso.put("triples_" + users[i].getPlayerIndex(), _triplesCount[i]);
			jso.put("throws_" + users[i].getPlayerIndex(), _throwsCount[i]);
		}
		jso.put("winner", winner);
		super.sendResponse(jso, fromRoom, SERVER, ll);

		// Kick out all users for now
		/*
		Room rm = super.getRoom(fromRoom);
		User[] users = rm.getAllUsers();
		super.redirectUsers(users, fromRoom);
		super.destroyRoom(rm);
		*/
	}
}

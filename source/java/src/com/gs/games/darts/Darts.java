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
	protected Scoreboard _scoreboard;
	private boolean _bullOff = false;
	private HashMap<Integer, Double> _bullOffResults;
	private int _bullOffWinner = -1;
	
	private long _startTime;
	private long _endTime;
	
	private long _roundTime = 30;
	
	private HashMap<Integer, DartsPlayer> _players;
		
	public Darts() 
	{
		super();
	
		_scoreboard = new CricketScoreboard();
		_bullOffResults = new HashMap<Integer, Double>();
		
		_players = new HashMap<Integer, DartsPlayer>();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public boolean handleReady(JSONObject jso, User u, int fromRoom)
	{
		_scoreboard.registerPlayer(u.getPlayerIndex());
				
		DartsPlayer d = new DartsPlayer(u.getPlayerIndex());
		d.setSkinId(jso.optString("skinid"));
		d.setFlightId(jso.optString("flightid"));
		_players.put(u.getPlayerIndex(), d);
		
		_bullOffResults.put(u.getPlayerIndex(), -1.0);
				
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
			
			for( DartsPlayer player : _players.values() ) {
				player.addSkinJSON(jso);
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
			
			// Send ROUND_START to all users
			// nextRound(fromRoom, null, jso);
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
		
		if(super.handleTurnUpdate(jso, u, fromRoom) || _bullOff)
		{
			double x0 = jso.optDouble("x");
			double y0 = jso.optDouble("y");
			double z0 = jso.optDouble("z");
			double thrust = jso.optDouble("thr");
			double angle = jso.optDouble("a");
			double theta = Math.PI / 180 * angle;
			double gravity = jso.optDouble("g");
			double lean = jso.optDouble("lean");
			double zF = jso.optDouble("zf");
			double step = jso.optDouble("step");
			
			double unitX = 1;
			double unitY = 0;
			
			System.out.println("thrust: " + thrust);
			System.out.println("theta: " + theta);
			
			double rotX = unitX * Math.cos(theta) - unitY * Math.sin(theta);
			double rotY = unitX * Math.sin(theta) + unitY * Math.cos(theta);
			
			double thrustVectorX = rotX * thrust;
			double thrustVectorY = rotY * thrust;
			
			System.out.println("thrustVectorX: " + thrustVectorX);
			System.out.println("thrustVectorY: " + thrustVectorY);
			
			double zDiff = zF - z0;
			double finalY = y0 + zDiff * (thrustVectorY / thrustVectorX) - .5 * Math.pow(zDiff, 2) * gravity / Math.pow(thrustVectorX, 2);
			double finalX = x0 + zDiff * lean * step;
			
			System.out.println("finalX: " + finalX);
			System.out.println("finalY: " + finalY);
			
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
			} else if ( coord_Radius >= 90 ) {
				board_Section = 0;
				board_Multiplier = 0;
			}
			
			if( _bullOff ) {
				double dx = 0.0 - finalX;
				double dy = 0.0 - finalY;
				
				double dist = Math.sqrt( dx * dx + dy * dy );
				
				_bullOffResults.put(u.getPlayerIndex(rm), dist);
				
				User[] users = rm.getAllPlayers();
				
				boolean bullOffComplete = true;
				
				for( Double result : _bullOffResults.values() ) {
					if( result < 0 )
					{
						bullOffComplete = false;
					}
				}
				
				double minDist = Double.MAX_VALUE;
				if( bullOffComplete )
				{
					for(int i = 0; i < users.length ; i++)
					{
						System.out.println("_bullOffResults: " + _bullOffResults.toString());
						System.out.println("user["+i+"]:" + users[i]);
						System.out.println("Player Index: " + users[i].getPlayerIndex());
						
						if( minDist > _bullOffResults.get(users[i].getPlayerIndex()) )
						{
							minDist = _bullOffResults.get(users[i].getPlayerIndex());
							_bullOffWinner = users[i].getPlayerIndex();
						}
					}
					
					_bullOff = false;
					
					jso = new JSONObject();
					try{
						jso.put("first", _bullOffWinner);
					} catch( Exception e ) {}
					
					nextRound(fromRoom, null, jso);
				}
			} else {				
				DartsPlayer p = _players.get(super._curPlayer.getPlayerIndex());
				
				if( board_Multiplier == 2 )
				{
					p.addDoubleScore();
				}
				else if( board_Multiplier == 3 )
				{
					p.addTripleScore();
				}
				
				p.addThrow();
				
				if( _scoreboard.submitThrow(super._curPlayer.getPlayerIndex(), board_Section, board_Multiplier, super._curTurn) )
				{
					p.addScoringThrow();
				}
				else
				{
					p.resetScoringThrows();
				}
				
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
	
	/**
	 * Start timer when a turn starts.
	 */
	@Override
	protected void startTurn(int fromRoom, LinkedList<SocketChannel> ll,
			User nextPlayer)
	{
		super.startTurn(fromRoom, ll, nextPlayer);

		// Create game timer and store into map using the current player as the key
		super.startSecondsTimer(1L, 1L, _roundTime, nextPlayer, fromRoom);
	}
	
	/**
	 * Send GAME_TIMER_END and check which user let the game timer end
	 * to send appropriate message to clients to proceed.
	 */
	@Override
	protected void sendGameTimerEnd(User u, int fromRoom)
	{
		super.sendGameTimerEnd(u, fromRoom);

		chooseNextPlayer(fromRoom);
	}
	
	private void finishGame(int fromRoom, LinkedList<SocketChannel> ll, int winner) throws JSONException
	{
		handleRoundEnd(fromRoom, ll);
		
		Room rm = super.getRoom(fromRoom);
		
		User[] users = rm.getAllPlayers();
		for( int i = 0; i < users.length; i++ )
		{
			this.removeGameTimer(users[i]);
		}

		// GAME_END message
		super.sendResponse(super.getJSONStateObject(GAME_END, null), fromRoom,
				SERVER, ll);

		// GAME_RESULTS message
		JSONObject jso = getJSONGameResultObject(null);
		jso.put("gameTime", (_endTime - _startTime));
		for( DartsPlayer player : _players.values() ) {
			player.addStatsJSON(jso);
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

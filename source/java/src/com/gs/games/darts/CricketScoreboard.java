package com.gs.games.darts;

import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;


public class CricketScoreboard extends Scoreboard {
	
	public static int EMPTY 		= 0;
	public static int STROKE_LEFT 	= 1;
	public static int STROKE_RIGHT	= 2;
	public static int CLOSED_OUT	= 3;
	
	private HashMap<Integer, HashMap<Integer, Integer>> _scoreMap;
	
	public CricketScoreboard() {
		_scoreMap = new HashMap<Integer, HashMap<Integer, Integer>>();
	}
	
	public void registerPlayer(int pid) {	
		System.out.println("CricketScoreboard::registerPlayer(" + pid + ")");
		
		HashMap<Integer, Integer> playerScores = new HashMap<Integer, Integer>();
		playerScores.put(15, EMPTY);
		playerScores.put(16, EMPTY);
		playerScores.put(17, EMPTY);
		playerScores.put(18, EMPTY);
		playerScores.put(19, EMPTY);
		playerScores.put(20, EMPTY);
		playerScores.put(25, EMPTY);
		
		_scoreMap.put(pid, playerScores);
	}
	
	public boolean checkForWin(int player) {
		HashMap<Integer, Integer> stats = _scoreMap.get(player);
	
		boolean win = true;
	
		for ( int i = 15; i <= 20; i++ ) {
			if ( stats.get(i) < 3 ) win = false;
		}
		if ( stats.get(25) < 3 ) win = false;
	
		return win;
	}
		
	public boolean submitThrow(int player, int points, int multiplier, int turn, int round) {
		System.out.println("CricketScoreboard::submitThrow(" + player + ", " + points + ", " + multiplier + ")");
		
		System.out.println("scoreMap["+player+"] -> " + _scoreMap.get(player));
		
		HashMap<Integer, Integer> map = _scoreMap.get(player);
		
		if( map != null && ( (points >= 15 && points <= 20) || points == 25 ))
		{
			int score = map.get(points);
			
			if( score < CLOSED_OUT ) 
			{
				if ( (score + multiplier) >= 3 ) 
				{
					score += CLOSED_OUT;
				}
				else score += multiplier;
				
				_scoreMap.get(player).put(points, score);
				
				return true;
			}
			else
			{
				return false;
			}
		}
		else return false;
	}
	
	public void getJSONObject(JSONObject jso) throws JSONException {
		
		net.sf.json.JSONObject map = new net.sf.json.JSONObject();
		map.putAll(_scoreMap);
		
		jso.put("scores", map.toString());
	}
}

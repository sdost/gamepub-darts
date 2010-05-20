package com.gs.games.darts;

import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;

public class CricketScoreboard {
	
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
	
	public boolean submitThrow(int player, int points, int multiplier) {
		System.out.println("CricketScoreboard::submitThrow(" + player + ", " + points + ", " + multiplier + ")");
		
		System.out.println("scoreMap["+player+"] -> " + _scoreMap.get(player));
		
		int score = _scoreMap.get(player).get(points);
		
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
	
	public void getJSONObject(JSONObject jso) {
		try {
			jso.putOpt("scores", _scoreMap);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

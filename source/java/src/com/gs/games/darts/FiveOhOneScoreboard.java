package com.gs.games.darts;

import java.util.HashMap;
import java.util.Vector;

import org.json.JSONException;
import org.json.JSONObject;


public class FiveOhOneScoreboard extends Scoreboard {
	
	public static int FIVE_OH_ONE 		= 501;
	
	private int _lastRound = -1;
	private int _lastTurn = -1;
	private int _lastPlayer = -1;
	private boolean _newTurn;
	private boolean _busted;
	
	private HashMap<Integer, Vector<Integer>> _scoreMap;
	
	public FiveOhOneScoreboard() {
		_scoreMap = new HashMap<Integer, Vector<Integer>>();
	}
	
	public void registerPlayer(int pid) {	
		System.out.println("CricketScoreboard::registerPlayer(" + pid + ")");
		
		Vector<Integer> scoreList = new Vector<Integer>();
		
		_scoreMap.put(pid, scoreList);
	}
	
	public boolean checkForWin(int player) {
		
		System.out.println("Score Map: " + _scoreMap);
		
		Vector<Integer> scoreList = _scoreMap.get(player);
		
		int score = 0;
		
		for( int i = 0; i < scoreList.size(); i++ )
		{
			score += scoreList.get(i).intValue();
		}
		
		if( score < 501 )
		{
			return false;
		}
		
		return true;
	}
	
	public boolean submitThrow(int player, int points, int multiplier, int turn, int round) {
		
		if( _lastRound == round && _lastTurn == turn && _lastPlayer == player )
		{
			_newTurn = false;
		}
		else
		{
			_lastPlayer = player;
			_lastTurn = turn;
			_lastRound = round;
			_newTurn = true;
			_busted = false;
		}
		
		Vector<Integer> scoreList = _scoreMap.get(player);
		
		int score = 0;
		
		for( int i = 0; i < scoreList.size(); i++ )
		{
			score += scoreList.get(i);
		}
		
		int temp = score + (points * multiplier);
		
		System.out.println("Temp: " + temp);
		
		if( temp < FIVE_OH_ONE && (FIVE_OH_ONE - temp) > 1 )
		{
			if( _newTurn ) {
				scoreList.add(points * multiplier);
			} else {
				int s = scoreList.get(scoreList.size()-1);
				s += (points * multiplier);
				scoreList.set(scoreList.size()-1, s);
			}
			_scoreMap.put(player, scoreList);
			
			return true;
		} 
		else if ( temp == FIVE_OH_ONE )
		{
			if( points >= 1 && multiplier == 2 )
			{
				if( _newTurn ) {
					scoreList.add(points * multiplier);
				} else {
					int s = scoreList.get(scoreList.size()-1);
					s += (points * multiplier);
					scoreList.set(scoreList.size()-1, s);
				}
				_scoreMap.put(player, scoreList);
				
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			_busted = true;
			return false;
		}
	}
	
	public void getJSONObject(JSONObject jso) throws JSONException {
		
		net.sf.json.JSONObject map = new net.sf.json.JSONObject();
		map.putAll(_scoreMap);
		
		jso.put("scores", map.toString());
		jso.put("busted", _busted);
	}
}
